--- The Joypad Library
-- @module joypad

if _G.joypad then
  return joypad;
end

local joypad={};

---Returns a table of only the game buttons that are not currently held.
-- Each entry is nil if that button is currently held 
-- (as of the last time the emulation checked), or false if it is not held.
function joypad.write() end
---Returns a table of only the game buttons that are not currently held.
-- Each entry is nil if that button is currently held 
-- (as of the last time the emulation checked), or false if it is not held.
function joypad.set() end

---Returns a table of only the game buttons that are currently held.
-- Each entry is true if that button is currently held
-- (as of the last time the emulation checked), or nil if it is not held.
function joypad.getdown() end
---Returns a table of only the game buttons that are currently held.
-- Each entry is true if that button is currently held
-- (as of the last time the emulation checked), or nil if it is not held.
function joypad.readdown() end

---Returns a table of only the game buttons that are not currently held.
-- Each entry is nil if that button is currently held
-- (as of the last time the emulation checked), or false if it is not held.
function joypad.getup() end
---Returns a table of only the game buttons that are not currently held.
-- Each entry is nil if that button is currently held
-- (as of the last time the emulation checked), or false if it is not held.
function joypad.readup() end

--- Reads the joypads analog as inputted by the user
-- @return #table
function joypad.getanalog() end

--- Set the joypads analog for controller 1 or controller 2
function joypad.setanalog() end

--- Returns a table of every game button, where each entry is true if that button is currently held
--  (as of the last time the emulation checked), or false if it is not held.
--  This takes keyboard inputs, not Lua. The table keys look like this (case sensitive):
--  up, down, left, right, start, select, etc...
--  Where a Lua truthvalue true means that the button is set, false means the button is unset.
--  Note that only "false" and "nil" are considered a false value by Lua.
--  Anything else is true, even the number 0.
-- @param #number player
function joypad.get(player) end
--- Returns a table of every game button, where each entry is true if that button is currently held
--  (as of the last time the emulation checked), or false if it is not held.
--  This takes keyboard inputs, not Lua. The table keys look like this (case sensitive):
--  up, down, left, right, start, select, etc...
--  Where a Lua truthvalue true means that the button is set, false means the button is unset.
--  Note that only "false" and "nil" are considered a false value by Lua.
--  Anything else is true, even the number 0.
-- @param #number player
function joypad.read(player) end

return joypad;