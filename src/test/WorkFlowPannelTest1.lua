--local PATH = debug.getinfo(1).source;
--print(PATH)


--os.execute("SET LUA_PATH=;src\?.lua;src\?\init.lua;src\?.luac;src\?\init.luac;src\socket\?.lua;src\socket\?\init.lua;src\socket\?.luac;src\socket\?\init.luac;")
--os.execute("SET LUA_CPATH=;src\?.lua;src\?\init.lua;src\?.luac;src\?\init.luac;src\socket\?.lua;src\socket\?\init.lua;src\socket\?.luac;src\socket\?\init.luac;")

print("init script")

package.cpath = ";?51.dll;./src/?.dll;/.src/?.lua;./dll/?.dll;./?.dll;../lua/?.dll;" ..package.cpath

print("setted path")

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
                print(i)
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
AddPostfixToPackagePath("51")

print("finished added")

local IupHandleManager = {
  handles = {};
  print("setup manager");

  AddHandle = function(self, handle)
    if handle and handle.destroy then
      table.insert(self.handles, handle)
    end
  end;

  DestroyHandle = function(self, handle)
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
      end
    end
    self.handles = {}
  end;
}

print("load lib")

local iuplua_open = package.loadlib("iuplua51.dll", "iuplua_open");
if(iuplua_open == nil) then require("libiuplua51"); end
iuplua_open();
require("iuplua");
--require("wx")
wx = {}
wxlua = {}

-- @module WorkFlowPannelTest











--handles = {}; -- this table should hold the handle to all dialogs created in lua
--dialogs = 0; -- should be incremented PRIOR to creating a new dialog

-- called by the onclose event (above)
--[[
function OnCloseIup()
print("close!!!")
if (handles) then -- just in case the user was "smart" enough to clear this
local i = 1;
while (handles[i] ~= nil) do -- cycle through all handles, false handles are skipped, nil denotes the end
if (handles[i] and handles[i].destroy) then -- check for the existence of what we need
handles[i]:destroy(); -- close this dialog (:close() just hides it)
handles[i] = nil;
print(i)
end;
i = i + 1;
end;
end;
end;
--]]


--[[
function emu.iuplua()
--gui.popup("OnClose!");
print("close!!1111")
if(emu and emu.OnCloseIup ~= nil) then
emu.OnCloseIup();
end
iup.Close();
end

--]]



--Set up the list of registered gui functions
--[[
gui_registered_funcs = {}
all_ordered_registered_funcs = {}
local function register_func(fname, f)
table.insert(all_ordered_registered_funcs, fname)
gui_registered_funcs[fname] = f
end;
--]]

--[[

gui.register( function()
for i,fname in ipairs(all_ordered_registered_funcs) do
f = gui_registered_funcs[fname]
--can set value to nil to  turn off
if f then f() end;
end;
emu.registerexit(emu.iuplua);

end)


--]]

if emu then
  emu.registerexit(function()
    if(IupHandleManager) then
      print("dispose")
      IupHandleManager:Dispose()
      print(collectgarbage("count"));
    else
      print("nope")
    end
  end)
end


--[[
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
--
--iup.item{
--title = "Enable Rewind",
--value="OFF",
--action = function(self)
--enableRewind = not enableRewind
--toggleMenuItem(self)
--end},
--showTricksItem,
--
iup.item{
title = "Debugging",
value="OFF",
action = function(self)     
wxlua.LuaStackDialog();
--toggleMenuItem(self)
end},
}; title="Settings",
},
};

txtMovie = iup.text{size="290x",value=""};
txtWorkflow = iup.text{size="290x",value=""};
txtTasSpu =  iup.text{size="290x",value=""};
txtEternalSpu =  iup.text{size="290x",value=""};

---  Open a directory picker dialog
-- @function [parent = #ui] dirPicker
-- @param #string message a message.
-- @return #string the path
function dirPicker(message)
message = "Open 'calculator.xrc' resource file";
local currentDir = wx.wxGetCwd();
local dirDialog = wx.wxDirDialog(wx.NULL,
message,
currentDir,
wx.wxOPEN + wx.wxFILE_MUST_EXIST)

local folderPath = "";
if dirDialog:ShowModal() == wx.wxID_OK then
folderPath = dirDialog:GetPath()
end

return folderPath;
end

function filePicker(message, defaultText, filter)
message = "Open 'calculator.xrc' resource file";
defaultText = "calculator.xrc";

--filter = "XRC files (*.xrc)|*.xrc|All files (*)|*";
filter = "*";

local fileDialog = wx.wxFileDialog(wx.NULL,
message,
"",
defaultText,
filter,
wx.wxOPEN + wx.wxFILE_MUST_EXIST)

local filePath = "";

if fileDialog:ShowModal() == wx.wxID_OK then
filePath = fileDialog:GetPath()
end

return filePath;
end

local function onPick1()
txtMovie.value = filePicker();
end

local function onPick2()
--local filePath = gui.filepicker("Please select a workflow", "*");
txtWorkflow.value = dirPicker(message);
end
local function onPick3()
local filePath = gui.filepicker("Please select the TAS SPU plugin", "dll");
txtTasSpu.value = filePath;
end
local function onPick4()
local filePath = gui.filepicker("Please select the Eternal SPU plugin", "dll");
txtEternalSpu.value = filePath;
end

--iup.text{multiline="YES", readonly="YES", expand="YES", wordwrap="YES"}

maintext =  iup.vbox{          
iup.hbox{
iup.label{title="Movie \t\t\t\t"},
txtMovie,
iup.button{title="Pick", padding="10x0", action=onPick1},
},                   
iup.hbox{
iup.label{title="Workflow\t\t"},
txtWorkflow,
iup.button{title="Pick", padding="10x0", action=onPick2},
},
iup.hbox{
iup.label{title="TAS SPU\t\t\t"},
txtTasSpu,                
iup.button{title="Pick", padding="10x0", action=onPick3},
},
iup.hbox{
iup.label{title="Eternal SPU\t"},
txtEternalSpu,                
iup.button{title="Pick", padding="10x0", action=onPick4},
},
iup.hbox{
iup.text{value="", expand="YES"},
iup.text{value="", expand="YES"},
},
--iup.text{size="300x",value=""},
--iup.text{size="300x",value=""}
}

maintextNoteList = {}

eventList = {}
eventTimes = {}
lastEventTime = 0
for i,event in ipairs(eventList) do
if event.time > lastEventTime then lastEventTime = event.time end;
eventTimes[event.time] = i
end;

local function onUpdateData()
iup.Message("title","test")
end;

local function onRefreshScreen()
print("Refreshing the screen");
end;

--]]

--[[
dlg1 = iup.dialog{
menu=mainMenu,
iup.vbox{
maintext,
iup.hbox{
iup.button{title="Update data", padding="10x0", action=onUpdateData},
iup.fill{expand="YES"},
iup.button{title="Pause", padding="20x0", action=onPauseButton},
iup.button{title="Unpause", padding="10x0", action=onUnpauseButton},
iup.fill{expand="YES"},
iup.button{title="Refresh Screen", padding="10x0", action=onRefreshScreen},
},
};
title="PCSX Workflow",
margin="10x10",
size="400x200",
}
--]]

--IupHandleManager:AddHandle(dlg1)

print("begin diag")
  
local idle_cb_called = false
function testiup()

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
        --[[
        iup.item{
        title = "Enable Rewind",
        value="OFF",
        action = function(self)
        enableRewind = not enableRewind
        toggleMenuItem(self)
        end},
        showTricksItem,
        --]]
          iup.item{
            title = "Debugging",
            value="OFF",
            action = function(self)     
              wxlua.LuaStackDialog();
            --toggleMenuItem(self)
            end},
      }; title="Settings",
    },
  };

  local txtMovie = iup.text{size="290x",value=""};
  local txtWorkflow = iup.text{size="290x",value=""};
  local txtTasSpu =  iup.text{size="290x",value=""};
  local txtEternalSpu =  iup.text{size="290x",value=""};

  ---  Open a directory picker dialog
  -- @function [parent = #ui] dirPicker
  -- @param #string message a message.
  -- @return #string the path
  local function dirPicker(message)
    message = "Open 'calculator.xrc' resource file";
    local currentDir = wx.wxGetCwd();
    local dirDialog = wx.wxDirDialog(wx.NULL,
      message,
        currentDir,
        wx.wxOPEN + wx.wxFILE_MUST_EXIST)

    local folderPath = "";
    if dirDialog:ShowModal() == wx.wxID_OK then
      folderPath = dirDialog:GetPath()
    end

    return folderPath;
  end

  local function filePicker(message, defaultText, filter)
    --fill the parameter
    local msg = "Open 'calculator.xrc' resource file";
    local defaultTxt = "calculator.xrc";

    --filter = "XRC files (*.xrc)|*.xrc|All files (*)|*";
    local flter = "*";

    local fileDialog = wx.wxFileDialog(wx.NULL,
      msg,
        "",
        defaultTxt,
        flter,
        wx.wxOPEN + wx.wxFILE_MUST_EXIST)

    local filePath = "";

    if fileDialog:ShowModal() == wx.wxID_OK then
      filePath = fileDialog:GetPath()
    end

    return filePath;
  end

  local function onPick1()
    txtMovie.value = filePicker();
  end

  local function onPick2()
    --local filePath = gui.filepicker("Please select a workflow", "*");
    --txtWorkflow.value = dirPicker(message);
  end
  local function onPick3()
    --local filePath = gui.filepicker("Please select the TAS SPU plugin", "dll");
    --txtTasSpu.value = filePath;
  end
  local function onPick4()
    --local filePath = gui.filepicker("Please select the Eternal SPU plugin", "dll");
    --txtEternalSpu.value = filePath;
  end

  --iup.text{multiline="YES", readonly="YES", expand="YES", wordwrap="YES"}

  local maintext =  iup.vbox{          
    iup.hbox{
      iup.label{title="Movie \t\t\t\t"},
      txtMovie,
      iup.button{title="Pick", padding="10x0", action=onPick1},
    },                   
    iup.hbox{
      iup.label{title="Workflow\t\t"},
      txtWorkflow,
      iup.button{title="Pick", padding="10x0", action=onPick2},
    },
    iup.hbox{
      iup.label{title="TAS SPU\t\t\t"},
      txtTasSpu,                
      iup.button{title="Pick", padding="10x0", action=onPick3},
    },
    iup.hbox{
      iup.label{title="Eternal SPU\t"},
      txtEternalSpu,                
      iup.button{title="Pick", padding="10x0", action=onPick4},
    },
    iup.hbox{
      iup.text{value="", expand="YES"},
      iup.text{value="", expand="YES"},
    },
  --iup.text{size="300x",value=""},
  --iup.text{size="300x",value=""}
  }

  local maintextNoteList = {}

  local eventList = {}
  local eventTimes = {}
  local lastEventTime = 0
  for i,event in ipairs(eventList) do
    if event.time > lastEventTime then lastEventTime = event.time end;
    eventTimes[event.time] = i
  end;

  local function onUpdateData()
    iup.Message("title","test")
  end;

  local function onRefreshScreen()
    print("Refreshing the screen");
  end;






  -- Our callback function
  --local function someAction(self, a) print("My button is pressed!"); end;

  -- Create a button
  --myButton = iup.button{title="Press me", size="60x16"};

  -- Set the callback
  --myButton.action = someAction;

  -- Create the dialog
  local dlg = iup.dialog{
    menu=mainMenu,
      iup.vbox{
        maintext,
        iup.hbox{
          iup.button{title="Update data", padding="10x0", action=onUpdateData},
          iup.fill{expand="YES"},
          iup.button{title="Pause", padding="20x0", action=onPauseButton},
          iup.button{title="Unpause", padding="10x0", action=onUnpauseButton},
          iup.fill{expand="YES"},
          iup.button{title="Refresh Screen", padding="10x0", action=onRefreshScreen},
        },
      };
    title="PCSX Workflow",
    margin="10x10",
    size="400x200",
  }

  -- Register iup handle for finalization
  IupHandleManager:AddHandle(dlg)

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

  -- Show the dialog
  print("show diag")
  dlg:show()
end
testiup()

--[[
iup.SetIdle(function()
if not idle_cb_called then
print("Idle function is called.")
idle_cb_called = true
end
return iup.DEFAULT
end)
--]]

--dlg1:show()

--[[
dialogs = dialogs + 1
handles[dialogs] = iup.dialog{
menu=mainMenu,
iup.vbox{
maintext,
iup.hbox{
iup.button{title="Update data", padding="10x0", action=onUpdateData},
iup.fill{expand="YES"},
iup.button{title="Pause", padding="20x0", action=onPauseButton},
iup.button{title="Unpause", padding="10x0", action=onUnpauseButton},
iup.fill{expand="YES"},
iup.button{title="Refresh Screen", padding="10x0", action=onRefreshScreen},
},
};
title="PCSX Workflow",
margin="10x10",
size="400x200",
}
handles[dialogs]:show()
--]]


if emu then
else
  iup.MainLoop()
end

