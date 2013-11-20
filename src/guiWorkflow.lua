


package.cpath = ";?51.dll;./?.lua;./src/?.dll;/.src/?.lua;./dll/?.dll;./?.dll;../lua/?.dll;" ..package.cpath
package.cpath = [[C:\Users\antogerva\Downloads\koneki_git___org.eclipse.koneki.ldt-b1c5f0cc9ec8cf28cc39bcebf2925f9cefa1a376\git_fixes_x86\workspace\PcsxrrWorkflow\src\?.dll]] ..package.cpath

--require "gd"
--require "lfs"

-- This script shows a simple button and click event
-- this includes the iup system
local iuplua_open = package.loadlib("iuplua51.dll", "iuplua_open");
if(iuplua_open == nil) then require("libiuplua51"); end
iuplua_open();

-- this includes the "special controls" of iup (dont change the order though)
--local iupcontrolslua_open = package.loadlib("iupluacontrols51.dll", "iupcontrolslua_open");
--if(iupcontrolslua_open == nil) then require("libiupluacontrols51"); end
--iupcontrolslua_open();
require("iuplua");

if not emu and not gui then
  emu = {}
  gui = {}
end

--TODO!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--LUACALL_BEFOREEXIT use that instead of emu.OnClose below

-- callback function to clean up our mess
-- this is called when the script exits (forced or natural)
-- you need to close all the open dialogs here or FCEUX crashes
function emu.iuplua()
  --gui.popup("OnClose!");
  if(emu and emu.OnCloseIup ~= nil) then
    emu.OnCloseIup();
  end
  iup.Close();
end

-- this system allows you to open a number of dialogs without
-- having to bother about cleanup when the script exits
handles = {}; -- this table should hold the handle to all dialogs created in lua
dialogs = 0; -- should be incremented PRIOR to creating a new dialog

-- called by the onclose event (above)
function OnCloseIup()
  if (handles) then -- just in case the user was "smart" enough to clear this
    local i = 1;
    while (handles[i] ~= nil) do -- cycle through all handles, false handles are skipped, nil denotes the end
      if (handles[i] and handles[i].destroy) then -- check for the existence of what we need
        handles[i]:destroy(); -- close this dialog (:close() just hides it)
        handles[i] = nil;
      end;
      i = i + 1;
    end;
  end;
end;

if emu.registerexit then
  emu.registerexit(emu.iuplua);
end


--Set up the list of registered gui functions
gui_registered_funcs = {}
all_ordered_registered_funcs = {}
local function register_func(fname, f)
  table.insert(all_ordered_registered_funcs, fname)
  gui_registered_funcs[fname] = f
end;

--Draw a pixel that just copies the one it replaces to refresh screen.
--local function refreshScreen()
--  color = emu.getscreenpixel(0, 0)
--  gui.setpixel(0, 0, color)
--end;

--Add all the functions. They will be ordered this way.
--[[
register_func("showEnemyHp", showEnemyHp)
register_func("displayGlobalCounter", displayGlobalCounter)
register_func("displayRandSeed", displayRandSeed)
register_func("displaySwordCounter", displaySwordCounter)
register_func("displaySwordChargeCounter", displaySwordChargeCounter)
register_func("displayFastDiagonalIndicator", displayFastDiagonalIndicator)
register_func("showPotentialSwordHitbox", showPotentialSwordHitbox)
register_func("showPlayerCoords", showPlayerCoords)
register_func("displayRelCoords", displayRelCoords)
register_func("displaySlopeCounter", displaySlopeCounter)
register_func("showEnemyHitbox", showEnemyHitbox)
register_func("showPlayerHitbox", showPlayerHitbox)
register_func("showActualSwordHitbox", showActualSwordHitbox)
register_func("showShotHitbox", showShotHitbox)
register_func("refreshScreen", refreshScreen)
--]]

--The actual registered function calls all non-nil items in the registration table.

if gui.register then
  gui.register( function()
    for i,fname in ipairs(all_ordered_registered_funcs) do
      f = gui_registered_funcs[fname]
      --can set value to nil to  turn off
      if f then f() end;
    end;
  end)
end

---------------------




--[[
--To toggle a feature, swap function pointer into a disabled function table.
disabled_funcs = {}
local function toggleFeature(fname)
  disabled_funcs[fname], gui_registered_funcs[fname] = 
              gui_registered_funcs[fname], disabled_funcs[fname]
end;

--Disable all the features
for i,fname in ipairs(all_ordered_registered_funcs) do
  toggleFeature(fname)
end;
--]]

--Always refresh screen
--toggleFeature("refreshScreen")

--[[
featureItems = {}
local function makeFeatureItem(title, fname)
  item = iup.item{
               title=title,
               value="OFF",
               fname=fname,
               action=function(self) 
                       toggleFeature(self.fname) 
                       toggleMenuItem(self)
               end}
  featureItems[fname] = item
  return item
end;
--]]

--[[
local function showAllFeatures(showNotHide)
  for i,fname in ipairs(all_ordered_registered_funcs) do
    if fname ~= "refreshScreen" then
      if (showNotHide and gui_registered_funcs[fname] == nil) or
         (not showNotHide and gui_registered_funcs[fname] ~= nil) then
        toggleFeature(fname)
        toggleMenuItem(featureItems[fname])
      end
    end
  end
end;
]]--


--[[
local showTricksItem = iup.item{
          title = "Stuff",
          value="ON",
          action = function(self)
                  showTricks = not showTricks
                  toggleMenuItem(self)
          end}
--]]


local mainMenu=iup.menu{
    iup.submenu{
      iup.menu{
        --makeFeatureItem("Player Coords", "showPlayerCoords"),
      --[[
        makeFeatureItem("Player Screen-Relative Coords", "displayRelCoords"),
        makeFeatureItem("Player Hitbox", "showPlayerHitbox"),
        makeFeatureItem("Actual Sword Hitbox", "showActualSwordHitbox"),
        makeFeatureItem("Potential Sword Hitboxes", "showPotentialSwordHitbox"),
        makeFeatureItem("Enemy Hp", "showEnemyHp"),
        makeFeatureItem("Enemy Hitbox", "showEnemyHitbox"),
        makeFeatureItem("Global Counter", "displayGlobalCounter"),
        makeFeatureItem("RNG Seed", "displayRandSeed"),
        makeFeatureItem("Slope Counter", "displaySlopeCounter"),
        makeFeatureItem("Sword Counter", "displaySwordCounter"),
        makeFeatureItem("Sword Charge Counter", "displaySwordChargeCounter"),
        makeFeatureItem("Sword Shot Hitbox", "showShotHitbox"),
        makeFeatureItem("Fast Diagonal Indicator", "displayFastDiagonalIndicator"),
      ]]--
        --iup.item{
        --  title = "Show All",
        --  action = function(self)
        --          showAllFeatures(true)
      --		  if showTricks then
       --                   showTricks = not showTricks
       --                   toggleMenuItem(showTricksItem)
     -- 		  end;
    --  	  end
    --     },
       -- iup.item{
       --   title = "Hide All",
       --   action = function(self)
       --          showAllFeatures(false)
       --  end}

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
            require("wx")
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

local function onPick1()
  local filePath = gui.filepicker("Please select a movie", "pxm");
  txtMovie.value = filePath;
end

local function onPick2()
  local filePath = gui.filepicker("Please select a workflow", "*");
  txtWorkflow.value = filePath;
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

--[[

local function getTimestamp()
  frames = emu.framecount()
  minutes = math.floor(frames / 3600)
  seconds = math.floor( (frames-minutes*3600) / 60)
  if seconds < 10 then seconds = "0" .. seconds.z end;
  return frames .. " (" .. minutes ..":"..seconds .. ")"
end;

local function addNote(text)
  maintext.value = maintext.value .. getTimestamp().."  "..text.."\n\n"
  maintext.caretpos = string.len(maintext.value)
end;

]]--


--[[
processedEvents = {}
local function processEvents()
  framecount = emu.framecount()
  eventIndex = eventTimes[framecount]
  if eventIndex ~= nil then
    if processedEvents[eventIndex] == nil then
      --Process an event for the first time. If it has already 
      --been processed the else branch runs.
      event = eventList[ eventTimes[framecount] ]
      if event.msg ~= nil then
        event.caretpos = maintext.caretpos
        addNote(event.msg)
        event.aftercaretpos = maintext.caretpos
        processedEvents[eventIndex] = event
      end
      event.state = savestate.create()
      savestate.save(event.state)
      if showTricks and event.showtrick ~= nil then event.showtrick() end;
      if turboOnGrind and event.turboOnGrind ~= nil then
        if event.turboOnGrind then emu.speedmode("turbo") else emu.speedmode("normal") end;
      end;
    else
      --Event has already happened and user used rewind or loaded a savestate.
      --Scroll the text box to it.
      --iup.Message('debug', "event index is "..eventIndex)
      event = processedEvents[eventIndex]
      maintext.caretpos = event.caretpos
      maintext.caretpos = event.aftercaretpos
      if showTricks and event.showtrick ~= nil then event.showtrick() end;
      if turboOnGrind and event.turboOnGrind ~= nil then
        if event.turboOnGrind then emu.speedmode("turbo") else emu.speedmode("normal") end;
      end;
    end;
  end;
end;
]]--



local function loopFunction()
  --if enableRewind then
  --  frameAdvanceWithRewind()
  --else


    emu.frameadvance()



  --end;
  --processEvents()
end;



local function onPauseButton()
    --pauseWithRewind()
    --processEvents()

  local coPause = coroutine.create(
  function (x)
    emu.pause();
    coroutine.yield()
  end)
  coroutine.resume(coPause)
end;

local function onUnpauseButton()
  local coUnpause = coroutine.create(
  function (x)
    emu.unpause();
    coroutine.yield()
  end)
  coroutine.resume(coUnpause)
end;

local function onUpdateData()
  --[[
  prevEventIndex = getPreviousEventIndex()
  while prevEventIndex > 0 do
    --Get the latest event with text that has been processed
    event = eventList[prevEventIndex]
    if event.msg ~= nil and processedEvents[prevEventIndex] then
      savestate.load(event.state)
      maintext.caretpos = event.caretpos
      maintext.caretpos = event.aftercaretpos
      return
    end;
    prevEventIndex = prevEventIndex - 1
  end;  
  iup.Message('Beginning', "This is as far back as you can go")
  ]]--
  iup.Message("title","test")
end;

local function onRefreshScreen()
  --[[
  nextEventIndex = getNextEventIndex()
  while nextEventIndex <= #eventList do
    --Get the next event with text that has been processed
    event = eventList[nextEventIndex]
    if event.msg ~= nil and processedEvents[nextEventIndex] then
      savestate.load(event.state)
      maintext.caretpos = event.caretpos
      maintext.caretpos = event.aftercaretpos
      return
    end;
    nextEventIndex = nextEventIndex + 1
  end;
  iup.Message('The End', "This is as far forward as you can go")
  --]]
  print("Refreshing the screen");
  pcsx.redrawscreen();
end;

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

--iup.Message("Hey", "hi")

--The main loop


--while (true) do
--  loopFunction()
--end;

if #emu~=0 then
  --iup.MainLoop()
else
  iup.MainLoop()
end

