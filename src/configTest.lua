
m=require("Account")



--return the hash value of a screen shot taken with the gd lib
function stringHash(textImg)		
	local counter = 1;
	local textLength = string.len(textImg); 
	mod=math.mod;  
	for i = 1, textLength, 3 do 
		counter = mod(counter*8161, 4294967279) + 
		(string.byte(textImg,i)*16776193) +
		((string.byte(textImg,i+1) or (textLength-i+256))*8372226) +
		((string.byte(textImg,i+2) or (textLength-i+256))*3932164);
	end; 
	return mod(counter, 4294967291); 
end

function getNearestCheckPoint(desyncFrame)
	checkPoint = getStatusDetectInfo()["CheckPoints"];

	previousCheckPoint = 0;
	for  k, checkPointFound in ipairs(checkPoint) do  
	--for checkPointFound in checkPoint do
		if((previousCheckPoint < desyncFrame and checkPointFound > desyncFrame) or previousCheckPoint == desyncFrame) then
			return previousCheckPoint;
		else
			previousCheckPoint = checkPointFound;
		end
	end
	return previousCheckPoint;
end

function writeStatusDetectInfo(state, currentFrame)
	root = xml.new("DetectStatus");
	root:append("MovieProcessed")[1] =  movieName;
	root:append("MovieDuration")[1] =  movieEnd;
	root:append("FirstLaglessFrameZone")[1] =  firstLaglessFrameZone;
	root:append("ScreenshotOffSet")[1] = screenshotOffSet;
	root:append("StateProcess")[1] = state;
	root:append("CurrentScreenShotProcess")[1] = currentFrame;

	if(#checkPoint == 0) then 
		checkPoint = loadCheckPoints();
	end

	checkPoints = root:append(xml.new("CheckPoints"));	
	checkPoint = table.unique(checkPoint);	
	table.sort(checkPoint)
	for k, v in ipairs(checkPoint) do
		checkPoints:append(tostring("_"..v));
	end

	fixedDesyncs = root:append(xml.new("FixedDesyncs"));	
	fixedDesync = table.unique(fixedDesync);	
	table.sort(fixedDesync)
	for k, v in ipairs(fixedDesync) do
		fixedDesyncs:append(tostring("_"..v));
	end
	root:save(detectInfoFilePath);
end

function getStatusDetectInfo()
	parseInfo = nil;
	statusDetectDocument = xml.load(detectInfoFilePath);
	if(statusDetectDocument ~= nil) then

		parseInfo = {["MovieProcessed"]=statusDetectDocument:find("MovieProcessed", nil,nil)[1]
		,["MovieDuration"]=tonumber(statusDetectDocument:find("MovieDuration", nil,nil)[1])
		,["FirstLaglessFrameZone"]=tonumber(statusDetectDocument:find("FirstLaglessFrameZone", nil,nil)[1])
		,["ScreenshotOffSet"]=tonumber(statusDetectDocument:find("ScreenshotOffSet", nil,nil)[1])
		,["StateProcess"]=statusDetectDocument:find("StateProcess", nil,nil)[1]
		,["CurrentScreenShotProcess"]=tonumber(statusDetectDocument:find("CurrentScreenShotProcess", nil,nil)[1])
		} 

		if(#checkPoint == 0) then 
			checkPoint = loadCheckPoints();
		end

		statusCheckPoint = {};
		xmlCheckPoints = statusDetectDocument:find("CheckPoints", nil,nil);
		for i=1, #xmlCheckPoints do
			table.insert(statusCheckPoint,parseXmlNumberValue(statusDetectDocument:find("CheckPoints", nil,nil)[i][0]))
		end
		parseInfo["CheckPoints"]=statusCheckPoint;

		--merge the statusCheckPoint and checkPoint table together
		for k,v in pairs(statusCheckPoint) do checkPoint[k] = v end 

		statusFixedDesync = {};
		xmlFixedDesync = statusDetectDocument:find("FixedDesyncs", nil,nil);
		for i=1, #xmlFixedDesync do
			table.insert(statusFixedDesync,parseXmlNumberValue(statusDetectDocument:find("FixedDesyncs", nil,nil)[i][0]))
		end
		parseInfo["FixedDesyncs"]=statusFixedDesync;
		fixedDesync = statusFixedDesync;
	else
		--print("No xml status found for the detection process.")
		parseInfo = {["CheckPoints"]={},["FixedDesyncs"]={},["CurrentScreenShotProcess"]=0};
	end

	return parseInfo;
end


function writeStatusSyncInfo(state, currentFrame)
	root = xml.new("SyncStatus");
	root:append("MovieProcessed")[1] =  movieName;
	root:append("MovieDuration")[1] =  movieEnd;
	--root:append("LastDesync")[1] = "000";
	root:append("CurrentFrame")[1] = currentFrame;
	root:append("StateProcess")[1] =  state;

	desyncLog = root:append(xml.new("PossibleDesyncs"));
	possibleDesync = table.unique(possibleDesync);	
	table.sort(possibleDesync)
	for k, v in ipairs(possibleDesync) do
		--The reason why we use "_" is because the normal XML standard
		--require absolutly that node name doesn't start by a number
		desyncLog:append(tostring("_"..v));
	end
	root:save(syncInfoFilePath);
end

function getStatusSyncInfo()
	parseInfo = nil;
	statusSyncDocument = xml.load(syncInfoFilePath);
	if(statusSyncDocument ~= nil) then
		parseInfo = {["MovieProcessed"]=statusSyncDocument:find("MovieProcessed", nil,nil)[1]
		,["MovieDuration"]=statusSyncDocument:find("MovieDuration", nil,nil)[1]
		,["CurrentFrame"]=statusSyncDocument:find("CurrentFrame", nil,nil)[1]
		,["StateProcess"]=statusSyncDocument:find("StateProcess", nil,nil)[1]
		} 

		statusPossibleDesync = {};
		xmlPossibleDesyncs = statusSyncDocument:find("PossibleDesyncs", nil,nil);
		for i=1, #xmlPossibleDesyncs do
			table.insert(statusPossibleDesync,parseXmlNumberValue(statusSyncDocument:find("PossibleDesyncs", nil,nil)[i][0]))
		end
		parseInfo["PossibleDesyncs"]=statusPossibleDesync;
		possibleDesync = statusPossibleDesync;
	else
		--print("No xml status found for the synchronization process.")
		parseInfo = {["PossibleDesyncs"]={},["CurrentFrame"]=0};
	end
	return parseInfo;
end


function getStatusConfigInfo()
	parseInfo = nil;
	if(configInfoFilePath == nil) then
		return {};
	end
	statusConfigDocument = xml.load(configInfoFilePath);
	if(statusConfigDocument ~= nil) then
		parseInfo = {["PcsxrrPath"]=statusConfigDocument:find("PcsxrrPath", nil,nil)[1]
		,["MoviePath"]=statusConfigDocument:find("MoviePath", nil,nil)[1]
		,["TasSpuPath"]=statusConfigDocument:find("TasSpuPath", nil,nil)[1]
		,["EternalSpuPath"]=statusConfigDocument:find("EternalSpuPath", nil,nil)[1]
		,["WorkflowPath"]=statusConfigDocument:find("WorkflowPath", nil,nil)[1]
		,["LuaScriptPath"]=statusConfigDocument:find("LuaScriptPath", nil,nil)[1]
		,["KkapturePath"]=statusConfigDocument:find("KkapturePath", nil,nil)[1]
		} 
	else
		parseInfo = {};
	end
	return parseInfo;
end

function parseXmlNumberValue(xmlNumber)
	if(xmlNumber:len() > 1) then
		xmlNumber = tonumber(xmlNumber:sub(2));
	end
	return xmlNumber;
end

--possible string(mode frame): 
--"desyncFound 122433"
--"desyncFixed 122422"
function parseClipboardString()
	local clipboardString = winapi.get_clipboard();
	if(clipboardString == nil) then return nil end

	local mode = clipboardString:match("%a*")
	local frame = clipboardString:match("[^%a%s]%d*")

	if(frame ~= "" and (mode == "desyncFound" or mode == "desyncFixed")) then 
		return {["mode"]=mode, ["frame"]=tonumber(frame)}
	else
		return nil;
	end
end

--set to the clipboard
function setClipboardString(mode, frame)
	winapi.set_clipboard(mode .. " " .. frame);
end


--get the last token
function getToken()
	local token = nil;
	for file in lfs.dir(tokenMediatorFolder) do
		if lfs.attributes(file,"mode") ~= "directory" then
			token = file;
			--os.remove(tokenMediatorFolder .. "/" .. file);

			local mode = file:match("%a*")
			local frame = file:match("[^%a%s]%d*")
			return {["mode"]=mode, ["frame"]=tonumber(frame)}
		end
	end
end

--set the token
function setToken(mode, frame)	
	cleanToken();
	io.open(tokenMediatorFolder .. "\\" .. mode .. " " .. frame, "a+"):close();
end

function cleanToken()
	for file in lfs.dir(tokenMediatorFolder) do
		if lfs.attributes(file,"mode") ~= "directory" then
			filename = tokenMediatorFolder .. "/" .. file
			os.remove(filename);
		end
	end
end


--set the token
function getFinalPassToken()	
	if(isFileExist(encodeWorkflowFolder .. "/" .. "activeFinalPass")) then
		return true;
	end
end
--set the token
function setFinalPassToken()	
	io.open(encodeWorkflowFolder .. "/" .. "activeFinalPass", "a+"):close();
end

--change the windows registry key for the pcsxrr spu plugin
function changeSpuRegKey(stringValue)	
	k,err = winapi.open_reg_key([[HKEY_CURRENT_USER\Software\PCSX-RR]], true)
	if not k then 
		return print('bad key',err)  --pcsxrr never ever run on the host computer?
	end
    k:set_value("PluginSPU",stringValue, winapi.REG_SZ);
	--print(k:get_value("PluginSPU"))
	k:close()
end