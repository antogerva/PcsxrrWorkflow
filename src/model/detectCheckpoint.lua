---
-- @module detectCheckpoint

local M = {}
require "gd"
require "lfs"
require 'luaxml'
--require "pcsxrrWorkflowConfig"
--dofile  "pcsxrrWorkflowConfig.lua" --will the reload this file as well when pressing "restart"

--require "socket"

local pcsxrrVersion = "pcsx-rr13c";
local emu = pcsx;

local currentScreenShotProcess = 0;
local moviePos = 0;
local startProcess = false;
local tmpLaglessFrame = nil
local restartProcessing = nil;

local stateProcess = ""
local showLagOccurence = true;
--[[
function init()
--Actually, I just map these setting from pcsxrrWorkflowConfig,
--so my text editor can easily detect/autoplete from there...
config = pcsxrrWorkflowConfig;
config.setting();

pcsxrrVersion = config.pcsxrrVersion;
emu = config.emu;

checkPoint = config.checkPoint;
possibleDesync = config.possibleDesync;
fixedDesync = config.fixedDesync;

currentPath = config.currentPath;

encodeMode = config.encodeMode;
showEncodeErrorWarning = config.showEncodeErrorWarning;

saveStateOffSet = config.saveStateOffSet;
screenshotOffSet = config.screenshotOffSet;
startProcessFrame = config.startProcessFrame;
afterEndMovieStopOffset = config.afterEndMovieStopOffset;
busyWaitOffset = config.busyWaitOffset;
finalPass = config.finalPass;

movieName = config.movieName;
movieEnd = config.movieEnd;
movieSaveStateFolder = config.movieSaveStateFolder;

pcsxrrEncodeWofkflowPath = config.pcsxrrEncodeWofkflowPath;
encodeWorkflowFolder = config.encodeWorkflowFolder;
saveStateFolder = config.saveStateFolder;
desyncSaveStateFolder = config.desyncSaveStateFolder;
screenshotFolder = config.screenshotFolder;
imgScreenshotFolder = config.imgScreenshotFolder;
tokenMediatorFolder = config.tokenMediatorFolder;
screenshotOutput = config.screenshotOutput;
hashFrameSplit = config.hashFrameSplit;

imgName = config.imgName;
saveStateName = config.saveStateName;
desyncSaveStateName =  config.desyncSaveStateName;
hashFileName = config.hashFileName;
desyncLogFileName = config.desyncLogFileName;

firstLaglessFrameZone = config.firstLaglessFrameZone;
firstLaglessFrameZoneOffset = config.firstLaglessFrameZoneOffset;
lastLaglessFrame = config.lastLaglessFrame;

--function
getHashCode = config.getHashCode;
stringHash = config.stringHash;
writeStatusDetectInfo = config.writeStatusDetectInfo;
getStatusSyncInfo = config.getStatusSyncInfo;
writeStatusSyncInfo = config.writeStatusSyncInfo;
getStatusDetectInfo = config.getStatusDetectInfo;
getNearestCheckPoint = config.getNearestCheckPoint;
createSaveState = config.createSaveState;
printStack = config.printStack;
parseClipboardString = config.parseClipboardString;
setClipboardString = config.setClipboardString;
changeSpuRegKey = config.changeSpuRegKey;
getToken = config.getToken;
setToken = config.setToken;
getFinalPassToken = config.getFinalPassToken;
setFinalPassToken = config.setFinalPassToken;

startBenchMark = config.startBenchMark;
stopBenchMark = config.stopBenchMark;

frameHashedProcessed = config.frameHashedProcessed;

if(movie.mode() ~= nil) then
emu.speedmode("normal") -- emulator runs at max speed without frameskip
end

--Before starting the main process of this script some requirement have to checked.
--config.createDir();
end
--]]


--write in a file the hash value of the current screenshot
function M.saveHashCode()
  --if(emu.framecount() % screenshotOffSet == 0) and (emu.framecount() >= startProcessFrame) then
  if(emu.framecount() % screenshotOffSet == 0) then
    hashCode = config.getHashCode();
    lineInfo = string.format("frame %025.f : %014.f", emu.framecount(), hashCode); --each line produce 50char with the "return" char

    print(string.format("frame %025.f : %014.f", emu.framecount(), hashCode))
    writeHashframe(lineInfo);
    lastLaglessFrame = emu.framecount()
    frameHashedProcessed = emu.framecount()

  end
end

function M.writeHashframe(lineInfo)
  fileName = screenshotFolder .. "/" .. hashFileName .. "-" .. math.floor(emu.framecount() / hashFrameSplit) ..  ".txt";
  hashFrameFile = io.open (fileName, "a+")
  hashFrameFile:write(lineInfo .. "\n")
  io.close(hashFrameFile)
  currentScreenShotProcess = emu.framecount();
end

--Create a saveState if the current frame is in the checkpoint list or match the savestate Offset for screenshot
function M.checkSaveState()
  for k, frameCheckPoint in ipairs(checkPoint) do --TODO: Need some function fill the checkPoint collection
    if (emu.framecount() == frameCheckPoint) then
      print("Frame " .. emu.framecount() .. " : new savestate");
      createSaveState(emu.framecount(), false);
      return;
    end
  end

  --Backup to help for navigating thought the movie...
  if (emu.framecount() % saveStateOffSet == 0 and emu.framecount() ~= 0) then
    print("Frame " .. emu.framecount() .. " : new savestate backup");
    createSaveState(emu.framecount(), false);
  elseif (emu.framecount() == movieEnd) then
    createSaveState(emu.framecount(), false);
  end
end

--Make sure all requirements are fine before starting the process
function M.checkRequirements()
  previousDetect = getHashedScreenshotFramePos();
  if (previousDetect ~= 0 and previousDetect == emu.framecount()) then
    print("The script found some old data from a previous a detection script.")
    print("Resuming the process at frame " .. previousDetect)
    --TODO: Ask user to continue processing?
    --emu.frameadvance();
    return;
  elseif (previousDetect ~= 0 and previousDetect > movieEnd) then
    print("Some data found from a previous detection script.")
    print("The detection seem already to be done. (up to frame " .. previousDetect .. ")")
    restartProcessing = false; -- New Patrol mode?
    return;
  elseif (previousDetect ~= 0) then
    restartProcessing = gui.popup("Do you want to restart the whole processing instead of resuming at frame ".. previousDetect .. " ?",  "yesno")
    print(restartProcessing)
    if(restartProcessing == "no") then
      restartProcessing = false;
      return;
    end
  else
    print("No previous data found.")
  end

  previousDetectData = getStatusDetectInfo();
  --isTableEmpty = next(previousDetectData) == nil; --somehow you can't use length(#) on a hashtable in lua
  startProcess=true;
  while (startProcess) do
    if (emu.framecount() == 1 and restartProcessing ~= false) then
      print("Starting clean up process")
      --Clean the hashframe folder...
      for file in lfs.dir(screenshotFolder) do
        if lfs.attributes(file,"mode") ~= "directory" and file:find(hashFileName) ~= nil then
          --TODO: Make Backup
          filename = screenshotFolder .. "/" .. file
          print("Clean up : Deleting file " .. filename)
          os.remove(filename);
        end
      end

      print("Starting process at the first \"non laggy\" frame")
      while(emu.lagged()) do
        emu.frameadvance()
      end
      --pcsx.redrawscreen();
      print("Beginning processing at frame: " .. emu.framecount());
      for i=1, emu.framecount()-1,1 do
        --here the hashcode value of the screenshot is 0 for the "gap" when reseting the game
        print(string.format("frame %025.f : %014.f", i, 0))
        writeHashframe(string.format("frame %025.f : %014.f", i, 0))
      end
      --make the first savestate/checkpoint backup,
      --since this is first place where the emulator is stable enough to make a savestate
      createSaveState(emu.framecount(), false);
      return;
    end

    if(emu.framecount() ~= 0 and emu.framecount() == previousDetectData["CurrentScreenShotProcess"]) then
      print("Unpause the emulator in order to restart the process from frame " .. emu.framecount());
      emu.pause()
      print("Resuming processing...");
      return;
    end
    emu.frameadvance()
    --config.writeStatusDetectInfo("restarting", frameHashedProcessed);
  end
end

function M.getHashedScreenshotFramePos()
  line = nil;
  lineCount = 0;
  for file in lfs.dir(screenshotFolder) do
    if lfs.attributes(file,"mode") ~= "directory" and file:find(hashFileName) ~= nil then
      filename = screenshotFolder .. "/" .. file
      movieFile = io.open(filename, "rb")
      movieFile:seek("set", 0);
      repeat
        line = movieFile:read("*l");
        lineCount = lineCount +1;
      until (line == nil);
      lineCount = lineCount -1; --last line doesn't count
      io.close(movieFile);
    end
  end
  return lineCount / screenshotOffSet;
end

function M.checkSyncXmlUpdate()
  fixedDesync = getStatusDetectInfo()["FixedDesyncs"];
  possibleDesync = getStatusSyncInfo()["PossibleDesyncs"];
  
  for k, desyncFound in ipairs(possibleDesync) do
    --if a desync is found in the XML
    if(not table.contains(fixedDesync, desyncFound) and frameHashedProcessed > desyncFound) then
      fixDesyncFrame(desyncFound);
    end
  end
end



return M;

--[[
local key = {
--"V", "B"
}
local now = {};
local lastframe = {}
function KeyEvent()
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


init();
lfs.chdir(currentPath);
print("The \"" .. movieName .. "\" will now be loaded.")
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

--		if(emu.framecount() == movieEnd and movieEnd < frameHashedProcessed) then
--			print("*************************************************")
--			print("Processing over, now \"patrolling\" from the first checkpoint (frame " .. checkPoint[1] .. ")")
--			print("*************************************************")
--			config.oldStateLoader(checkPoint[1]) --just reload the first checkpoint to keep running the script in loop
--			showLagOccurence = false;
--			gui.text(10,  10, "Now in patrolling mode to check" );
--			gui.text(10,  20, "if any desync happen in an another pcsxrr instance" );
--		end



		emu.frameadvance();
		config.writeStatusDetectInfo("processing", frameHashedProcessed);

		--print("Time for 1 frame: " .. stopBenchMark(metricsPerFrame) .. "ms")
	end
end
--]]

