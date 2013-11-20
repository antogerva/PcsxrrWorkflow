--- The Memory Library
-- Note: Word=2 bytes, Dword=4 bytes.
-- @module memory

if _G.memory then
  return memory;
end
local memory={};

---Get a length bytes starting at the given address and return it as a string. Convert to table to access the individual bytes. 
-- Returns a chunk of memory from the given address with the given length as a string. To access, use string.byte(str,offset).
-- @param #number address
-- @param #number length
-- @return #string
function memory.readbyterange(address, length) end

---Reads 1 byte of memory and returns the result as an integer between 0 and 255.
function memory.readbyte() end
---Reads 1 byte of memory and returns the result as an integer between 0 and 255.
function memory.readbyteunsigned() end
---Reads 1 byte of memory and returns the result as an integer between -128 and 127.
-- (0 to 127 stay the same as memory.readbyte would return, but [128 to 255] shifts to [-128 to -1].)
function memory.readbytesigned() end

---Reads 2 bytes of memory and returns the result as an integer between 0 and 65535.
function memory.readword() end
---Reads 2 bytes of memory and returns the result as an integer between 0 and 65535.
function memory.readwordunsigned() end
---Reads 2 bytes of memory and returns the result as an integer between -32768 and 32767.
function memory.readwordsigned() end

---Reads 2 bytes of memory and returns the result as an integer between 0 and 65535.
function memory.readshort() end
---Reads 2 bytes of memory and returns the result as an integer between 0 and 65535.
function memory.readshortunsigned() end
---Reads 2 bytes of memory and returns the result as an integer between -32768 and 32767.
function memory.readshortsigned() end

--- Reads 4 bytes of memory and returns the result as an integer between 0 and 4294967295.
function memory.readdword() end
--- Reads 4 bytes of memory and returns the result as an integer between 0 and 4294967295.
function memory.readdwordsigned() end
--- Reads 4 bytes of memory and returns the result as an integer between -2147483648 and 2147483647.
function memory.readdwordunsigned() end

--- Reads 4 bytes of memory and returns the result as an integer between 0 and 4294967295.
function memory.readlong() end
--- Reads 4 bytes of memory and returns the result as an integer between 0 and 4294967295.
function memory.readlongsigned() end
--- Reads 4 bytes of memory and returns the result as an integer between -2147483648 and 2147483647.
function memory.readlongunsigned() end

--- Writes 1 byte of memory to the given address, placing the lowest byte of the given integer value there.
--  Any attempts to write to ROM will be ignored, however. There is no need for "signed" variations of any
--  of the memory.write functions, since you can use a value that has whatever sign you want.
function memory.writebyte(address, value) end

--- Writes 2 bytes of memory to the given address, placing the lowest 2 bytes of the given integer value there.
--  Any attempts to write to ROM will be ignored, however.
function memory.writeword(address, value) end
--- Writes 2 bytes of memory to the given address, placing the lowest 2 bytes of the given integer value there.
--  Any attempts to write to ROM will be ignored, however.
function memory.writeshort(address, value) end

--- Writes 4 bytes of memory to the given address, placing the lowest 4 bytes of the given integer value there.
--  Any attempts to write to ROM will be ignored, however.
function memory.writelong(address, value) end
--- Writes 4 bytes of memory to the given address, placing the lowest 4 bytes of the given integer value there.
--  Any attempts to write to ROM will be ignored, however.
function memory.writedword(address, value) end

--- Registers a function to be called immediately whenever the given memory address range is written to
--  (either by the emulation or by a memory.write function).
--  size is the number of bytes to "watch". For example, if size is 100 and address is 0xFF0000, then you will
--  register the function across all 100 bytes from 0xFF0000 to 0xFF0063. A write to any of those bytes will
--  trigger the function. Having callbacks on a large range of memory addresses can be expensive, so try to
--  use the smallest range that's necessary for whatever it is you're trying to do. If you don't specify any
--  size then it defaults to 1.
--  The callback function will receive two arguments, (address, size) indicating what write operation triggered
--  the callback. If you don't care about that extra information then you can ignore it and define your callback
--  function to not take any arguments. The value that was written is NOT passed into the callback function,
--  but you can easily use any of the memory.read functions to retrieve it.
--  You may use a memory.write function from inside the callback to change the value that just got written. However,
--  keep in mind that doing so will trigger your callback again, so you must have a "base case" such as checking to
--  make sure that the value is not already what you want it to be before writing it. Another, more drastic option
--  is to de-register the current callback before performing the write.
--  If func is nil that means to de-register any memory write callbacks that the current script has already registered
--  on the given range of bytes.
--  Normally you won't need to provide the cpuname argument. It defaults to "main" which indicates the main68k's view
--  of memory. You can specify "sub" or "s68k" to refer to the sub68k's address space, but keep in mind that support
--  for this elsewhere in the memory library is currently limited or nonexistent so it will be difficult to accomplish
--  much using the sub68k view.
--  A single memory operation will trigger no more than one registered memory callback per script. For example, if a
--  game writes 4 bytes with a single assembly instruction and you have a callback on more than one of those bytes,
--  only the one on the lowest address will be called. Usually this won't be a problem.
function memory.register() end
--- Registers a function to be called immediately whenever the given memory address range is written to
--  (either by the emulation or by a memory.write function).
--  size is the number of bytes to "watch". For example, if size is 100 and address is 0xFF0000, then you will
--  register the function across all 100 bytes from 0xFF0000 to 0xFF0063. A write to any of those bytes will
--  trigger the function. Having callbacks on a large range of memory addresses can be expensive, so try to
--  use the smallest range that's necessary for whatever it is you're trying to do. If you don't specify any
--  size then it defaults to 1.
--  The callback function will receive two arguments, (address, size) indicating what write operation triggered
--  the callback. If you don't care about that extra information then you can ignore it and define your callback
--  function to not take any arguments. The value that was written is NOT passed into the callback function,
--  but you can easily use any of the memory.read functions to retrieve it.
--  You may use a memory.write function from inside the callback to change the value that just got written. However,
--  keep in mind that doing so will trigger your callback again, so you must have a "base case" such as checking to
--  make sure that the value is not already what you want it to be before writing it. Another, more drastic option
--  is to de-register the current callback before performing the write.
--  If func is nil that means to de-register any memory write callbacks that the current script has already registered
--  on the given range of bytes.
--  Normally you won't need to provide the cpuname argument. It defaults to "main" which indicates the main68k's view
--  of memory. You can specify "sub" or "s68k" to refer to the sub68k's address space, but keep in mind that support
--  for this elsewhere in the memory library is currently limited or nonexistent so it will be difficult to accomplish
--  much using the sub68k view.
--  A single memory operation will trigger no more than one registered memory callback per script. For example, if a
--  game writes 4 bytes with a single assembly instruction and you have a callback on more than one of those bytes,
--  only the one on the lowest address will be called. Usually this won't be a problem.
function memory.registerwrite() end

return memory;                                             
                                             