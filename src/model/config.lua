--- A module that allow to manage config
-- @module config
local M = {}

package.path = ";./src/?.lua;/.src/?.lua;./src/controller/?.lua;./dll/?.lua;./?.lua;../lua/?.lua;" ..package.path
package.cpath = ";./src/?.dll;/.src/?.dll;./src/controller/?.dll;./dll/?.dll;./?.dll;../lua/?.dll;" ..package.cpath

local tools=require("tools");
local io=require("io");
local observer=require("observer")

--- A configInstance
-- @type configInstance
-- @field [parent=#configInstance] #string configFilePath, "" by default 
-- @field [parent=#configInstance] #string fileType, "" by default 
-- @field [parent=#configInstance] #table confData
local C = {configFilePath="", fileType="",confData={PCSXRR="",Movie="",Workflow="",TAS_SPU="",ETERNAL_SPU=""}}

--- Parse the config
-- @function [parent=#configInstance] parse
-- @param #configInstance self
-- @param #table lines
function C.parse(self, lines)
  for i,v in ipairs(lines) do
    local key = v:gsub("=.*$", "")
    local value = v:match("=.*$"):match("[^=].*");
    if value == nil then value="" end;
--    for k, val in pairs(C.confData) do
--      if key==k then
--        val=value;
--      end
--    end   
    C.confData[key]=value;
  end
  --print(tools.to_string(C.confData));  
  return C.confData;
end

--- Load the config
-- @function [parent=#configInstance] parse
-- @param #configInstance self
-- @param #string path
-- @return #table a hashmap table that contain the key/value for the config
function C.load(self, path)
  if tools.isFileExist(path) then
    --local file = io.open(path, "r");
    local lines = {}
    for line in io.lines(path) do
      lines[#lines + 1] = line
    end
    return C:parse(lines);    
  else
    return nil;
  end
end

--- Save the config
-- @function [parent=#configInstance] save
-- @param #configInstance self
-- @param #string path
function C.save(self, path)
  if(tools.isValidPath(path)) then
    local file = io.open(path, "w");
    if(file~=nil) then
      for k, v in pairs(C.confData) do
        file:write(k.."="..v.."\n");
      end
      file:close();
    else
      print("Couldn't open the file")
    end
  else
    print("Invalid Path")
  end
end

---Create new config
-- @function [parent=#config] new
-- @param #string configFilePath
-- @return #configInstance
function M.new(configFilePath)
  local newConfig = {configFilePath=configFilePath};

  -- set to new config the properties of a configInstance
  setmetatable(newConfig,{__index=C})
  return newConfig;
end

--- NotifyObservers
-- @function [parent=#config] notifyObservers
M.notifyObservers=observer.signal();


function M.doStuff()
  M.notifyObservers();
end


return M;
