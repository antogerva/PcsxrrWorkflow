---
--@module controller

local M={}

package.path = ";./src/?.lua;/.src/?.lua;./src/controller/?.lua;./dll/?.lua;./?.lua;../lua/?.lua;" ..package.path
package.cpath = ";./src/?.dll;/.src/?.dll;./src/controller/?.dll;./dll/?.dll;./?.dll;../lua/?.dll;" ..package.cpath


--local conf=require("model.config");
--local geoo=require("geometry");

local lfs=require("lfs")
local config=require("model.config")
local pxmMovie=require("model.pxmMovie")
local movie=require("embedded.movie");
local setting=require("model.setting")

local C={conf=config.new(),setting=setting}

function M.loadconfig()

end

function M.getDefaultConfigPath()
  
end


--Usual start from the detection script
function M.detection()  
  local key = {
  --"V", "B"
  }
  local now = {};
  local lastframe = {}
  local function KeyEvent()
    for k, v in pairs(key) do
      now[k] = input.get()[v]
      now[v] = now[k];
      if now[k] and not lastframe[k] then
        print(v)
        if (v=="V") then
          print("load spuTAS")
          pcsx.switchspu("spuTAS.dll");
        elseif (v=="B") then
          print("load spuEternal")
          pcsx.switchspu("spuEternal.dll");
        end
      end
      lastframe[k] = now[k]
      lastframe[v] = now[k]
    end
  end
  
  gui.register(KeyEvent)
  gui.clearuncommitted();
  
  
  local movieData = pxmMovie.new(C.conf.confData.Movie,nil,nil);
  
  
  --init();
  lfs.chdir(lfs.currentdir());
  print("The movie \"" .. movieData.movieName .. "\" will now be loaded.")
  movie.load(movieName)
  movieEnd = movie.length();
  lfs.chdir(currentPath);
  
  print("Using workflow at: \"" .. pcsxrrEncodeWofkflowPath .. "\"" .. encodeWorkflowFolder .. "\"")
  checkRequirements();
  print("Starting up the detection script!!!");
  
  if(restartProcessing == false) then
    print("Ok then. Now we will assume that the screenshot processing is already done.")
    print("But first, let's make sure we have at least one \"checkpoint backup\" by the begginning of the movie.")
    while(emu.framecount()~= checkPoint[1]) do --TODO: first checkpoint backup should be the first non-laggy frame of the movie
      emu.frameadvance()
      print(string.format("frame %025.f ", emu.framecount()))
    end
    changeSpuRegKey("spuEternal_b.dll")
  
    print("Now awaiting for any incoming desync.")
    suspendCount = 0;
  
    while true do
      pcsx.suspend(50); --Do some 'work' here"
      --checkSyncClipBoardUpdate();
      checkSyncTokenUpdate();
  
      suspendCount = suspendCount +1;
      if(suspendCount % 100 ==0) then
        print("Waiting... " .. suspendCount)
      end
    end
  else
    --Once the requirements are met, the script can enter in the main loop
    while true do
      --metricsPerFrame = startBenchMark();
      --checkLaglessZone();
      --checkSyncClipBoardUpdate();
  
      if (frameHashedProcessed < movieEnd + afterEndMovieStopOffset) then
        saveHashCode()
      end
  
      --unsure if we should that this here...
      --checkSyncClipBoardUpdate();
      --checkSyncTokenUpdate();
  
      if (emu.framecount() == movieEnd and movieEnd >= frameHashedProcessed) then
        createSaveState(emu.framecount(), false)
        print("Reached the last input from the pxm")
        print("Please do no stop script yet... we will hash few more frame")
      elseif (emu.framecount() == movieEnd+afterEndMovieStopOffset+100) then --TODO: Have a value for killing the app
        print("Reached Movie END")
        print("Now you need to STOP the script and restart the movie")
        print("Then please restart the detection script.")
        os.execute("echo Reached Movie END " .. "&& pause");
        --emu.pause();
      end
  
--      if(emu.framecount() == movieEnd and movieEnd < frameHashedProcessed) then
--        print("*************************************************")
--        print("Processing over, now \"patrolling\" from the first checkpoint (frame " .. checkPoint[1] .. ")")
--        print("*************************************************")
--        config.oldStateLoader(checkPoint[1]) --just reload the first checkpoint to keep running the script in loop
--        showLagOccurence = false;
--        gui.text(10,  10, "Now in patrolling mode to check" );
--        gui.text(10,  20, "if any desync happen in an another pcsxrr instance" );
--      end
  
      emu.frameadvance();
      config.writeStatusDetectInfo("processing", frameHashedProcessed);
  
      --print("Time for 1 frame: " .. stopBenchMark(metricsPerFrame) .. "ms")
    end
  end  
end


function M.fixDesyncFrame(desyncFound)
  print("Now trying fix the desync at frame " .. desyncFound .. " ...")
  checkPointFrame = getNearestCheckPoint(desyncFound);

  if(checkPointFrame == 0) then
    --TODO: Alway make a savestate on first non-laggy frame?
    print("No savestate/checkpoint found near the desync, the emulator will reset.");
    emu.pause();    
    movie.load(movieName) --meh, reseting might still cause desync... TODO: Do something about that
  elseif (checkPointFrame~=emu.framecount()) then
    config.oldStateLoader(checkPointFrame) --load the nearest savestate
  end

  while true do
    if(emu.framecount() == desyncFound) then
      createSaveState(emu.framecount(), true)
      table.insert(fixedDesync, desyncFound);
      table.sort(fixedDesync)
      config.fixedDesync = fixedDesync;

      writeStatusDetectInfo("processing", frameHashedProcessed);
      print("Desync at frame " .. desyncFound .. " seem to be fixed.")
      return;
    end
    emu.frameadvance();
  end  
end


---TODO
-- @function [parent=#controller] new
-- @return #controller
function M.new()
  return M;
end  

return M;