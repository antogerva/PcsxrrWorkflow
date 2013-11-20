
---
-- @module synchCheckpoint


--[[
kkapture setting: 
skip frames on frequesnt time check ON. eternalSPU: audio out - SPUasync, Wait
]]--



require "gd"
require "lfs"
require 'luaxml'
dofile  "pcsxrrWorkflowConfig.lua"

--P = require('pcsxrrWorkflowConfig')


--require "socket"


local exit = false;
local pcsxrrVersion = "pcsx-rr13c";
local emu = pcsx;

local loadThisCheckPoint = nil
local firstLoad = true;

local desyncAlertCount = 0;
local moviePos = 0;

local stateProcess = ""
  
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

	tolerateDesync = config.tolerateDesync;
	untolerateDesync = config.untolerateDesync;

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

	detectInfoFilePath = config.detectInfoFilePath;
	syncInfoFilePath = config.syncInfoFilePath;

	lastLaglessFrame = config.lastLaglessFrame;

	lastCheckPointScreenshotValue = config.lastCheckPointScreenshotValue;
	lastCheckPoint = config.lastCheckPoint;

	--function
	getHashCode = config.getHashCode;
	stringHash = config.stringHash;
	writeStatusSyncInfo = config.writeStatusSyncInfo;
	getStatusDetectInfo = config.getStatusDetectInfo;
	writeStatusDetectInfo = config.writeStatusDetectInfo;
	getStatusSyncInfo = config.getStatusSyncInfo;
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

	frameHashedProcessed = config.frameHashedProcessed;
	config.createDir();

	--emu.speedmode("normal") -- emulator runs at max speed without frameskip
	--2way to load the state
	--stateLoader = config.oldStateLoader
	--stateLoader = config.stateLoader

end
--]]




function waitForDetectionProcess(desyncPoint)
	print("Waiting for a fix...")
	local waitingFrameCounter = 0;
	repeat
		pcsx.suspend(500);
		waitingFrameCounter = waitingFrameCounter + 1
		if(waitingFrameCounter % 10 == 0) then
			print("..."); --still waiting...
		end
	until isDetectionFixedDesyncFromClipboard(desyncPoint)
	--until isDetectionFixedDesyncFromXml(desyncPoint);
end

--------------------

--[[
--Experimental for single instance... would require lot more try and error to get it work
function fixDesync(desyncFound)
	print("Now trying to fix desync at frame " .. desyncFound);
	pcsx.switchspu("spuTAS.dll")

	checkPointFrame = getNearestCheckPoint(desyncFound);

	if(checkPointFrame == 0) then
		--TODO: Alway make a savestate on first non-laggy frame?
		print("No savestate found, the emulator need a reset");
		emu.pause();
	else
		config.oldStateLoader(checkPointFrame)
		--config.stateLoader(checkPointFrame);
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
    pcsx.switchspu("spuEternal.dll");
    config.oldStateLoader(desyncFound);
end

--]]
--------------------


function syncCheck() 	
	if(table.contains(checkPoint, emu.framecount()) or table.contains(fixedDesync, emu.framecount())) then -- 
		config.oldStateLoader(emu.framecount(), false);
		desyncAlertCount = 0; 
	end

	if(finalPass) then return end;
	if(emu.framecount() % screenshotOffSet == 0) and (emu.framecount() >= startProcessFrame) and emu.framecount() ~= 0 and (encodeMode ~= true) then			
		hashCode = tonumber(getHashCode());
		realHash = tonumber(getHashFromFile(emu.framecount()));	

		if((config.lastCheckPointScreenshotValue) ==  (realHash)) then
			print(string.format(emu.framecount() .. " : done(from last checkpoint) ! ( %010.f / %010.f )", config.lastCheckPointScreenshotValue, getHashFromFile(emu.framecount()) ));				
			config.lastCheckPointScreenshotValue = "";
			--emu.frameadvance(); --next frame repeat does repeat himself?
		--elseif(emu.framecount() == config.lastCheckPoint) then
		--	print("Carry on the next frame...")
		elseif(realHash == 0) then	
			if(emu.framecount() < movieEnd) then
				print(emu.framecount() .. " : bootup process");
			end
		elseif((realHash) ~= (hashCode)) then					
			if(desyncAlertCount > untolerateDesync) then
				desyncPoint = emu.framecount() - desyncAlertCount;
				print(emu.framecount() .. " : The movie hit an IMPORTANT desync by frame ".. desyncPoint .. "!!! !!!")
				--writeLog("," ..  emu.framecount() .. " !!! -DESYNC ZONE- !!! !!!") 	
				print("Suspending process");
				--emu.pause()
				table.insert(possibleDesync, desyncPoint);
				table.sort(possibleDesync)
				writeStatusSyncInfo("desync", emu.framecount());
				--setClipboardString("desyncFound", desyncPoint)
				setToken("desyncFound", desyncPoint);
				waitForDetectionProcess(desyncPoint);
				--fixDesync(desyncPoint);

				print("Loading new checkpoint for desync point at " .. desyncPoint)
				config.oldStateLoader(desyncPoint, true);
				desyncAlertCount = 0; 
			elseif(desyncAlertCount > tolerateDesync) then
				print(string.format(emu.framecount() .. " : DESYNCH !!! ( %010.f / %010.f ) !!!", hashCode, realHash ));
				--writeLog("," ..  emu.framecount() .. " !!! -DESYNC ZONE- !!!") 			
				desyncAlertCount = desyncAlertCount +1;
			elseif(desyncAlertCount == tolerateDesync) then
				print(string.format(emu.framecount() .. " : DESYNCH ! ( %010.f / %010.f ) !", hashCode, realHash ));
				--writeLog("," ..  emu.framecount() .. " !!! -DESYNC ZONE- !!!") 			
				desyncAlertCount = desyncAlertCount +1;
			elseif(desyncAlertCount < tolerateDesync) then 
				print(string.format(emu.framecount() .. " : DESYNCH ! ( %010.f / %010.f )", hashCode, realHash ));
				--writeLog("," ..  emu.framecount());				
				desyncAlertCount = desyncAlertCount +1;
			end			
		else
			if(emu.framecount() % screenshotOffSet == 0 and encodeMode ~=true) then				
				print(string.format(emu.framecount() .. " : done ! ( %010.f / %010.f )", hashCode, realHash ));
			end
			desyncAlertCount = 0; 
		end
	end		
end



function checkMovieEnd()
	if(finalPass and emu.framecount() == movieEnd + afterEndMovieStopOffset) then
		print("Movie end.")
		os.execute("echo MOVIE IS OVER !!! " .. "&& pause");
		print("Now exiting the script...");
		emu.frameadvance()
		exit = true;
		--while true do emu.frameadvance() end
		--pcsx.quit();
	end
end

--pcsx.switchspu("spuEternal.dll");

print("Synchronization script loaded!!!");
init(); 

print("The \"" .. movieName .. "\" will now be loaded.")
movie.load(movieName);
movieEnd = movie.length();
lfs.chdir(currentPath);


--dofile("guiWorkflow.lua")

if(not finalPass) then
	changeSpuRegKey("spuTAS.dll");
	local detectionParam =  " -play \"..\\movies\\" ..  movieName .. "\" -readonly" .. " -lua \"detectCheckpoint.lua\"";
	winapi.shell_exec(nil, "..\\pcsx.exe", detectionParam) --TODO: get something smart here instead
end

--changeSpuRegKey("spuEternal_b.dll")

--config.oldStateLoader(15554)
--config.oldStateLoader(15554)

print(checkPoint)
print("--------------")
print(fixedDesync)


print(#checkPoint)
print("--------------")
print(#fixedDesync)

while true do
	if(exit==true) then
		return;
	end

	syncCheck();
	checkMovieEnd();

	emu.frameadvance();
end
