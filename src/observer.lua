--- Observer
-- @module observer
local M = {}

--- Register Add the observer
-- @function [parent=#observer] register
function M.register( self, observer, method )
  local t = {}
  t.o = observer
  t.m = method
  table.insert( self, t )
end

--- Deregister Remove the observer
-- @function [parent=#observer] deregister
function M.deregister( self, observer, method )
  local i
  local n = #self
  for i = n, 1, -1 do
    if (not observer or self[i].o == observer) and
       (not method   or self[i].m == method)
    then
      table.remove( self, i )
    end
  end
end

--- Notify Will notify the registred observer
-- @function [parent=#observer] notify
function M.notify( self, ... )
  local i
  local n = #self
  for i = 1, n do
    self[i].m( self[i].o, ... )
  end
end

-- signal metatable
local mt = {
  __call = function( self, ... )
    self:notify(...)
  end
}

--- Signal Say the value has changed
-- @function [parent=#observer] signal
function M.signal()
  local t = {}
  t.register = M.register
  t.deregister = M.deregister
  t.notify = M.notify
  setmetatable( t, mt )
  return t
end

return M;