--- IUP is a portable toolkit for building graphical user interfaces.
--  It offers a configuration API in three basic languages: C, Lua and LED.
--  IUP purpose is to allow a program to be executed in different systems without any modification.
--  @module iup

local iup={}

function iup.Message(title, text) end;

function iup.dialog(table) end;

function iup.menu(table) end;
function iup.submenu(table) end;
function iup.item(table) end;

function iup.vbox(table) end;
function iup.hbox(table) end;

function iup.fill(table) end;
function iup.separator(table) end;

function iup.text(table) end
function iup.button(table) end

--- Creates the File Dialog element.
--  It is a predefined dialog for selecting files or a directory.
--  The dialog can be shown with the IupPopup function only.
function iup.filedlg() end;
function iup:popup() end

--- Executes the user interaction until a callback returns IUP_CLOSE,
--  IupExitLoop is called, or hiding the last visible dialog.
function iup.MainLoop() end;

return iup;

