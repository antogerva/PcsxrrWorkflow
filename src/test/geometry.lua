--- A module that allow to manage geometry shapes
-- @module geometry
local M = {}
 
--- A rectangle 
-- @type rectangle
-- @field [parent=#rectangle] #number x horizontal position, 0 by default
-- @field [parent=#rectangle] #number y vertical position, 0 by default
-- @field [parent=#rectangle] #number width, 100 by default
-- @field [parent=#rectangle] #number height, 100 by default
local R = {x=0, y=0, width=100, height=100, }
 
--- Move the rectangle
-- @function [parent=#rectangle] move
-- @param #rectangle self
-- @param #number x
-- @param #number y
function R.move(self,x,y)
  self.x = self.x + x
  self.y = self.y + y
end
 
--- Create a new rectangle
-- @function [parent=#geometry] newRectangle
-- @param #number x
-- @param #number y
-- @param #number width
-- @param #number height
-- @return #rectangle the created rectangle
function M.newRectangle(x,y,width,height)
  local newrectangle = {x=x,y=y,width=width,height=height}
 
  -- set to new rectangle the properties of a rectangle
  setmetatable(newrectangle, {__index = R})
  return newrectangle
end
 
return M


