---From LuaBitOp (release 1.0.1)
-- @module bit

if _G.bit then
  return bit;
end

local bit={};

---normalize number to the numeric range of 
-- bit operations (all bit ops use this implicitly)
function bit.tobit(x) end

---convert x to hex with n digits (default 8)
--bit.tohex(x[,n])
function bit.tohex() end

---bitwise not of x
function bit.bnot(x) end

---bitwise and of x1, x2, ...
--bit.band(x1[,x2...])
function bit.band() end

---bitwise or of x1, x2, ...
--bit.bor(x1[,x2...]) 
function bit.bor() end

---bitwise xor of x1, x2, ...
--bit.bxor(x1[,x2...])
function bit.bxor() end

---left-shift of x by n bits
function bit.lshift(x, n) end

---logical right-shift of x by n bits
function bit.rshift(x, n) end

---arithmetic right-shift of x by n bits
function bit.arshift(x, n) end

---left-rotate of x by n bits
function bit.rol(x, n) end

---right-rotate of x by n bits
function bit.ror(x, n) end

---byte-swap of x (little-endian <-> big-endian)
function bit.bswap(x) end

return bit;