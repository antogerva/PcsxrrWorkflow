--The synchCheckpoint.lua is part of the "PcsxrrEncodeWofkflow Project v4"
--Run this script with the Eternal SPU Plugin 1.41

--Author: badpotato, ...
--Requirements for running the script
--Lua 5.1

--Lua-GD 2.0.33r2
--http://files.luaforge.net/releases/lua-gd/lua-gd/lua-gd-2.0.33r2forLua5.1/lua-gd-2.0.33r2-win32.zip

--LuaFileSystem 1.4.2
--http://files.luaforge.net/releases/luafilesystem/luafilesystem/luafilesystem-1.4.2/luafilesystem-1.4.2-win32-lua51.zip

--LuaSocket 2.0.2
--http://files.luaforge.net/releases/luasocket/luasocket/luasocket-2.0.2/luasocket-2.0.2-lua-5.1.2-Win32-vc8.zip

--Lanes 2.1-1
--I had to compile this with LuaRocks...
--http://luarocks.org/repositories/rocks/lanes-2.1-1.rockspec

--LuaXML 1.7.4
--http://viremo.eludi.net/LuaXML/index.html

--[[
kkapture setting: 
skip frames on frequesnt time check ON. eternalSPU: audio out - SPUasync, Wait
]]--


module("synchCheckpoint",package.seeall)

require "gd"
require "lfs"
require 'luaxml'
dofile  "pcsxrrWorkflowConfig.lua"

P = require('pcsxrrWorkflowConfig')


--require "socket"


local exit = false;
local pcsxrrVersion = "pcsx-rr13c";
local emu = pcsx;

local loadThisCheckPoint = nil
local firstLoad = true;

local desyncAlertCount = 0;
local moviePos = 0;

local stateProcess = ""
  
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

function isDetectionFarEnough(params)
	return tonumber(getStatusDetectInfo()["CurrentScreenShotProcess"]) >= emu.framecount();
end

function isDetectionFixedDesyncFromXml(desyncPoint)
	possibleDesync = getStatusSyncInfo()["PossibleDesyncs"];
	fixedDesync = getStatusDetectInfo()["FixedDesyncs"];

	return table.contains(fixedDesync, desyncPoint);
end

function isDetectionFixedDesyncFromClipboard(desyncPoint)
	--local dataDetect = parseClipboardString();
	local dataDetect = getToken();
	return dataDetect ~= nil and dataDetect["mode"] == "desyncFixed";
end


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
