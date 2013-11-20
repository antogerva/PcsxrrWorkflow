--package.cpath = ";?51.dll;./src/?.dll;/.src/?.lua;./dll/?.dll;./?.dll;../lua/?.dll;" ..package.cpath
package.cpath = [[C:\Users\antogerva\Downloads\__koneki_1.1_M2__org.eclipse.koneki.ldt-1.1_M2\1_1M2_x86_64\workspace\PcsxrrWorkflow\src\?.dll]] ..package.cpath
package.cpath = [[C:\Users\antogerva\Downloads\__koneki_1.1_M2__org.eclipse.koneki.ldt-1.1_M2\1_1M2_x86_64\workspace\PcsxrrWorkflow\src\?51.dll]] ..package.cpath

print("gd!!!")
 -- iuplua_open = package.loadlib("iuplua51.dll", "iuplua_open");
  --if(iuplua_open == nil) then require("libiuplua51"); end

 -- iuplua_open();

function AddPostfixToPackagePath(postfix)
        print("add postfix")
        local function split(str, sep)
                local sep, fields = sep or ":", {}
                local pattern = string.format("([^%s]+)", sep)
                str:gsub(pattern, function(c) fields[#fields+1] = c end)
                return fields
        end
        local function endsWith(str, pat)
                if #str < #pat then
                        return false
                end
                return str:sub(-#pat) == pat
        end

        local additionalpath = ""
        for i, v in ipairs(split(package.cpath, ";")) do
                local newpath = nil
                if endsWith(v, "?.dll") then
                        newpath = v:gsub("%?.dll", "") .. "?" .. postfix .. ".dll"
                elseif endsWith(v, "?.so") then
                        newpath = v:gsub("%?.so", "") .. "?" .. postfix .. ".so"
                end
                if newpath then
                        local duplicated = false
                        for i2, v2 in ipairs(split(package.cpath, ";")) do
                                if v2 == newpath then
                                        duplicated = true
                                        break
                                end
                        end
                        if not duplicated then
                                additionalpath = additionalpath .. ";" .. newpath
                        end
                end
        end
        package.cpath = package.cpath .. additionalpath
end
AddPostfixToPackagePath("51")

require("iuplua")
 --local dlg = iup.dialog{ size="400x200"};
 --dlg:show()

  
iup.Message("","lol")

  
  print("alright")
  
  