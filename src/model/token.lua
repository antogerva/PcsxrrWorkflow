--- 
-- @token
-- TODO
local M={};

--- 
--
function M.checkSyncClipBoardUpdate()
  dataClipboard = config.parseClipboardString();
  if(dataClipboard == nil or dataClipboard["mode"] ~= "desyncFound") then return end

  fixDesyncFrame(dataClipboard["frame"]); --fixing the desync
  setClipboardString("desyncFixed", dataClipboard["frame"]);
end

function M.checkSyncTokenUpdate()
  dataToken = config.getToken();
  if(dataToken == nil or dataToken["mode"] ~= "desyncFound") then return end

  fixDesyncFrame(dataToken["frame"]); --fixing the desync
  setToken("desyncFixed", dataToken["frame"]);
end

function M.isDetectionFarEnough(params)
  return tonumber(getStatusDetectInfo()["CurrentScreenShotProcess"]) >= emu.framecount();
end

function isDetectionFixedDesyncFromXml(desyncPoint)
  possibleDesync = getStatusSyncInfo()["PossibleDesyncs"];
  fixedDesync = getStatusDetectInfo()["FixedDesyncs"];

  return table.contains(fixedDesync, desyncPoint);
end

function M.isDetectionFixedDesyncFromClipboard(desyncPoint)
  --local dataDetect = parseClipboardString();
  local dataDetect = getToken();
  return dataDetect ~= nil and dataDetect["mode"] == "desyncFixed";
end


return M;