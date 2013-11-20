---The Savestate Library
-- @module savestate

if _G.savestate then
  return savestate;
end
local savestate={};
--- Savestate.create is identical to savestate.object, except for the numbering for
--  predefined slots(1-10, 1 refers to slot 0, 2-10 refer to 1-9). It's being left
--  in for compatibility with older scripts, and potentially for platforms with
--  different internal predefined slot numbering.
function savestate.create(slot) end

---Save the current state object to the given savestate.
-- The argument is the result of savestate.create().
-- You can load this state back up by calling savestate.load(savestate) on the same object.
function savestate.save(savestate) end

---Load the the given state.
-- The argument is the result of savestate.create() and
-- has been passed to savestate.save() at least once.
function savestate.load(savestate) end

--- Save a savestate to a specific localtion.
-- @param #string filename
function savestate.savefile(filename) end

--- Load a savestate from a specific localtion.
--  @param #string filename
function savestate.loadfile(filename) end

return savestate;



                                                     
