

package.path = ";./src/?.lua;/.src/?.lua;./src/controller/?.lua;./src/model/?.lua;./dll/?.lua;./?.lua;../lua/?.lua;" ..package.path
package.cpath = ";?51.dll;src/?51.dll;./?.dll;./src/?.dll;src/?.dll;./dll/?.dll;./?.dll;../lua/?.dll;" ..package.cpath
package.cpath = [[C:\Users\antogerva\Downloads\koneki_git___org.eclipse.koneki.ldt-b1c5f0cc9ec8cf28cc39bcebf2925f9cefa1a376\git_fixes_x86\workspace\PcsxrrWorkflow\src\?.dll]] ..package.cpath


--os.execute("SET LUA_PATH=;src\?.lua;src\?\init.lua;src\?.luac;src\?\init.luac;src\socket\?.lua;src\socket\?\init.lua;src\socket\?.luac;src\socket\?\init.luac;")
--os.execute("SET LUA_CPATH=;src\?.lua;src\?\init.lua;src\?.luac;src\?\init.luac;src\socket\?.lua;src\?51.dll;src\socket\?\init.lua;src\socket\?.luac;src\socket\?\init.luac;")

---
-- @module workFlowPannel

local M= {}

local iuplua_open = package.loadlib("iuplua51.dll", "iuplua_open");
local iuplua_close = package.loadlib("iuplua51.dll", "iuplua_close");
local iupcontrolslua_open = package.loadlib("iupluacontrols51.dll", "iupcontrolslua_open")
local iupcontrolslua_close = package.loadlib("iupluacontrols51.dll", "iupcontrolslua_close");
local iup_pplotlua_open = package.loadlib("iuplua_pplot51.dll", "iup_pplotlua_open");

--local tools=require("tools")
--local gd=require("gd")
local lfs=require("lfs")
local winapi=require("winapi")

--local config={new=function() end;} --TODO test
local config=require("model.config")

--local controller={new=function() end;} --TODO test
local controller=require("controller.controller")


--- IupHandleManager 
-- @type iupHandleManager
-- @field [parent=#iupHandleManager] #table handles
local IupHandleManager = {handles={}}

--- Add a handle
-- @function [parent=#iupHandleManager] AddHandle
-- @param #iupHandleManager self
-- @param #handle handle
function IupHandleManager.AddHandle(self, handle)
  if handle and handle.destroy then
    table.insert(self.handles, handle)
  end
end

--- Remove a handle
-- @function [parent=#iupHandleManager] Dispose
-- @param #iupHandleManager self
-- @param #handle handle
function IupHandleManager.Dispose(self)
  for handleIndex, handle in ipairs(self.handles) do
    if handle and handle.destroy then
      handle:destroy()
    end
  end
  self.handles = {}
end


function M.loadIupLib()
  if iup and iup.Message then
    print("PCSXRR didn't close the lua script correctly previously. Please press 'STOP' and 'RUN' to try again(don't press on 'RESTART').");
    print("Closing the script...");
    restartMsg = "PCSXRR couldn't close the previous lua script correctly. You can press 'STOP' and 'RUN' to try again.";
    restartMsg = restartMsg .. " If this don't work, please restart PCSXRR completly.,";
    iup.Message("WARNING", restartMsg);
    return false;
  end  
  --somehow this piece of code is required when restarting a script with pcsxrr
  if not iup then
    iuplua_open();
  end
  require("iuplua")
  if iup then
    iuplua_open();
  end  
  iupcontrolslua_open();  
  --iup_pplotlua_open();
  return M;
end



local IupManager = {}
IupManager.self={txtPcsxrr=nil,txtMovie=nil,txtWorkflow=nil,txtTasSpu=nil,txtEternalSpu=nil}

function IupManager.dirPicker(message)
  message = "Open 'calculator.xrc' resource file";
  local filedlg = iup.filedlg{ALLOWNEW="NO", dialogtype = "DIR", title = "Select a workspace", directory=lfs.currentdir()} 

  filedlg:popup(iup.ANYWHERE, iup.ANYWHERE)
  return filedlg.value;
end;

function IupManager.filePicker(self, message, defaultText, filter)
  --fill the parameter
  local msg = "Open a resource file";
  local defaultTxt = "";

  --filter = "XRC files (*.xrc)|*.xrc|All files (*)|*";
  local flter = "*";

  local filedlg = iup.filedlg{ALLOWNEW="NO", dialogtype = "OPEN", title =msg, 
    filter = flter, filterinfo = "*", directory=lfs.currentdir()} 
  filedlg:popup (iup.ANYWHERE, iup.ANYWHERE)

  return filedlg.value;
end;

function IupManager.setPathToTxtField(txtField, filePath)
  --Ternary Operator
  txtField.value= (filePath~="" and filePath) or txtField.value;    
--txtField.value= (filePath~="" and filePath) or (txtField.value and txtField.value) or "";
end;

function IupManager.onPick0()
  local filePath = IupManager.filePicker();
  IupManager.setPathToTxtField(IupManager.self.txtPcsxrr, filePath);
end;

function IupManager.onPick1()
  local filePath = IupManager.filePicker();
  IupManager.setPathToTxtField(IupManager.self.txtMovie, filePath);
end;

function IupManager.onPick2()
  --local filePath = gui.filepicker("Please select a workflow", "*");
  local message = "Please select a workflow";
  local filePath = IupManager.dirPicker(message);
  IupManager.setPathToTxtField(IupManager.self.txtWorkflow, filePath);
end;

function IupManager.onPick3()
  local filePath = IupManager.filePicker("Please select the TAS SPU plugin", "dll", "*");
  IupManager.setPathToTxtField(IupManager.self.txtTasSpu, filePath);
end;

function IupManager.onPick4()
  local filePath = IupManager.filePicker("Please select the Eternal SPU plugin", "dll");
  IupManager.setPathToTxtField(IupManager.self.txtEternalSpu, filePath);
end;

function IupManager.onStartDetection()
  controller.detection();
end;

function IupManager.onRefreshScreen(self)
  print("Refreshing the screen");
end;




local function testiup()
  print("start diag")
  local mainMenu=iup.menu{
    iup.submenu{
      iup.menu{
        iup.item{
          title = "Open Config",
          value="OFF",
          action = function(self) 
          end},

        iup.item{
          title = "Save Config",
          value="OFF",
          action = function(self) 
          end},

        iup.separator{},

        iup.item{
          title = "Show Detection data",
          value="OFF",
          action = function(self)
          end},

        iup.item{
          title = "Show Sync data",
          value="OFF",
          action = function(self)
          end},
      }; title="WorkFlow",
    },
    iup.submenu{
      iup.menu{
        iup.item{
          title = "Debugging",
          value="OFF",
          action = function(self)
            require("wx") 
            wxlua.LuaStackDialog();
          end},
      }; title="Settings",
    },
  };

  print("add diag component")


  local txtNote1 = nil;
  local txtNote2 = nil;
  
  IupManager.self.txtPcsxrr = iup.text{size="290x",value=""};
  IupManager.self.txtMovie = iup.text{size="290x",value=""};
  IupManager.self.txtWorkflow = iup.text{size="290x",value=""};
  IupManager.self.txtTasSpu =  iup.text{size="290x",value=""};
  IupManager.self.txtEternalSpu =  iup.text{size="290x",value=""};

  txtNote1=iup.text{value="", expand="YES"};
  txtNote2=iup.text{value="", expand="YES"};

  --IupManager.self={txtPcsxrr=txtPcsxrr,txtMovie=txtMovie,txtWorkflow=txtWorkflow,txtTasSpu=txtTasSpu,txtEternalSpu=txtEternalSpu}

  local maintext =  iup.vbox{          
    iup.hbox{
      iup.label{title="PCSXRR \t\t\t"},
      IupManager.self.txtPcsxrr,
      iup.button{title="Pick", padding="10x0", action=IupManager.onPick0},
    },            
    iup.hbox{
      iup.label{title="Movie \t\t\t\t"},
      IupManager.self.txtMovie,
      iup.button{title="Pick", padding="10x0", action=IupManager.onPick1},
    },                   
    iup.hbox{
      iup.label{title="Workflow\t\t"},
      IupManager.self.txtWorkflow,
      iup.button{title="Pick", padding="10x0", action=IupManager.onPick2},
    },
    iup.hbox{
      iup.label{title="TAS SPU\t\t\t"},
      IupManager.self.txtTasSpu,                
      iup.button{title="Pick", padding="10x0", action=IupManager.onPick3},
    },
    iup.hbox{
      iup.label{title="Eternal SPU\t"},
      IupManager.self.txtEternalSpu,                
      iup.button{title="Pick", padding="10x0", action=IupManager.onPick4},
    },
    iup.hbox{
      txtNote1,
      txtNote2,
    },
  }
  print("add diag event")

  local maintextNoteList = {}

  local eventList = {}
  local eventTimes = {}
  local lastEventTime = 0
  for i,event in ipairs(eventList) do
    if event.time > lastEventTime then lastEventTime = event.time end;
    eventTimes[event.time] = i
  end;

  -- Create the dialog
  local dlg = iup.dialog{
    menu=
      mainMenu,
      iup.vbox{
        maintext,
        iup.hbox{
          iup.button{title="Start Detection", padding="10x0", action=IupManager.onStartDetection},
          iup.fill{expand="YES"},
          iup.button{title="Pause", padding="20x0", action=IupManager.onPauseButton},
          iup.button{title="Unpause", padding="10x0", action=IupManager.onUnpauseButton},
          iup.fill{expand="YES"},
          iup.button{title="Refresh Screen", padding="10x0", action=IupManager.onRefreshScreen},
        },
      };
    title="PCSX Workflow",
    margin="10x10",
    size="400x200",
  }

  k,err = winapi.open_reg_key([[HKEY_CURRENT_USER\Software\PCSX-RR]], true)
  if not k then 
    return print('bad key',err)  --pcsxrr never ever run on the host computer?
  end  
  --k:set_value("PluginSPU",stringValue, winapi.REG_SZ);
  print(k:get_value("PluginSPU"))
  txtNote1.value = k:get_value("PluginSPU");
  k:close()

  IupHandleManager:AddHandle(dlg)

  -- Show the dialog
  print("show diag")
  dlg:show()

  print("diag on place")
end

---
--@type pannel
--@field [parent=#pannel] @{config} conf
local P={conf=config.new(),ctrl=controller.new()};


---Create new config
-- @function [parent=#workFlowPannel] new
-- @param #configData conf
-- @param #controllerInstance ctrl
-- @return #workFlowPannelInstance
function M.new(conf,ctrl)
  local newPannel = {conf=conf,ctrl=ctrl};
  
  -- set to new config the properties of a configInstance
  setmetatable(newPannel,{__index=P})
  return newPannel;  
end

--- Start the pannel
-- @function [parent=#workFlowPannelInstance] startWorkFlowPannel
function P.startWorkFlowPannel()
  if emu then
    emu.registerexit(function()
      if(IupHandleManager) then
        print("dispose")
        if not iup then
          iuplua_open();        
        end
        IupHandleManager:Dispose();
        iupcontrolslua_close();
        iuplua_close();
      else
        print("nope")
      end
    end)
  end
  
  local idle_cb_called = false;
  testiup();
  if P.conf then      
    IupManager.self.txtEternalSpu.value = P.conf.confData.ETERNAL_SPU;
    IupManager.self.txtMovie.value = P.conf.confData.Movie;
    IupManager.self.txtTasSpu.value=P.conf.confData.TAS_SPU;
    IupManager.self.txtPcsxrr.value=P.conf.confData.PCSXRR;
    IupManager.self.txtWorkflow.value=P.conf.confData.Workflow;
  end
  if pcsx then
    --nothing to do here
  else
    iup.MainLoop()
  end
end

M.loadIupLib();
M.new(nil,nil).startWorkFlowPannel();

return M;

--[[

--]]

--[[

--- IupHandleManager 
-- @type iupHandleManager
local IupHandleManager = {  
  --- Contain the handles used by iup 
  -- @field [parent=#iupHandleManager] #table handles
  handles = {};

  --- Add a handle
  -- @function [parent=#iupHandleManager] AddHandle
  -- @param #iupHandleManager self
  -- @param #handle handle
  AddHandle = function(self, handle)
    if handle and handle.destroy then
      table.insert(self.handles, handle)
    end
  end;

  --- Remove a handle
  -- @function [parent=#iupHandleManager] Dispose
  -- @param #iupHandleManager self
  -- @param #handle handle
  Dispose = function(self)
    for handleIndex, handle in ipairs(self.handles) do
      if handle and handle.destroy then
        handle:destroy()
      end
    end
    self.handles = {}
  end;
}


--]]

--[[
--]]

--[[

local IupManager = {
  filePicker=function(self, message, defaultText, filter)
    --fill the parameter
    local msg = "Open 'calculator.xrc' resource file";
    local defaultTxt = "calculator.xrc";  
    --filter = "XRC files (*.xrc)|*.xrc|All files (*)|*";
    local flter = "*";  
    local filedlg = iup.filedlg{ALLOWNEW="NO", dialogtype = "OPEN", title =msg,filter = flter, filterinfo = "*", directory=currentDir} 
    filedlg:popup (iup.ANYWHERE, iup.ANYWHERE)  
    return filedlg.value;
  end;
  bloblo = "ff";
  self={};  
  dirPicker=function(self,message)
    message = "Open 'calculator.xrc' resource file";  
    local filedlg = iup.filedlg{ALLOWNEW="NO", dialogtype = "DIR", title = "Select a workspace",directory=currentDir}  
    filedlg:popup(iup.ANYWHERE, iup.ANYWHERE)
    return filedlg.value;
  end;


  setPathToTxtField=function(self, txtField, filePath)
    --Ternary Operator
    txtField.value= (filePath~="" and filePath) or txtField.value;    
    --txtField.value= (filePath~="" and filePath) or (txtField.value and txtField.value) or "";
  end;
  
  onPick0=function()
    tools.to_string(self,true)
    local filePath = IupManager.filePicker();
    IupManager.setPathToTxtField(self, IupManager.self.txtPcsxrr, filePath);
  end;
  
  onPick1=function(self)
    local filePath = IupManager.filePicker();
    IupManager.setPathToTxtField(self, IupManager.self.txtMovie, filePath);
  end;
  
  onPick2=function(self)
    --local filePath = gui.filepicker("Please select a workflow", "*");
    local message = "Please select a workflow";
    local filePath = IupManager.dirPicker(message);
    IupManager.setPathToTxtField(self, IupManager.self.txtWorkflow, filePath);
  end;
  
  onPick3=function(self)
    local filePath = IupManager.filePicker("Please select the TAS SPU plugin", "dll", "*");
    IupManager.setPathToTxtField(self, IupManager.self.txtTasSpu, filePath);
  end;
  
  onPick4=function(self)
    local filePath = IupManager.filePicker("Please select the Eternal SPU plugin", "dll");
    IupManager.setPathToTxtField(self, IupManager.self.txtEternalSpu, filePath);
  end;
  
  onUpdateData=function(self)
    print("test")
    print("test2")
    print(lfs and "ok!!!" or "nope!!!")
    print(lfs.currentdir())
  end;
  
  
  onRefreshScreen=function(self)
    print("Refreshing the screen");
  end;  
}
--]]
