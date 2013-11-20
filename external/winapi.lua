---
-- @module winapi

local winapi={}

---find a window based on classname and caption
function winapi.find_window(cname, wname) end
---makes a function that matches against window text
function winapi.make_name_matcher(text) end
---makes a function that matches against window class name
function winapi.make_class_matcher(text) end
---find a window using a condition function.
function winapi.find_window_ex(match) end
---return all windows matching a condition.
function winapi.find_all_windows(match) end
---find a window matching the given text.
function winapi.find_window_match(text) end
---current foreground window.
function winapi.get_foreground_window() end
---the desktop window.
function winapi.get_desktop_window() end
---enumerate over all top-level windows.
function winapi.enum_windows(callback) end
---route callback dispatch through a message window.
function winapi.use_gui() end
---send a string or virtual key to the active window.
function winapi.send_to_window(text) end
---tile a group of windows.
function winapi.tile_windows(parent, horiz, kids, bounds) end


---sleep and use no processing time.
function winapi.sleep(millisec) end
---show a message box.
function winapi.show_message(caption, msg, btns, icon) end
---make a beep sound.
-- @param #string type one of 'information','question','warning','error', 'ok' by default
function winapi.beep(type) end
---copy a file.
function winapi.copy_file(src, dest, fail_if_exists) end
---output text to the system debugger.
function winapi.output_debug_string(str) end
---move a file.
function winapi.move_file(src, dest) end
---execute a shell command.
function winapi.shell_exec(verb, file, parms, dir, show) end
---copy text onto the clipboard.
function winapi.set_clipboard(text) end
---get the text on the clipboard.
function winapi.get_clipboard() end
---open console i/o.
function winapi.get_console() end
---open a serial port for reading and writing.
function winapi.open_serial(defn) end


---set an environment variable for any child processes.
function winapi.setenv(name, value) end
---Spawn a process.
function winapi.spawn_process(program, dir) end
---execute a system command.
function winapi.execute(cmd, unicode) end
---launch a function in a new thread.
function winapi.thread(fun, data) end


---the short path name of a directory or file.
function winapi.short_path(path) end
---get a temporary filename.
function winapi.temp_name() end
---delete a file or directory.
function winapi.delete_file_or_dir(file) end
---make a directory.
function winapi.make_dir() end
---iterator over directory contents.
function winapi.files(mask, subdirs, attrib) end
---iterate over subdirectories
function winapi.dirs(file, subdirs) end
---remove a directory.
function winapi.remove_dir(dir, tree) end


---Open a registry key
function winapi.open_reg_key(path, writeable) end
---Create a registry key.
function winapi.create_reg_key(path) end

return winapi;