--- Functions for getting that should be non-game-controller user input are in the Input Library.
--@module input

if _G.input then
  return input;
end

local input={};

--- Returns a table of which keyboard buttons are pressed as well as mouse status.
--  Key values for keyboard buttons and mouse clicks are true for pressed, nil for not pressed.
--  Mouse position is returned in terms of game screen pixel coordinates.
--  Coordinates assume that the game screen is 256 by 224. Keys
--  for mouse are (xmouse, ymouse, leftclick, rightclick, middleclick).
--  Keys for keyboard buttons: (backspace, tab, enter, shift, control, alt, pause, capslock,
--  escape, space, pageup, pagedown, end, home, left, up, right, down, insert, delete,
--  0, 1, ..., 9, A, B, ..., Z, numpad0, numpad1, ..., numpad9, numpad*, numpad+, numpad-, numpad., numpad/,
--  F1, F2, ..., F24, numlock, scrolllock, semicolon, plus, comma, minus, period, slash, tilde, leftbracket,
--  backslash, rightbracket, quote)
--  Keys are case-sensitive. Keys for keyboard buttons are for buttons, not ASCII characters, so there is
--  no need to hold down shift. Key names may differ depending on keyboard layout.
--  On US keyboard layouts, "slash" is /?, "tilde" is `~, "leftbracket" is [{, "backslash" is \|,
--  "rightbracket" is ]}, "quote" is '".
--  @return #table
function input.get() end

--- Returns a table of which keyboard buttons are pressed as well as mouse status.
--  Key values for keyboard buttons and mouse clicks are true for pressed, nil for not pressed.
--  Mouse position is returned in terms of game screen pixel coordinates.
--  Coordinates assume that the game screen is 256 by 224. Keys
--  for mouse are (xmouse, ymouse, leftclick, rightclick, middleclick).
--  Keys for keyboard buttons: (backspace, tab, enter, shift, control, alt, pause, capslock,
--  escape, space, pageup, pagedown, end, home, left, up, right, down, insert, delete,
--  0, 1, ..., 9, A, B, ..., Z, numpad0, numpad1, ..., numpad9, numpad*, numpad+, numpad-, numpad., numpad/,
--  F1, F2, ..., F24, numlock, scrolllock, semicolon, plus, comma, minus, period, slash, tilde, leftbracket,
--  backslash, rightbracket, quote)
--  Keys are case-sensitive. Keys for keyboard buttons are for buttons, not ASCII characters, so there is
--  no need to hold down shift. Key names may differ depending on keyboard layout.
--  On US keyboard layouts, "slash" is /?, "tilde" is `~, "leftbracket" is [{, "backslash" is \|,
--  "rightbracket" is ]}, "quote" is '".
--  @return #table
function input.read() end

---Creates a pop-up dialog box with the given text and some dialog buttons.
-- There are three types: "ok", "yesno", and "yesnocancel".
-- If "yesno" or "yesnocancel", it returns either "yes", "no", or "cancel",
-- depending on the button pressed. If "ok", it returns nil.
-- @usage Usage examples:
-- input.popup(string message, string type = "ok", string icon = "message")
-- input.popup(string message, string type = "yesno", string icon = "question")
-- @return #string
function input.popup() end

---Get the last input polled by pad1 and pad2
-- @return #table
function input.getlastbuttonpolled() end

return input;
                                                       