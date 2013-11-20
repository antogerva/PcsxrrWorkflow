
--- A module that allow to manage geometry shapes
-- @module pcsxrrWorkflowConfig
module("pcsxrrWorkflowConfig",package.seeall)

package.cpath = ";./dll/?.dll;./?.dll;./?.so;../lib/?.so;../lib/vc_dll/?.dll;../lib/bcc_dll/?.dll;../lib/mingw_dll/?.dll;../lua/?.dll;" .. package.cpath .. package.path

require "gd"
require "lfs"
require 'luaxml'
--require "profiler"
--require "socket"
--require "lanes"
require "winapi"


--profiler.start("test.out")
--local linda= lanes.linda();

-- @module pcsxrrWorkflowConfig
local M = {}


--- Move the rectangle
-- @function [parent=#pcsxrrWorkflowConfig] setting
function M.setting()
	-- @module pcsx
	emu = pcsx;
	
	checkPoint = {}
	possibleDesync = {}
	fixedDesync = {}
	config = pcsxrrWorkflowConfig;
	currentPath = lfs.currentdir();

	im = nil; --special lib if we openGL2 for screenshot.
	getScreenShot = nil; --also used for the screenshot as a function pointer

	--Set to true only in "capture mode", while using kkapture
	encodeMode = false; --TODO: Should be an XML option
	--Set to true only in "capture mode", while using kkapture
	showEncodeErrorWarning = false;

	saveStateOffSet = 500;
	screenshotOffSet = 1;
	afterEndMovieStopOffset = 50; 
	startProcessFrame = 0; --need a xml option for this

	--Sadly we need to busy-wait at some point, because pcsxrr alway need to keep processing frame7
	--(or at some point pcsxrr will ask to kill the script)
	--busyWaitOffset = 30; 

	--TODO: make some documentation about these value
	tolerateDesync = 3;
	untolerateDesync = 15;

	infoConfig = emu.getconfig();

	movieName = movie.name(); --movie.name() might crash the emu some time
	--movieName = [[C:\Users\antogerva\pcsxrr-feos-new3\feos-tas\output\movies\Azure Dreams FractalFusion.pxm]];
	movieName = [[C:\Users\antogerva\pcsxrr-feos-new3\feos-tas\output\movies\BB2 slash mode 6443 dammit.pxm]];

	if(movie.mode() ~= nil or (movieName ~= nil and movieName ~= "")) then --if the mode is nil, this mean pcsxrr is still in bootup state
		movieName = movieName:match("[^\\]*$"); --get only the name.pxm of the movie, instead of the fullpath
	else
		moviePath = getStatusConfigInfo()["MoviePath"];
		if(moviePath ~= nil) then
			movieName = moviePath:match("[^\\]*.pxm$");
		else
			gui.popup("No movie detected, please select a movie:")
			moviePath = gui.filepicker("Please select a movie", "pxm");
			movieName = moviePath:match("[^\\]*.pxm$");
		end
	end

	--dofile("guiWorkflow.lua")

	movieEnd = movie.length();
	movieSaveStateFolder = "sstates"

	configInfoFilePath = "workflowAppConfig.xml"

	pcsxrrEncodeWofkflowPath = "PcsxrrEncodeWofkflowV5.07";

	encodeWorkflowFolder = nil; -- now using a config xml for this	
	--TODO: Autoset according to the moviename

	if (encodeWorkflowFolder == nil and movieName ~= nil) then
		--encodeWorkflowFolder = pcsxrrEncodeWofkflowPath .. "/" .. movieName;
		encodeWorkflowFolder =  movieName;
	elseif (encodeWorkflowFolder == nil) then
		io.open(configInfoFilePath, "a+"):close(); --safe check
		encodeWorkflowFolder = getStatusConfigInfo()["WorkflowPath"];
	end
	if(encodeWorkflowFolder == nil) then
		gui.popup("Something failed while trying to load the workflow folder.")
	end

	detectInfoFilePath = encodeWorkflowFolder .. "/detectInfoStatus.xml"
	syncInfoFilePath = encodeWorkflowFolder .. "/syncInfoStatus.xml"


	saveStateFolder = encodeWorkflowFolder .. "/tasSoundSaveStates"
	desyncSaveStateFolder = encodeWorkflowFolder .. "/desyncSaveStates"

	--Made with the Eternal SPU plugin... sometime pcsxrr just need to reload a savestate for no reason to sync
	--Even if this is from the very same frame. This setting could be used to optimize the checkpoint list
	eternalSaveStateFolder = encodeWorkflowFolder .. "/eternalSaveStates"

	screenshotFolder = encodeWorkflowFolder .. "/screenshot"
	screenshotBackupFolder = screenshotFolder .. "/bak"
	imgScreenshotFolder = screenshotFolder .. "/img"
	hashFrameSplit = 100000;

	tokenMediatorFolder = encodeWorkflowFolder .. "/tokenMediator"

	--Might help in the boot up process so we just ignore possible desync in bootup process. Also this might help to avoid being lag framezoned
	firstLaglessFrameZone = nil;
	firstLaglessFrameZoneOffset = 50;

	snapshotName = nil;
	if(infoConfig["gpu"] == "gpuTASsoft.dll") then
		snapshotName = "snap_001.png";
		getScreenShot = gd.createFromPng;
	else
		--Why would you use the OpenGL GPU?
		--well, ok then...
		snapshotName = "PSOGL001.bmp";
		local imlua_open = package.loadlib("imlua51.dll", "imlua_open");
		im = imlua_open(); --load the imlua library
		getScreenShot = im.FileImageLoadBitmap;
	end	
	tempSnapshotName = "snap/___TEST.PNG";
	os.remove("snap/" .. snapshotName)
	os.remove(tempSnapshotName)

	saveStateName = "tasSaveState"
	desyncSaveStateName = "tasDesyncSaveState"
	--desyncLogFileName = "desyncLog"
	imgName = "detectScreenShot"
	hashFileName = "hashFrame"

	lastLaglessFrame = emu.framecount() -1;
	lastCheckPointScreenshotValue = "";
	lastCheckPoint = nil;

	createDir();

	frameHashedProcessed = getStatusDetectInfo()["CurrentScreenShotProcess"];
	checkPoint = loadCheckPoints();

	if(movieEnd == nil or movieEnd == 0) then
		movieEnd = getStatusDetectInfo()["MovieDuration"];
	end

	finalPass = getFinalPassToken();
end


function createDir()
	--First, let's make sure that the folder does exist
	lfs.mkdir(encodeWorkflowFolder)
	lfs.mkdir(screenshotFolder);
	lfs.mkdir(desyncSaveStateFolder);
	lfs.mkdir(tokenMediatorFolder);


	lfs.mkdir(imgScreenshotFolder);
	lfs.mkdir(saveStateFolder);

	--"touch" the status files)
	io.open(detectInfoFilePath, "a+"):close();
	io.open(syncInfoFilePath, "a+"):close();
	io.open(configInfoFilePath, "a+"):close();
end

--The GD library doesn't support BMP
--So we have to convert it by using the IM library.
function convertBmpToPNG(screen)	
	im.FileImageSave(tempSnapshotName, "PNG", screen);
	screen = gd.createFromPng(tempSnapshotName)
	os.remove(tempSnapshotName);
	return screen;
end

function getHashCode() 
	local waitCounter = 0;
	pcsx.makesnap();
	--pcsx.suspend(5);
	screen = getScreenShot("snap/" .. snapshotName )
	--screen = gd.createFromGdStr("snap/" .. snapshotName);
	while (screen == nil) do
		pcsx.testgpu();
		screen = getScreenShot("snap/" .. snapshotName )
		if (waitCounter % 10 == 0) then
			pcsx.makesnap();		
		elseif (waitCounter > 50) then
			print("Waiting for the gpu plugin to create the snap...")
			pcsx.suspend(50);
		elseif (waitCounter > 5) then
			pcsx.suspend(10);
		end
		waitCounter = waitCounter +1;
	end	
	if(snapshotName == "PSOGL001.bmp") then 
		--if using openGL2, we convert it to PNG.
		--TODO: find a better way to convert BMP as string
		screen = convertBmpToPNG(screen)
	end
	screen = screen:pngStr();	
	os.remove("snap/" .. snapshotName)
	return config.stringHash(screen);	
end


return M;