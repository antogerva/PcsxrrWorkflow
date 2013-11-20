--- The Movie Library
-- @module movie

if _G.movie then
  return movie;
end
local movie={};

--- Start in replay mode a movie from the beggining,
-- once this function is used, use frameadvance to run
-- the movie.
-- @param #string name, name of the movie from the "output/movie" folder
function movie.load(name) end

---Returns the current frame count.
-- (Has the same affect as emu.framecount)
-- @return #number
function movie.framecount() end

---Returns the total number of frames of the current movie.
-- Throws a Lua error if no movie is loaded.
function movie.length() end

---Returns the filename of the current movie with path.
-- Throws a Lua error if no movie is loaded.
function movie.name() end

--- Returns "record" if movie is recording, "playback" if movie is replaying input, or nil if there is no movie.
-- return #string
function movie.mode() end

--- Returns true if there is a movie loaded and in play mode.
-- @return #boolean
function movie.playing() end

---Returns true if a movie is currently loaded and false otherwise. 
-- (This should be used to guard against Lua errors when attempting to retrieve movie information).
-- @return #boolean
function movie.active() end

---Stops movie playback.
-- If no movie is loaded, it throws a Lua error.
function movie.stop() end
---Stops movie playback.
-- If no movie is loaded, it throws a Lua error.
function movie.close() end

---Returns true if there is a movie loaded and in record mode.
-- @return #boolean
function movie.recording() end

---Returns the rerecord count of the current movie.
-- Throws a Lua error if no movie is loaded.
-- @return #number
function movie.rerecordcount() end

---Turn the rerecord counter on or off.
-- Allows you to do some brute forcing without inflating the rerecord count.
-- @param #boolean counting
function movie.recordcounting(counting) end

---Set a new rerecord count for the movie.
function movie.setrerecordcount(count) end

return movie;

