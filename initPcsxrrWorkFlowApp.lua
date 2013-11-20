
package.path = ";./src/?.lua;/.src/?.lua;./src/controller/?.lua;./dll/?.lua;./?.lua;../lua/?.lua;" ..package.path
package.cpath = ";?51.dll;./?.dll;./src/?.dll;src/?.dll;./dll/?.dll;./?.dll;../lua/?.dll;" ..package.cpath
package.cpath = debug.getinfo(1).source:gsub("^@",""):gsub("[^\\]*$","").. [[lib\?.dll;]] ..package.cpath

--GUI mode: the iup package must be the first compiled package loaded if the emulator doesn't already "preload it"
local iuplua_open = package.loadlib("iuplua51.dll", "iuplua_open");
local iuplua_close = package.loadlib("iuplua51.dll", "iuplua_close");
local iupcontrolslua_open = package.loadlib("iupluacontrols51.dll", "iupcontrolslua_open")
local iupcontrolslua_close = package.loadlib("iupluacontrols51.dll", "iupcontrolslua_close")

local tools = require("tools")
local emu=require("embedded.emu");
local movie=require("embedded.movie");
local winapi = require("winapi");
local lfs = require("lfs");
local config = require("model.config")
local controller = require("controller.controller")
local workFlowPannel = require("view.WorkFlowPannel")

--TODO use $1 or something to check gui/command mode
local function main()
  --GUI mode
  if(tools.testIupLib()) then
    local confPath= lfs.currentdir() .. "\\" .. "conf.properties";
    local conf = config.new(confPath);
    local data = conf.load(self,confPath);
    local ctrl = controller.new();
      
    local pannel = workFlowPannel.new(conf,ctrl);
    workFlowPannel.loadIupLib();
    pannel.startWorkFlowPannel();
  end
end

main();
