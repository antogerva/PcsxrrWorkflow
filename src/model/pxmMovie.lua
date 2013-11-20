--- PxmMovie
-- @module pxmMovie

local M={};

---
-- @type pxmMovieInstance
-- @field [parent=#pxmMovieInstance] #string moviePath, the full path
-- @field [parent=#pxmMovieInstance] #string movieName, the movie name
-- @field [parent=#pxmMovieInstance] #number movieLength, the length in frame
local D={moviePath="",movieName="",movieLength=""};

---Create new pxmMovie
--@function [parent=#pxmMovie] new
--@return #pxmMovieInstance description
function M.new(moviePath,movieName,movieLength)
  local newMovie = {movieName=movieName,movieLength=movieLength};  
  if newMovie.movieName==nil then
    if movie.mode() ~= nil then --if the movie is loaded we can load the movie info from it.
      newMovie.movieName = movieName:match("[^\\]*$");
      newMovie.movieLength = movie.length;
    elseif moviePath~=nil then
      newMovie.movieName = moviePath:match("[^\\]*.pxm$");            
    end
  end
  -- set to new rectangle the properties of a rectangle
  setmetatable(newMovie, {__index = D})
  return newMovie;  
end

return M;

  --[[
	local self = {
		--- A movie 
		-- @type movie
		-- @field [parent=#movie] #string moviePath 
		moviePath = "";
		-- @field [parent=#movie] #string tasSpuPath 
		tasSpuPath = "";
		-- @field [parent=#movie] #string eternalSpuPath 
		eternalSpuPath = "";
		-- @field [parent=#movie] #string workflowPath 
		workflowPath = "";
		-- @field [parent=#movie] #string luaScriptPath 
		luaScriptPath = "";
		-- @field [parent=#movie] #string kkapturePath 
		kkapturePath = "";
	}
  return {moviePath=moviePath
    ,tasSpuPath=tasSpuPath
    ,eternalSpuPath=eternalSpuPath
    ,workflowPath=workflowPath
    ,luaScriptPath=luaScriptPath
    ,kkapturePath=kkapturePath
  } 
	--]]


