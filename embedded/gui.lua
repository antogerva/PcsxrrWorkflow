---The gui Library
-- Functions mainly for drawing on the screen are in the gui library.
-- @module gui

if _G.gui then
  return _G.gui;
end
local gui={};

--- Register a function to be called between a frame being prepared for displaying
--  on your screen and it actually happening. Used when that 1 frame delay for
--  rendering is not acceptable.
function gui.register(func) end

---Make a hash string from the screen buffer
-- @return #string
function gui.hashframe() end

---Returns a screen shot as a string in gd's v1 file format.
-- This allows us to make screen shots available without gd installed locally.
-- Users can also just grab pixels via substring selection.
-- example: gd.createFromGdStr(gui.gdscreenshot()):png("outputimage.png")
-- @return #string
function gui.gdscreenshot() end

---Scales the transparency of subsequent draw calls.
-- An alpha of 0.0 means completely transparent, and
-- an alpha of 1.0 means completely unchanged (opaque).
-- Non-integer values are supported and meaningful,
-- as are values greater than 1.0. It is not necessary to use
-- this function (or the less-recommended gui.transparency) to
-- perform drawing with transparency, because you can provide
-- an alpha value in the color argument of each draw call.
-- However, it can sometimes be convenient to be able to globally
-- modify the drawing transparency.
-- @param #number alpha
function gui.opacity(alpha) end

---Scales the transparency of subsequent draw calls. Exactly the
-- same as gui.opacity, except the range is different: A trans of
-- 4.0 means completely transparent, and a trans of 0.0 means
-- completely unchanged (opaque).
function gui.transparency(trans) end

---Draws an image on the screen. gdimage must be in truecolor gd string format.
-- Transparency is fully supported. Also, if alphamul is specified then it will
-- modulate the transparency of the image even if it's originally fully opaque.
-- (alphamul=1.0 is normal, alphamul=0.5 is doubly transparent, alphamul=3.0 is
-- triply opaque, etc.)
-- dx,dy determines the top-left corner of where the image should draw.
-- If they are omitted, the image will draw starting at the top-left corner
-- of the screen.
-- gui.gdoverlay is an actual drawing function (like gui.box and friends)
-- and thus must be called every frame, preferably inside a gui.register'd function,
-- if you want it to appear as a persistent image onscreen.
-- Here is an example that loads a PNG from file, converts it to gd string format,
-- and draws it once on the screen:
-- local gdstr = gd.createFromPng("myimage.png"):gdStr()
-- gui.gdoverlay(gdstr) 
function gui.gdoverlay() end

---Draws an image on the screen. gdimage must be in truecolor gd string format.
-- Transparency is fully supported. Also, if alphamul is specified then it will
-- modulate the transparency of the image even if it's originally fully opaque.
-- (alphamul=1.0 is normal, alphamul=0.5 is doubly transparent, alphamul=3.0 is
-- triply opaque, etc.)
function gui.image() end
---Draws an image on the screen. gdimage must be in truecolor gd string format.
-- Transparency is fully supported. Also, if alphamul is specified then it will
-- modulate the transparency of the image even if it's originally fully opaque.
-- (alphamul=1.0 is normal, alphamul=0.5 is doubly transparent, alphamul=3.0 is
-- triply opaque, etc.)
function gui.drawimage() end

---Draws a given string at the given position. textcolor and backcolor are optional.
-- See 'on colors' at the end of this page for information. Using nil as the input or
-- not including an optional field will make it use the default.
function gui.text() end

---Draws a given string at the given position. textcolor and backcolor are optional.
-- See 'on colors' at the end of this page for information. Using nil as the input or
-- not including an optional field will make it use the default.
function gui.drawtext() end

--- Returns the separate RGBA components of the given pixel set by gui.pixel.
--  This only gets LUA pixels set, not background colors.
function gui.getpixel() end
--- Returns the separate RGBA components of the given pixel set by gui.pixel.
--  This only gets LUA pixels set, not background colors.
function gui.readpixel() end

---Draw one pixel of a given color at the given position on the screen.
-- See drawing notes and color notes at the bottom of the page. 
function gui.pixel() end
---Draw one pixel of a given color at the given position on the screen.
-- See drawing notes and color notes at the bottom of the page. 
function gui.setpixel() end
---Draw one pixel of a given color at the given position on the screen.
-- See drawing notes and color notes at the bottom of the page. 
function gui.drawpixel() end
---Draw one pixel of a given color at the given position on the screen.
-- See drawing notes and color notes at the bottom of the page. 
function gui.writepixel() end

---Draws a line between the two points. The x1,y1 coordinate specifies one end of
-- the line segment, and the x2,y2 coordinate specifies the other end. If skipfirst
-- is true then this function will not draw anything at the pixel x1,y1, otherwise
-- it will. skipfirst is optional and defaults to false. The default color for the
-- line is solid white, but you may optionally override that using a color of your
-- choice. See also drawing notes and color notes at the bottom of the page.
function gui.line() end
---Draws a line between the two points. The x1,y1 coordinate specifies one end of
-- the line segment, and the x2,y2 coordinate specifies the other end. If skipfirst
-- is true then this function will not draw anything at the pixel x1,y1, otherwise
-- it will. skipfirst is optional and defaults to false. The default color for the
-- line is solid white, but you may optionally override that using a color of your
-- choice. See also drawing notes and color notes at the bottom of the page.
function gui.drawline() end

---Draws a given string at the given position. textcolor and backcolor are optional.
-- See 'on colors' at the end of this page for information. Using nil as the input
-- or not including an optional field will make it use the default.
function gui.box() end
---Draws a given string at the given position. textcolor and backcolor are optional.
-- See 'on colors' at the end of this page for information. Using nil as the input
-- or not including an optional field will make it use the default.
function gui.drawbox() end
---Draws a given string at the given position. textcolor and backcolor are optional.
-- See 'on colors' at the end of this page for information. Using nil as the input
-- or not including an optional field will make it use the default.
function gui.rect() end
---Draws a given string at the given position. textcolor and backcolor are optional.
-- See 'on colors' at the end of this page for information. Using nil as the input
-- or not including an optional field will make it use the default.
function gui.drawrect() end

---Returns the separate RGBA components of the given color.
-- For example, you can say local r,g,b,a = gui.parsecolor('orange') to retrieve the
-- red/green/blue values of the preset color orange.
-- (You could also omit the a in cases like this.) This uses the same conversion method
-- that FCEUX uses internally to support the different representations of colors that
-- the GUI library uses. Overriding this function will not change how FCEUX interprets
-- color values, however.
function gui.parsecolor() end

--- Undoes uncommitted drawing commands.
function gui.clearuncommitted() end

---Creates a pop-up dialog box with the given text and some dialog buttons.
-- There are three types: "ok", "yesno", and "yesnocancel".
-- If "yesno" or "yesnocancel", it returns either "yes", "no", or "cancel",
-- depending on the button pressed. If "ok", it returns nil.
-- @usage Usage examples:
-- gui.popup(string message, string type = "ok", string icon = "message")
-- gui.popup(string message, string type = "yesno", string icon = "question")
-- @return #string
function gui.popup(message,type,icon) end

--- Popup a file browser, where the user can select a file.
-- @return #string
function gui.filepicker(title, filter) end

return gui;
