
---
--@function [parent=#Tools] staticMethod
--@return #string description
function staticMethod ()
	return "ok"
end



--require socket...
--benchmarking/metrics tools
function startBenchMark()
	--return socket.gettime()*1000;
end

--benchmarking/metrics tool
function stopBenchMark(startMetrics)
	--timeElapsed = socket.gettime()*1000 - startMetrics;
	return timeElapsed;
end



function table.contains(tbl, element)
	if(tbl == nil) then return false end
	for k, value in pairs(tbl) do
		if value == element then
			return true
		end
	end
	return false
end



function table.val_to_str(v)
  if "string" == type(v) then
    v = string.gsub(v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type(v) and table.tostring(v) or
      tostring(v)
  end
end

function table.key_to_str(k)
  if "string" == type(k) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str(k) .. "]"
  end
end

function table.tostring(tbl)
	--[[
  local result, done = {}, {}
  for k, v in ipairs(tbl) do
    table.insert( result, table.val_to_str(v))
    done[k] = true
  end
  for k, v in pairs(tbl) do
    if not done[k] then
      table.insert(result, table.key_to_str(k) .. "=" .. table.val_to_str(v))
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
  --]]
  tostring(tbl) --already in the global namespace of luaengine.cpp
end

-- Count the number of times a value occurs in a table 
function table.count(tbl, item)
	local count
	count = 0
	for ii,xx in pairs(tbl) do
		if item == xx then count = count + 1 end
	end
	return count
end

-- Remove duplicates from a table array (doesn't currently work
-- on key-value tables)
function table.unique(tbl)
	local newtable
	newtable = {}
	for ii,xx in ipairs(tbl) do
		if(table.count(newtable, xx) == 0) then
			newtable[#newtable+1] = xx
		end
	end
	return newtable
end



function printStack()
	print("-----------------------------")
	print(debug.traceback(coroutine.running(),"error at line : "))
	print("-----------------------------")
end

function isFileExist(path)
	local fileInfo = lfs.attributes(path)
	if fileInfo then
	    if fileInfo.mode == "directory" then
	        --print("Path points to a directory.")
	        return true;
	    elseif fileInfo.mode == "file" then
	        --print("Path points to a file.")
	        return true;
	    else
	        print("Path points to: "..fileInfo.mode)
	        return true;
	    end
	    --display(fileInfo) -- to see the detailed information
	else
		if(showEncodeErrorWarning) then
	    	print("The path is invalid (file/directory at \"" .. path .. "\" doesn't exist)") --TODO!!!
	    end
	    return nil;
	end
end


--load the list of checkpoint from the saveStateFolder
function loadCheckPoints()
	checkPoint = {}
	for file in lfs.dir(saveStateFolder) do 
		if lfs.attributes(file,"mode") ~= "directory" then 			
			table.insert(checkPoint,tonumber(file:sub(saveStateName:len()+2)))
		end
	end
	table.sort(checkPoint)
	table.unique(checkPoint)
	return checkPoint;
end


function loadScreenShotBackupFolder()
	local backupFolder = {}
	for file in lfs.dir(screenshotFolder) do 
		if lfs.attributes(file,"mode") == "directory" then 	
			print(file)		
			table.insert(backupFolder,file)
		end
	end
	table.sort(checkPoint)
	table.unique(checkPoint)
	return backupFolder;
end

function createSaveState(checkPointToCreate, isDesyncFix)
	--TODO: use new version!!
	if(checkPointToCreate == nil) then return end

	--fancy Ternary Operator in lua
	pathSaveState  = (isDesyncFix==true and (desyncSaveStateFolder .. "/" .. desyncSaveStateName)
										or (saveStateFolder .. "/" .. saveStateName))

	if(savestate.savefile ~= nil) then
		savestate.savefile(pathSaveState .. "-" .. checkPointToCreate)
	else
		newStateFile = io.open(pathSaveState .. "-" .. checkPointToCreate, "wb");
		newCheckPoint = savestate.create(1);
		savestate.save(newCheckPoint)	;
		currentStateFile = io.open(movieSaveStateFolder .. "/" .. movieName .. ".000", "rb" );
		save = currentStateFile:read("*all");
		newStateFile:write(save);
		io.close(newStateFile);
		io.close(currentStateFile);
		print("Made a check point at " .. checkPointToCreate .. " using an old version.")
	end

	table.insert(checkPoint, emu.framecount()) --add the checkpoint to the checkpoint list
	table.sort(checkPoint)
end

--safe state loader, but might refresh the screen a bit late
function oldStateLoader(checkPointToLoad, isDesyncFix)
	if(checkPointToLoad == nil) then return end

	local pathSaveState  = (isDesyncFix==true 	and (desyncSaveStateFolder .. "/" .. desyncSaveStateName)
												or (saveStateFolder .. "/" .. saveStateName))

	if(isFileExist(pathSaveState .. "-" .. checkPointToLoad) == nil) then  --if nil look in the other directory
		testPathSaveState  = ((not isDesyncFix)==true 	and (desyncSaveStateFolder .. "/" .. desyncSaveStateName)
											or (saveStateFolder .. "/" .. saveStateName))
		if(isFileExist(testPathSaveState .. "-" .. checkPointToLoad) == nil) then
			print("File at \"" .. pathSaveState .. "-" .. checkPointToLoad .. "\" doesn't exist." )
			--TODO: Ask first detection script to create it?
			return;
		else
			pathSaveState = testPathSaveState;
		end
	end

	if(savestate.loadfile ~= nil) then
		savestate.loadfile(pathSaveState .. "-" .. checkPointToLoad);
		print("Loading checkpoint #" .. checkPointToLoad)
	else
		local saveStateFile = io.open(pathSaveState .. "-" .. checkPointToLoad, "rb")
		local save = saveStateFile:read("*all")

		local loadStateFile = io.open (movieSaveStateFolder .. "/" .. movieName .. ".000", "wb")
		loadStateFile:write(save)
		io.close(saveStateFile);
		io.close(loadStateFile) 
		local newCheckPoint = savestate.create(1)		
		savestate.load(newCheckPoint)
		print("Loading checkpoint #" .. checkPointToLoad .. "(with old version)")
	end
end


return {
	staticMethod=staticMethod
}