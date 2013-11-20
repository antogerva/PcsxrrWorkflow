---
-- @module hashframe
--TODO
local M = {}


--Seek the line of the file
function getHashFromFile(framecount)    
  filename =  screenshotFolder .. "/" .. hashFileName .. "-" .. math.floor(framecount / hashFrameSplit) .. ".txt";

  moviePos = ((framecount/screenshotOffSet)*50 -50); --each line has 50char, so it should work 
  movieFile = io.open(filename, "rb") 
  movieFile:seek("set", moviePos); --Seek might take more and more time as the file grow... that's why the file have to be splitted once in a while 
  
  currentLine = movieFile:read("*l");   
  io.close(movieFile)
  
  if (currentLine == nil and emu.framecount() >= movieEnd) then
    print("MOVIE IS OVER !!! ");
    os.execute("echo MOVIE IS OVER !!! " .. "&& pause");      
    --emu.pause();
    --TODO: Close the script here?
    if(movie.mode() == nil) then
      print("Now placing a token for final pass, we won't have to check hash again.")
      setFinalPassToken();
      print("Closing the script...");
      emu.frameadvance();
      pcsx.quit();
    end
  elseif (currentLine == nil) then
    print("Please make sure the detection for the screenshot is over, before running this script.");
    print("Waiting for an update status...");
    --os.execute("echo Waiting for an update status..." .. "&& pause"); 
    writeStatusSyncInfo("waiting", emu.framecount())
  end       

  frameInfo = checkFrame(currentLine);
  if(frameInfo ~= nil and frameInfo["frame"] == framecount) then  
    return frameInfo["hash"] -- realhash from file
  elseif(emu.framecount() > movieEnd) then
    print("Sync script is over. You can close the script now."); 
    --os.execute("echo You can close the script now." .. "&& pause");   
    return 0;
  else
    print("File Desynch : Currentframe " .. frameInfo["frame"] .. " - actual " .. emu.framecount())
    print("Unexpected error : make sure the file at \"" .. filename .. "\" doesn't have any corrupted data.")
    printStack();
    emu.pause()
    return nil;     
  end
end



function checkFrame(currentLine)
  if(currentLine == nil) then
    if(emu.framecount()>=movieEnd) then
      return;
    end
    print("Unexpected error. Missing some frame info in the hashframe file.");
    printStack();
    emu.pause();
  end

  currentFrame = currentLine:match("[^%a ]+[^ ]");
  realhashCode = currentLine:match("[^ ]*$"); 

  frameInfo = {
    ["frame"] = tonumber(currentFrame),
    ["hash"]  = tonumber(realhashCode)
  }   
  return frameInfo;
end



return M;