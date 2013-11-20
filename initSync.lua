
package.path = ";./src/?.lua;/.src/?.lua;./src/controller/?.lua;./dll/?.lua;./?.lua;../lua/?.lua;" ..package.path
package.cpath = ";?51.dll;./?.dll;./src/?.dll;src/?.dll;./dll/?.dll;./?.dll;../lua/?.dll;" ..package.cpath
package.cpath = [[C:\Users\antogerva\Downloads\koneki_git___org.eclipse.koneki.ldt-b1c5f0cc9ec8cf28cc39bcebf2925f9cefa1a376\git_fixes_x86\workspace\PcsxrrWorkflow\src\?.dll]] ..package.cpath

print(addressof)

--print(os.execute("echo %LUA_PATH%"))
--print(os.execute("echo %LUA_CPATH%"))