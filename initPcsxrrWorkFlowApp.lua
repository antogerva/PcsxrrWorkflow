
package.path = ";./src/?.lua;/.src/?.lua;./src/controller/?.lua;./dll/?.lua;./?.lua;../lua/?.lua;" ..package.path
package.cpath = ";?51.dll;./?.dll;./src/?.dll;src/?.dll;./dll/?.dll;./?.dll;../lua/?.dll;" ..package.cpath
package.cpath = [[C:\Users\antogerva\Downloads\koneki_git___org.eclipse.koneki.ldt-b1c5f0cc9ec8cf28cc39bcebf2925f9cefa1a376\git_fixes_x86\workspace\PcsxrrWorkflow\src\?.dll]] ..package.cpath

--GUI mode: the iup package must be the first package loaded
local iuplua_open = package.loadlib("iuplua51.dll", "iuplua_open");
local iuplua_close = package.loadlib("iuplua51.dll", "iuplua_close");
local iupcontrolslua_open = package.loadlib("iupluacontrols51.dll", "iupcontrolslua_open")
local iupcontrolslua_close = package.loadlib("iupluacontrols51.dll", "iupcontrolslua_close")

local emu=require("embedded.emu");
local movie=require("embedded.movie");

local winapi = require("external.winapi");

local lfs = require("lfs");
local tools = require("tools")
local config = require("model.config")
local controller = require("controller.controller")
--local workFlowPannel = require("view.WorkFlowPannel")

--todo use $1 or something to check gui mode

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
--main();
--tools.to_string(movie,true);

--winapi.beep("error")
--winapi.sleep(2000)
--winapi.beep("ok")
--winapi.beep("warning")
--winapi.beep("information")

