--- Few utility functions outside of libraries (in the global namespace)
-- @module emuGlobal

if _G.copytable and _G.addressof then
  return _G;
end

local emuGlobal={};

--- Prints any value or values, mainly to help you debug your script.
--  Unlike the default implementation, this can even print the contents of tables.
--  Also, the printed values will go to the script's output window instead of stdout.
--  Note that if you want to print a memory address you should use print(string.format("0x%X",address))
--  instead of print(address).
--  If you want the text to appear on the game screen then this isn't the right
--  function for that (see gui.text or gens.message).
--  print is much slower than gui.text as well, so if you want to show information every frame,
--  then gui.text is the preferred way of doing it.
--  print makes it easy to inspect the state of Lua, for example, you can print the entire table
--  of global variables ( print(_G) ), or you can print a specific library ( print(gens) ) to see all
--  the functions it defines. For an even more complete table than _G you can also
--  try print(debug.getregistry()). If you want the old behavior of printing
--  a table's unique ID instead of its contents, you can print addressof(table).
--  If you want to customize print then you should really look at tostring instead.
function emuGlobal.print() end

---Returns a number shifted by the given number of bits.
-- Negative shift means "shift left" and positive shift means "shift right".
-- Both arguments should be integers, as will be the result, of course.
function emuGlobal.SHIFT(num, shift) end

---Returns the bitwise XOR of all the parameters.
-- Zero or more integer arguments are allowed.
-- Each bit in the result will be 1 if an odd number of the inputs have that bit 1, or 0 otherwise.
function emuGlobal.XOR() end

--- Returns the bitwise AND of all the parameters.
--  Zero or more integer arguments are allowed.
--  Each bit in the result will be 1 if all of the inputs have that bit 1, or 0 otherwise.
function emuGlobal.AND() end

--- Returns the bitwise OR of all the parameters.
--  Zero or more integer arguments are allowed.
--  Each bit in the result will be 1 if any of the inputs have that bit 1, or 0 otherwise.
function emuGlobal.OR() end

--- Returns a number with only the given bit set.
--  There are 32 valid bits, numbered from 0 to 31.
--  Going outside that range will wrap around.
function emuGlobal.BIT(bit) end

---Returns a string that represents the argument.
-- You can use this if you want to get the same string that print would print,
-- but use it for some purpose other than immediate printing. This function is
-- actually what gives print its ability to print tables and other non-string values.
-- Note that there is currently a limit of 65536 characters per result, after which
-- only a "..." is appended, but in typical use you shouldn't ever run into this limit.
-- For advanced Lua users that want to customize how strings are printed:
-- Like any other function in Lua, you may assign your own function in place of tostring
-- to override it, and in this case doing so will change the output of the print function
-- as well. However, this implementation of tostring (and consequently print) will honor
-- the __tostring metamethod, so it's better to use that mechanism instead of overriding
-- the global tostring if you only want to customize how certain things are printed.
function emuGlobal.tostring(arg) end

---Returns a shallow copy of the given table. In other words,
-- it gives you a different table that contains all of the same values as the original.
-- This is unlike simple assignment of a table, which only copies a reference to the original table.
-- You could write a Lua function that does what this function does, but it's such a common operation
-- that it seems worth having a pre-defined function available to do it.
-- @usage For reference, here is a Lua function that should have equivalent behavior:
-- copytable = function(t)
--   if t == nil then return nil end
--   local c = {}
--   for k,v in pairs(t) do
--     c[k] = v
--   end
--   setmetatable(c,debug.getmetatable(t))
--   return c
-- end
-- @return #table
function emuGlobal.copytable(original) end

---Returns the pointer address of a reference-type value.
-- In particular, this can be used on tables and functions to see what their addresses are.
-- There's not much worth doing with a pointer address besides printing it to look at it
-- and see that it's different from the address of something else.
-- Please do not store the address to use for hashing or logical comparison, that is 
-- completely unnecessary in Lua because you can simply use the actual object instead of
-- its address for those purposes.
-- If the argument is not a reference type then this function will return 0.
function emuGlobal.addressof(value) end

---newproxy is an unsupported and undocumented function in the Lua base library.
-- From Lua code, the setmetatable function may only be used on objects of table type.
-- The newproxy function circumvents that limitation by creating a zero-size userdata
-- and setting either a new, empty metatable on it or using the metatable of another newproxy instance.
-- We are then free to modify the metatable from Lua. This is the only way to create a proxy object
-- from Lua which honors certain metamethods, such as __len.
function emuGlobal.newproxy() end

return emuGlobal;
