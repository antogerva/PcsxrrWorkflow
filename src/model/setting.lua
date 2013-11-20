---
-- @module setting
--TODO
local emu = require("embedded.emu")
local movie = require("embedded.movie")
local gui = require("embedded.gui")
local io = require("io")
local gd = require("gd")

local M = {};

function new()
  M.saveStateOffSet = 500;
  M.screenshotOffSet = 1;
  M.afterEndMovieStopOffset = 50; 
  M.startProcessFrame = 0; --need a xml option for this

  --Set to true only in "capture mode", while using kkapture
  M.encodeMode = false; --TODO: Should be an XML option

  --Set to true only in "capture mode", while using kkapture
  M.showEncodeErrorWarning = false;

  M.im = nil; --special lib if we openGL2 for screenshot.

  --TODO: make some documentation about these value
  M.tolerateDesync = 3;
  M.untolerateDesync = 15;

  M.movieSaveStateFolder = "sstates"  
  M.infoConfig = emu.getconfig();

  M.encodeWorkflowFolder = nil; -- now using a config xml for this  
  --TODO: Autoset according to the moviename

  --configInfoFilePath = "workflowAppConfig.xml"
  local movieName = movie.name();
  M.pcsxrrEncodeWofkflowPath = "PcsxrrEncodeWofkflowV5.07";

  if (M.encodeWorkflowFolder == nil and movieName ~= nil) then
    M.encodeWorkflowFolder = M.pcsxrrEncodeWofkflowPath .. "/" .. movieName;
    M.encodeWorkflowFolder =  movieName;
  elseif (M.encodeWorkflowFolder == nil) then
  --TODO
  --io.open(configInfoFilePath, "a+"):close(); --safe check
  --encodeWorkflowFolder = getStatusConfigInfo()["WorkflowPath"];
  end
  if(M.encodeWorkflowFolder == nil) then
    gui.popup("Something failed while trying to load the workflow folder.");
    print("Something failed while trying to load the workflow folder.");
    M.encodeWorkflowFolder = "";
  end

  M.detectInfoFilePath = M.encodeWorkflowFolder .. "/detectInfoStatus.xml"
  M.syncInfoFilePath = M.encodeWorkflowFolder .. "/syncInfoStatus.xml"

  M.saveStateFolder = M.encodeWorkflowFolder .. "/tasSoundSaveStates"
  M.desyncSaveStateFolder = M.encodeWorkflowFolder .. "/desyncSaveStates"

  M.screenshotFolder = M.encodeWorkflowFolder .. "/screenshot"
  M.screenshotBackupFolder = M.screenshotFolder .. "/bak"
  M.imgScreenshotFolder = M.screenshotFolder .. "/img"
  M.hashFrameSplit = 100000;

  M.tokenMediatorFolder = M.encodeWorkflowFolder .. "/tokenMediator"


  --Might help in the boot up process so we just ignore possible desync in bootup process. Also this might help to avoid being lag framezoned
  M.firstLaglessFrameZone = nil;
  M.firstLaglessFrameZoneOffset = 50;

  M.snapshotName = nil;
  if(M.infoConfig ~= nil and M.infoConfig["gpu"] == "gpuTASsoft.dll") then
    M.snapshotName = "snap_001.png";
    M.getScreenShot = gd.createFromPng;
  else
    --Why would you use the OpenGL GPU?
    --well, ok then...
    M.snapshotName = "PSOGL001.bmp";
    local imlua_open = package.loadlib("imlua51.dll", "imlua_open");
    local im = imlua_open(); --load the imlua library
    M.getScreenShot = im.FileImageLoadBitmap;
  end 
  M.tempSnapshotName = "snap/___TEST.PNG";
  --os.remove("snap/" .. snapshotName)
  --os.remove(tempSnapshotName)

  M.saveStateName = "tasSaveState"
  M.desyncSaveStateName = "tasDesyncSaveState"

  --desyncLogFileName = "desyncLog"
  M.imgName = "detectScreenShot"
  M.hashFileName = "hashFrame"

  --lastLaglessFrame = emu.framecount() -1;
  M.lastCheckPointScreenshotValue = "";
  M.lastCheckPoint = nil;
end

return M;


--[[

local saveStateOffSet = 500;
local screenshotOffSet = 1;
local afterEndMovieStopOffset = 50; 
local startProcessFrame = 0; --need a xml option for this

--Set to true only in "capture mode", while using kkapture
local encodeMode = false; --TODO: Should be an XML option

--Set to true only in "capture mode", while using kkapture
local showEncodeErrorWarning = false;

local im = nil; --special lib if we openGL2 for screenshot.

--TODO: make some documentation about these value
local tolerateDesync = 3;
local untolerateDesync = 15;

local movieSaveStateFolder = "sstates"  

local encodeWorkflowFolder = nil; -- now using a config xml for this  
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

local detectInfoFilePath = encodeWorkflowFolder .. "/detectInfoStatus.xml"
local syncInfoFilePath = encodeWorkflowFolder .. "/syncInfoStatus.xml"

local saveStateFolder = encodeWorkflowFolder .. "/tasSoundSaveStates"
local desyncSaveStateFolder = encodeWorkflowFolder .. "/desyncSaveStates"

local screenshotFolder = encodeWorkflowFolder .. "/screenshot"
local screenshotBackupFolder = screenshotFolder .. "/bak"
local imgScreenshotFolder = screenshotFolder .. "/img"
local hashFrameSplit = 100000;

local tokenMediatorFolder = encodeWorkflowFolder .. "/tokenMediator"


--Might help in the boot up process so we just ignore possible desync in bootup process. Also this might help to avoid being lag framezoned
local firstLaglessFrameZone = nil;
local firstLaglessFrameZoneOffset = 50;

local snapshotName = nil;
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
local tempSnapshotName = "snap/___TEST.PNG";
--os.remove("snap/" .. snapshotName)
--os.remove(tempSnapshotName)

local saveStateName = "tasSaveState"
local desyncSaveStateName = "tasDesyncSaveState"

--desyncLogFileName = "desyncLog"
local imgName = "detectScreenShot"
local hashFileName = "hashFrame"

--lastLaglessFrame = emu.framecount() -1;
local lastCheckPointScreenshotValue = "";
local lastCheckPoint = nil;

--]]


--[[
M.saveStateOffSet = 500;
M.screenshotOffSet = 1;
M.afterEndMovieStopOffset = 50; 
M.startProcessFrame = 0; --need a xml option for this

--Set to true only in "capture mode", while using kkapture
M.encodeMode = false; --TODO: Should be an XML option

--Set to true only in "capture mode", while using kkapture
M.showEncodeErrorWarning = false;

M.im = nil; --special lib if we openGL2 for screenshot.

--TODO: make some documentation about these value
M.tolerateDesync = 3;
M.untolerateDesync = 15;

M.movieSaveStateFolder = "sstates"  
M.infoConfig = emu.getconfig();

M.encodeWorkflowFolder = nil; -- now using a config xml for this  
--TODO: Autoset according to the moviename

--configInfoFilePath = "workflowAppConfig.xml"
local movieName = movie.name();
M.pcsxrrEncodeWofkflowPath = "PcsxrrEncodeWofkflowV5.07";

if (M.encodeWorkflowFolder == nil and movieName ~= nil) then
  M.encodeWorkflowFolder = M.pcsxrrEncodeWofkflowPath .. "/" .. movieName;
  M.encodeWorkflowFolder =  movieName;
elseif (M.encodeWorkflowFolder == nil) then
  --TODO
  --io.open(configInfoFilePath, "a+"):close(); --safe check
  --encodeWorkflowFolder = getStatusConfigInfo()["WorkflowPath"];
end
if(M.encodeWorkflowFolder == nil) then
  gui.popup("Something failed while trying to load the workflow folder.");
  print("Something failed while trying to load the workflow folder.");
  M.encodeWorkflowFolder = "";
end

M.detectInfoFilePath = M.encodeWorkflowFolder .. "/detectInfoStatus.xml"
M.syncInfoFilePath = M.encodeWorkflowFolder .. "/syncInfoStatus.xml"

M.saveStateFolder = M.encodeWorkflowFolder .. "/tasSoundSaveStates"
M.desyncSaveStateFolder = M.encodeWorkflowFolder .. "/desyncSaveStates"

M.screenshotFolder = M.encodeWorkflowFolder .. "/screenshot"
M.screenshotBackupFolder = M.screenshotFolder .. "/bak"
M.imgScreenshotFolder = M.screenshotFolder .. "/img"
M.hashFrameSplit = 100000;

M.tokenMediatorFolder = M.encodeWorkflowFolder .. "/tokenMediator"


--Might help in the boot up process so we just ignore possible desync in bootup process. Also this might help to avoid being lag framezoned
M.firstLaglessFrameZone = nil;
M.firstLaglessFrameZoneOffset = 50;

M.snapshotName = nil;
if(M.infoConfig ~= nil and M.infoConfig["gpu"] == "gpuTASsoft.dll") then
  M.snapshotName = "snap_001.png";
  M.getScreenShot = gd.createFromPng;
else
  --Why would you use the OpenGL GPU?
  --well, ok then...
  M.snapshotName = "PSOGL001.bmp";
  local imlua_open = package.loadlib("imlua51.dll", "imlua_open");
  local im = imlua_open(); --load the imlua library
  M.getScreenShot = im.FileImageLoadBitmap;
end 
M.tempSnapshotName = "snap/___TEST.PNG";
--os.remove("snap/" .. snapshotName)
--os.remove(tempSnapshotName)

M.saveStateName = "tasSaveState"
M.desyncSaveStateName = "tasDesyncSaveState"

--desyncLogFileName = "desyncLog"
M.imgName = "detectScreenShot"
M.hashFileName = "hashFrame"

--lastLaglessFrame = emu.framecount() -1;
M.lastCheckPointScreenshotValue = "";
M.lastCheckPoint = nil;
--]]
