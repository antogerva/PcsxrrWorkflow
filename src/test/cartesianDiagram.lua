--- A Cartesian Diagram
--@module cartesianDiagram

local geometry=require("geometry");

M={}

--- A Cartesian Diagram Instance
-- @type cartesianDiagramInstance
-- @field [parent=#cartesianDiagramInstance] #number row, 0 by default
-- @field [parent=#cartesianDiagramInstance] #number column, 0 by default
-- @field [parent=#cartesianDiagramInstance] @{geometry#(rectangle)} rect, minimal rectangle by default
local C={row=0,column=0,rect=geometry.newRectangle(0,0,0,0)}

--- Create a new cartesianDiagram with a specfic number of row and column for each quadrants 
-- @function [parent=#cartesianDiagram] newCartesianDiagram
-- @param #number row
-- @param #number column
-- @param @{geometry#(rectangle)} rect
-- @return #cartesianDiagram the created rectangle
function M.newCartesianDiagram(row, column, rect)
  local newCartesianDiagram = {row=row,column=column, rect=rect}
 
  -- set to new cartesianDiagramInstance properties of a cartesianDiagramInstance
  setmetatable(newCartesianDiagram, {__index = C})
  return newCartesianDiagram
end


return M;