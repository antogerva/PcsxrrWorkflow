--- A module that allow to manage tools
-- @module tools
local M = {}

package.path = ";./src/?.lua;/.src/?.lua;./src/controller/?.lua;./dll/?.lua;./?.lua;../lua/?.lua;" ..package.path
package.cpath = ";./src/?.dll;/.src/?.lua;./src/controller/?.lua;./dll/?.dll;./?.dll;../lua/?.dll;" ..package.cpath

--- Check if the file exist
-- @function [parent=#tools] isFileExist
-- @param [parent=#tools] #string path
-- @return #boolean isFileExist
function M.isFileExist(path)
  local lfs=require("lfs");
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
    return false;
  end
end

--- Check if the path is valid for the windows file system
-- @function [parent=#tools] isFileExist
-- @param [parent=#tools] #string path
-- @return #boolean isFileExist
function M.isValidPath(path)
  if path == nil then return false end;
  local previousDir = path:gsub("[^\\]*$", "")
  previousDir = previousDir:gsub("[\\]*$", "");
  return M.isFileExist(previousDir);
end

--- Function used by to_string
local function table_print (tt, indent, done)
  done = done or {}
  indent = indent or 0
  if type(tt) == "table" then
    local sb = {}
    for key, value in pairs (tt) do
      table.insert(sb, string.rep (" ", indent)) -- indent it
      if type (value) == "table" and not done [value] then
        done [value] = true
        table.insert(sb, "{\n");
        table.insert(sb, table_print (value, indent + 2, done))
        table.insert(sb, string.rep (" ", indent)) -- indent it
        table.insert(sb, "}\n");
      elseif "number" == type(key) then
        table.insert(sb, string.format("\"%s\"\n", tostring(value)))
      else
        table.insert(sb, string.format(
          "%s = \"%s\"\n", tostring (key), tostring(value)))
      end
    end
    return table.concat(sb)
  else
    return tt .. "\n"
  end
end

--- Convert table to string
-- @function [parent=#tools] to_string
-- @param #table tbl
-- @param #boolean printIt
-- @return #string string
function M.to_string(tbl, printIt)
  local toStringValue = "";
  if  "nil"       == type( tbl ) then
    toStringValue = tostring(nil)
  elseif  "table" == type( tbl ) then
    toStringValue = table_print(tbl)
  elseif  "string" == type( tbl ) then
    toStringValue = tbl
  else
    toStringValue = tostring(tbl)
  end
  if(printIt) then
    print(toStringValue);
  end
  return toStringValue;
end

function M.testIupLib()
  if iup and iup.Message then
    --print(iup)
    --print(iup.Message)
    print("PCSXRR didn't close the lua script correctly previously. Please press 'STOP' and 'RUN' to try again(don't press on 'RESTART').");
    print("Closing the script...");
    restartMsg = "PCSXRR couldn't close the previous lua script correctly. You can press 'STOP' and 'RUN' to try again.";
    restartMsg = restartMsg .. " If this don't work, please restart PCSXRR completly.,";
    iup.Message("WARNING", restartMsg);
    return false;
  end
  print("all ok")
  return true;
end


return M;

