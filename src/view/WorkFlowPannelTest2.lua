print("init script")

package.cpath = ";?51.dll;./?.lua;./src/?.dll;/.src/?.lua;./dll/?.dll;./?.dll;../lua/?.dll;" ..package.cpath
package.cpath = [[C:\Users\antogerva\Downloads\koneki_git___org.eclipse.koneki.ldt-b1c5f0cc9ec8cf28cc39bcebf2925f9cefa1a376\git_fixes_x86\workspace\PcsxrrWorkflow\src\?.dll]] ..package.cpath

--print(debug.getinfo(1).short_src)

print("setted path")

--[[
function AddPostfixToPackagePath(postfix)
  print("add postfix")
  local function split(str, sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    str:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
  end
  local function endsWith(str, pat)
    if #str < #pat then
      return false
    end
    return str:sub(-#pat) == pat
  end

  print("funct done")

  local additionalpath = ""
  for i, v in ipairs(split(package.cpath, ";")) do
    --print(i)
    local newpath = nil
    if endsWith(v, "?.dll") then
      newpath = v:gsub("%?.dll", "") .. "?" .. postfix .. ".dll"
    elseif endsWith(v, "?.so") then
      newpath = v:gsub("%?.so", "") .. "?" .. postfix .. ".so"
    end
    if newpath then
      local duplicated = false
      for i2, v2 in ipairs(split(package.cpath, ";")) do
        if v2 == newpath then
          duplicated = true
          break
        end
      end
      if not duplicated then
        additionalpath = additionalpath .. ";" .. newpath
      end
    end
  end
  package.cpath = package.cpath .. additionalpath
end
--]]
--AddPostfixToPackagePath("51")

print("finished added")

local IupHandleManager = {
  handles = {};
  --print("setup manager");

  AddHandle = function(self, handle)
    if handle and handle.destroy then
      table.insert(self.handles, handle)
    end
  end;
  
  --[[
  --]]
  DestroyHandle = function(self, handle)
    print("desttroy")
    for handleIndex, handleCmp in ipairs(self.handles) do
      if handle == handleCmp then
        table.remove(self.handles, handleIndex)
        break
      end
    end
    if handle and handle.destroy then
      handle:destroy()
    end
  end;

  Dispose = function(self)
    for handleIndex, handle in ipairs(self.handles) do
      if handle and handle.destroy then
        handle:destroy()
        --self:DestroyHandle(handle);
      end
    end
    self.handles = {}
  end;
}

print("load lib")

--require "lfs"

--local currentDir = debug.getinfo(1).source;
--currentDir=currentDir:gsub("^@","");
--currentDir=currentDir:gsub("[^\\]*$","");
--print(currentDir)

  local iuplua_open = package.loadlib("iuplua51.dll", "iuplua_open");
  local iuplua_close = package.loadlib("iuplua51.dll", "iuplua_close");
  local iupcontrolslua_open = package.loadlib("iupluacontrols51.dll", "iupcontrolslua_open")
  local iupcontrolslua_close = package.loadlib("iupluacontrols51.dll", "iupcontrolslua_close")
  --if(iuplua_open == nil) then require("libiuplua51"); end
  
  if iup and iup.Message then
    print("PCSXRR didn't close the lua script correctly previously. Please press 'STOP' and 'RUN' to try again(don't press on 'RESTART').");
    print("Closing the script...");
    restartMsg = "PCSXRR couldn't close the previous lua script correctly. You can press 'STOP' and 'RUN' to try again.";
    restartMsg = restartMsg .. " If this don't work, please restart PCSXRR completly.,";
    iup.Message("WARNING", restartMsg);
    return;
  end 
  
  --somehow this piece of code is required when restarting a script with pcsxrr
  if not iup then
    iuplua_open();
  end
  require("iuplua")
  if iup then
    iuplua_open();
  end  
  
  iupcontrolslua_open()   
  print("loading more libs...")
  
  require "gd"
  require "lfs"
  require "winapi"
  --require "wx"
-- @module WorkFlowPannel

if emu then
  emu.registerexit(function()
    if(IupHandleManager) then
      print("dispose")
      if not iup then
        iuplua_open();        
      end
      IupHandleManager:Dispose()
      --print(collectgarbage("count"));
      iupcontrolslua_close();
      iuplua_close();
    else
      print("nope")
    end
  end)
end

print("begin diag")

local IupManager = {}
  IupManager.self={}
  
  ---  Open a directory picker dialog
  -- @function [parent = #ui] dirPicker
  -- @param #string message a message.
  -- @return #string the path
  IupManager.dirPicker= function (self,message)
    message = "Open 'calculator.xrc' resource file";

    local filedlg = iup.filedlg{ALLOWNEW="NO", dialogtype = "DIR", title = "Select a workspace", 
        directory=currentDir} 

    filedlg:popup (iup.ANYWHERE, iup.ANYWHERE)
    return filedlg.value;
  end;

  IupManager.filePicker =function(self, message, defaultText, filter)
    --fill the parameter
    local msg = "Open 'calculator.xrc' resource file";
    local defaultTxt = "calculator.xrc";

    --filter = "XRC files (*.xrc)|*.xrc|All files (*)|*";
    local flter = "*";

    local filedlg = iup.filedlg{ALLOWNEW="NO", dialogtype = "OPEN", title =msg, 
      filter = flter, filterinfo = "*", directory=currentDir} 
    filedlg:popup (iup.ANYWHERE, iup.ANYWHERE)

    return filedlg.value;
  end;
  
  IupManager.setPathToTxtField =function(self, txtField, filePath)
    --Ternary Operator
    txtField.value= (filePath~="" and filePath) or txtField.value;    
    --txtField.value= (filePath~="" and filePath) or (txtField.value and txtField.value) or "";
  end;

  IupManager.onPick0 =function(self)
    local filePath = IupManager.filePicker();
    IupManager.setPathToTxtField(self, IupManager.self.txtPcsxrr, filePath);
  end;
  
  IupManager.onPick1 =function(self)
    local filePath = IupManager.filePicker();
    IupManager.setPathToTxtField(self, IupManager.self.txtMovie, filePath);
  end;

  IupManager.onPick2 = function(self)
    --local filePath = gui.filepicker("Please select a workflow", "*");
    local message = "Please select a workflow";
    local filePath = IupManager.dirPicker(message);
    IupManager.setPathToTxtField(self, IupManager.self.txtWorkflow, filePath);
  end;
  
  IupManager.onPick3= function(self)
    local filePath = IupManager.filePicker("Please select the TAS SPU plugin", "dll", "*");
    IupManager.setPathToTxtField(self, IupManager.self.txtTasSpu, filePath);
  end;
  
  IupManager.onPick4= function(self)
    local filePath = IupManager.filePicker("Please select the Eternal SPU plugin", "dll");
    IupManager.setPathToTxtField(self, IupManager.self.txtEternalSpu, filePath);
  end;
  
  IupManager.onUpdateData = function(self)
    --iup.Message("title","test")
    print("test")
    print("test2")
    print(lfs and "ok!!!" or "nope!!!")
    --print(gd)
    print(lfs.currentdir())
    
  end;
  
  IupManager.onRefreshScreen = function(self)
    print("Refreshing the screen");
  end;

local idle_cb_called = false
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
        --iup.item{
        --title = "Enable Rewind",
        --value="OFF",
        --action = function(self)
        --enableRewind = not enableRewind
        --toggleMenuItem(self)
        --end},
        --showTricksItem,
          iup.item{
            title = "Debugging",
            value="OFF",
            action = function(self)
              require("wx") 
              wxlua.LuaStackDialog();
            --toggleMenuItem(self)
            end},
      }; title="Settings",
    },
  };  
  --[[
  --]]
  print("add diag component")
  
  local txtPcsxrr = nil;
  local txtMovie = nil;
  local txtWorkflow = nil;
  local txtTasSpu = nil;
  local txtEternalSpu = nil;
  
  local txtNote1 = nil;
  local txtNote2 = nil;
  
  txtPcsxrr = iup.text{size="290x",value=""};
  txtMovie = iup.text{size="290x",value=""};
  txtWorkflow = iup.text{size="290x",value=""};
  txtTasSpu =  iup.text{size="290x",value=""};
  txtEternalSpu =  iup.text{size="290x",value=""};
  
  txtNote1=iup.text{value="", expand="YES"};
  txtNote2=iup.text{value="", expand="YES"};
  
  IupManager.self={txtPcsxrr=txtPcsxrr,txtMovie=txtMovie,txtWorkflow=txtWorkflow,txtTasSpu=txtTasSpu,txtEternalSpu=txtEternalSpu}
        
  print("add filepath control")

  --iup.text{multiline="YES", readonly="YES", expand="YES", wordwrap="YES"}

  local maintext =  iup.vbox{          
    iup.hbox{
      iup.label{title="PCSXRR \t\t\t"},
      txtPcsxrr,
      iup.button{title="Pick", padding="10x0", action=IupManager.onPick0},
    },            
    iup.hbox{
      iup.label{title="Movie \t\t\t\t"},
      txtMovie,
      iup.button{title="Pick", padding="10x0", action=IupManager.onPick1},
    },                   
    iup.hbox{
      iup.label{title="Workflow\t\t"},
      txtWorkflow,
      iup.button{title="Pick", padding="10x0", action=IupManager.onPick2},
    },
    iup.hbox{
      iup.label{title="TAS SPU\t\t\t"},
      txtTasSpu,                
      iup.button{title="Pick", padding="10x0", action=IupManager.onPick3},
    },
    iup.hbox{
      iup.label{title="Eternal SPU\t"},
      txtEternalSpu,                
      iup.button{title="Pick", padding="10x0", action=IupManager.onPick4},
    },
    iup.hbox{
      txtNote1,
      txtNote2,
    },
  --iup.text{size="300x",value=""},
  --iup.text{size="300x",value=""}
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
      --iup.menu{ },
      mainMenu,
      iup.vbox{
        maintext,
        iup.hbox{
          iup.button{title="Update data", padding="10x0", action=IupManager.onUpdateData},
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

  -- Register iup handle for finalization
  --IupHandleManager:AddHandle(dlg)

  -- Idle function test
  --[[
  iup.SetIdle(function()
    if not idle_cb_called then
      print("Idle function is called.")
      idle_cb_called = true
    end
    return iup.DEFAULT
  end)
  --]]

    
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

testiup()

if emu then
  --nothing to do here
else
  iup.MainLoop()
end

