--- The following functions are available in PCSXRR, in addition to standard LUA capabilities.
--@module emu

if _G.emu or _G.pcsx then
  _G.emu=_G.pcsx;
  return emu;
end

local emu={};

--- Pauses script until a frame is emulated. Cannot be called by a coroutine or registered function.
-- Advance the emulator by one frame. It's like pressing the frame advance button once.
-- Most scripts use this function in their main game loop to advance frames.
-- Note that you can also register functions by various methods that run "dead",
-- returning control to the emulator and letting the emulator advance the frame.
-- For most people, using frame advance in an endless while loop is easier to comprehend
-- so I suggest  starting with that.  This makes more sense when creating bots. Once you
-- move to creating auxillary libraries, try the register() methods.
function emu.frameadvance() end

--- Returns the frame count for the movie, or the number of frames from last reset otherwise.
-- @return #number
function emu.framecount() end

--- Returns true if the current frame is a lag frame, false otherwise.
-- @return #boolean
function emu.lagged() end

--- Returns the number of lag frames encountered.
--  Lag frames are frames where the game did not poll for input because it missed the vblank.
--  This happens when it has to compute too much within the frame boundary.
--  This returns the number indicated on the lag counter.
-- @return #number
function emu.lagcount() end

--- Changes the speed of emulation depending on mode.
--  If "normal", emulator runs at normal speed.
--  If "nothrottle", emulator runs at max speed without frameskip.
--  If "turbo", emulator drops some frames.
--  If "maximum", screen rendering is disabled.
function emu.speedmode() end

--- Suspend the frame processing for a number of cycle
function emu.suspend(cycleToWait) end

---Pauses the emulator.
function emu.pause() end;

---Unpauses the emulator.
-- Note that pcsxrr, you have to call the unpause function inside a coroutine.
function emu.unpause() end

---The emulator go into sleep mode for a number of second
function emu.sleep(second) end;

--- Registers a callback function to run immediately before each frame gets emulated.
--  This runs after the next frame's input is known but before it's used, so this is
--  your only chance to set the next frame's input using the next frame's would-be
--  input. For example, if you want to make a script that filters or modifies ongoing
--  user input, such as making the game think "left" is pressed whenever you press "right",
--  you can do it easily with this.
--  Note that this is not quite the same as code that's placed before a call to emu.frameadvance.
--  This callback runs a little later than that. Also, you cannot safely assume that this will
--  only be called once per frame. Depending on the emulator's options, every frame may be
--  simulated multiple times and your callback will be called once per simulation. If for
--  some reason you need to use this callback to keep track of a stateful linear progression of
--  things across frames then you may need to key your calculations to the results of
--  emu.framecount.
--  Like other callback-registering functions provided by FCEUX, there is only one registered
--  callback at a time per registering function per script. If you register two callbacks,
--  the second one will replace the first, and the call to emu.registerbefore will return
--  the old callback. You may register nil instead of a function to clear a previously-registered
--  callback. If a script returns while it still has registered callbacks, FCEUX will keep it alive
--  to call those callbacks when appropriate, until either the script is stopped by the user or all
--  of the callbacks are de-registered.
function emu.registerbefore(func) end

--- Registers a callback function to run immediately after each frame gets emulated.
--  It runs at a similar time as (and slightly before) gui.register callbacks, except
--  unlike with gui.register it doesn't also get called again whenever the screen gets redrawn.
--  Similar caveats as those mentioned in emu.registerbefore apply.
function emu.registerafter(func) end

--- Registers a callback function that runs when the script stops.
--  Whether the script stops on its own or the user tells it to stop,
--  or even if the script crashes or the user tries to close the emulator,
--  FCEUX will try to run whatever Lua code you put in here first. So if you
--  want to make sure some code runs that cleans up some external resources
--  or saves your progress to a file or just says some last words, you could put it here.
--  (Of course, a forceful termination of the application or a crash from inside the
--  registered exit function will still prevent the code from running.)
--  Suppose you write a script that registers an exit function and then enters an infinite loop.
--  If the user clicks "Stop" your script will be forcefully stopped, but then it will start
--  running its exit function. If your exit function enters an infinite loop too, then the user
--  will have to click "Stop" a second time to really stop your script. That would be annoying.
--  So try to avoid doing too much inside the exit function.
--  Note that restarting a script counts as stopping it and then starting it again,
--  so doing so (either by clicking "Restart" or by editing the script while it is running)
--  will trigger the callback. Note also that returning from a script generally does NOT count
--  as stopping (because your script is still running or waiting to run its callback functions
--  and thus does not stop... see here for more information), even if the exit callback is
--  the only one you have registered.
function emu.registerexit(func) end

--- Return the cdrom label of the game
-- @return #string
function emu.getgamename() end

---Return a table with the config info stored in the windows registry.
-- The following information are added to the table:
-- gpu, spu, bios, cdr, pad1, pad2, net, mcd1, mcd2, oldMcd1, oldMcd2,
-- pluginsDir, lang, xa, sio, mdec, psxauto, PsxType, qkeys, cdda,
-- hle, cpu, psxout, spuirq, usenet, vsyncwa, pauseafterplayback
-- @return #table
function emu.getconfig() end

--- Call the GPU_test function from the GPU API.
-- @return #number
function emu.testgpu() end

--- Call the GPU_makeSnapshot function from the GPU API.
function emu.makesnap() end

--- Call the GPU_updateframe function from the GPU API.
function emu.redrawscreen() end

--- Try to switch the SPU dll.
function emu.switchspu(dllStr) end

--- Displays the message on the screen.
function emu.message(message) end

---Puts a message into the Output Console area of the Lua Script control window.
-- Useful for displaying usage instructions to the user when a script gets run.
function emu.print(str) end;

---Quit the lua script
function emu.quit() end;

return emu;