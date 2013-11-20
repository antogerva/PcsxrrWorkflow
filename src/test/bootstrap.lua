--- A module that allow to manage tools
-- @module bootstrap
local M = {}
  local function fixPath()
    local currentDir = debug.getinfo(1).source;
    print(package.cpath)
    currentDir=currentDir:gsub("^@","");
    currentDir=currentDir:gsub("[^\\]*$","")
    --currentDir=currentDir:gsub("[^\\]*$","")  --.. [[..\lib\?.dll;]] 
    print(currentDir)  
    package.cpath= currentDir.. package.cpath
  end
  fixPath()
  print(package.cpath)

return package.cpath;

