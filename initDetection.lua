
--[[
{
string={sub=function:026B52B0, upper=function:026B52F0, len=function:026B5170,
 gfind=function:026B50F0, rep=function:086F7B30, find=function:026B5030,
  match=function:026B5210, char=function:026B4FB0, dump=function:026B4FF0,
   gmatch=function:026B50F0, reverse=function:026B5270, byte=function:026B4F70,
    format=function:026B5070, gsub=function:026B5130, lower=function:026B51D0},
     xpcall=function:0028D888,
      package={preload={}, loadlib=function:026B3E68,
      loaded={string=table:parent^4, package=table:parent^3, _G=table:parent^5,
       emu={sleep=function:00289DA8, registerexit=function:00289D28, 
       lagged=function:00289CA8, print=function:00289D88, quit=function:00289F08,
        lagcount=function:00289C88, unpause=function:00289C28, makesnap=function:00289E28,
         registerafter=function:00289D08, switchspu=function:00289DE8, getgamename=function:00289EA8,
          suspend=function:00289EC8, frameadvance=function:002893A0, message=function:00289D48, 
          testgpu=function:00289E48, speedmode=function:00289380, getconfig=function:00289E88,
           redrawscreen=function:00289E08, registerbefore=function:00289CE8,
            pause=function:002893C0, framecount=function:00289C68},
            
             os={exit=function:026B4DD0, setlocale=function:026B4EB0,
              date=function:0028CBD0, getenv=function:026B4E10, 
              difftime=function:0028CC10, remove=function:026B4E50,
               time=function:026B4ED0, clock=function:0028CB90,
                tmpname=function:026B4F10, rename=function:026B4E70
                , execute=function:0028CC30},
                
                 table={setn=function:00281D60, insert=function:00281CE0,
                  getn=function:00281C60, foreachi=function:026B4168,
                   maxn=function:00281CA0, foreach=function:026B4128, 
                   concat=function:026B40E8, sort=function:00281DA0, remove=function:00281D20},
                   
                    math={log=function:026B5B18, max=function:026B5B58, acos=function:026B53D0,                    
                     huge=1.#INF, ldexp=function:026B5A98, pi=3.14159265359, cos=function:026B5550,
                      tanh=function:00289020, pow=function:026B5C18, deg=function:026B3E08, tan=function:00289060,
                       cosh=function:026B5510, sinh=function:026B5CF8, random=function:026B5C98, 
                       randomseed=function:026B5CD8, frexp=function:026B5A58, ceil=function:026B54D0, 
                       floor=function:026B59D8, rad=function:026B5C58, abs=function:026B5390,
                        sqrt=function:026B5D78, modf=function:026B5BD8, asin=function:026B5410,
                         min=function:026B5B98, mod=function:026B5A18, fmod=function:026B5A18,
                          log10=function:026B5AD8, atan2=function:026B5450, exp=function:00281DE0,
                           sin=function:026B5D38, atan=function:026B5490}, 
                           
                           coroutine=table:parent^14,
                            debug={getupvalue=function:00289260, debug=function:00289140,
                             sethook=function:002892A0, getmetatable=function:00289240,
                              gethook=function:00289180, setmetatable=function:00289300,
                               setlocal=function:002892E0, traceback=function:00289340,
                                setfenv=function:00289280, getinfo=function:002891C0, setupvalue=function:00289320, 
                                getlocal=function:00289200, getregistry=function:00289220, getfenv=function:00289160},
                                 
                                joypad={getanalog=function:0028E930, write=function:0028E990, set=function:0028E8F0,
                                 getdown=function:0028E870, read=function:0028E970, readup=function:0028E9D0, 
                                 readdown=function:0028E9B0, getup=function:0028E8B0, setanalog=function:0028E950, get=function:0028E830},
                                 
                                  bit={band=function:00285180, rshift=function:00285280,
                                   bor=function:002851C0, bnot=function:00285140, bswap=function:00285380,
                                    bxor=function:00285200, tobit=function:00285100, ror=function:00285340,
                                     lshift=function:00285240, tohex=function:002853C0, rol=function:00285300, arshift=function:002852C0},
                                     
                                      memory={readshortunsigned=function:0028E6F0, readbyte=function:0028DD08, readword=function:0028DD48,
                                       readlongsigned=function:0028E770, writedword=function:0028DE28, writelong=function:0028E7B0,
                                        readdword=function:0028DD88, writeshort=function:0028E790, readbytesigned=function:0028DD28,
                                         readlongunsigned=function:0028E750, writebyte=function:0028DDE8, readdwordsigned=function:0028DDA8,
                                          register=function:0028E7F0, registerwrite=function:0028E7D0, readlong=function:0028E730,
                                           readdwordunsigned=function:0028DE88, readbyterange=function:0028DDC8, readwordsigned=function:0028DD68,
                                            writeword=function:0028DE08, readshortsigned=function:0028E710, readwordunsigned=function:0028DE68,
                                             readshort=function:0028E6D0, readbyteunsigned=function:0028DE48},
                                             
                                              pcsx={sleep=function:0028DBC8,
                                              registerexit=function:0028DB68, lagged=function:0028DB08, print=function:0028DBA8,
                                               quit=function:0028DCC8, lagcount=function:0028DAE8, unpause=function:00289FC8,
                                                makesnap=function:0028DC28, registerafter=function:0028DB48, switchspu=function:0028DBE8,
                                                 getgamename=function:0028DC88, suspend=function:0028DCA8, frameadvance=function:00289F88,
                                                  message=function:0028DB88, testgpu=function:0028DC48, speedmode=function:00289F68,
                                                   getconfig=function:0028DC68, redrawscreen=function:0028DC08, registerbefore=function:0028DB28,
                                                    pause=function:00289FA8, framecount=function:0028DAC8},
                                                    
                                                     savestate={savefile=function:0028EA70,
                                                     load=function:0028EA90, save=function:0028EA30, create=function:0028EA10, loadfile=function:0028ECD8},
                                                     
                                                      input={getlastbuttonpolled=function:0028FE68, popup=function:0028FE48, read=function:0028FE88, get=function:0028FE28},
                                                       
                                                        io={lines=function:0028C930,                                                        
                                                         write=function:0028CA90, close=function:0028C8B0,
                                                        flush=function:0028C8D0, open=function:0028C950, output=function:0028C990, type=function:0028CA70,
                                                         read=function:0028CA10, stderr=file (004A80C0), stdin=file (004A8080),
                                                          input=function:0028C8F0, stdout=file (004A80A0), popen=function:0028C9D0,
                                                           tmpfile=function:0028CA30}, 
                                                           
                                                           movie={active=function:0028ED18, close=function:0028EF58,
                                                            rerecordcounting=function:0028EED8, load=function:0028EF38, 
                                                            rerecordcount=function:0028EE78, recording=function:0028ED58,
                                                             stop=function:0028EEF8, name=function:0028EE38,
                                                              framecount=function:0028EEB8, length=function:0028EDF8, mode=function:0028EDB8,
                                                               setrerecordcount=function:0028EE98, playing=function:0028ED78},
                                                                gui={register=function:0028EF98, opacity=function:0028FAE8, box=function:0028EFF8, 
                                                                drawtext=function:0028FC28, line=function:0028F038, filepicker=function:0028FE08,
                                                                 gdscreenshot=function:0028FBA8, readpixel=function:0028FDC8, image=function:0028FD88,
                                                                  drawbox=function:0028FC48, drawimage=function:0028FD68, drawrect=function:0028FD48,
                                                                   rect=function:0028FD08, parsecolor=function:0028FB88, writepixel=function:0028FCE8,
                                                                    text=function:0028EFB8, getpixel=function:0028FBE8, drawpixel=function:0028FCA8,
                                                                     clearuncommitted=function:0028FC08, transparency=function:0028FB28,
                                                                      setpixel=function:0028FCC8, drawline=function:0028FC88,
                                                                       gdoverlay=function:0028FBC8, hashframe=function:0028FDE8, pixel=function:0028F078,
                                                                        popup=function:0028FB48}},
                                                                        
                                                                         loaders={function:026B3EE8, function:026B3F08, [4]=function:026B3F48,
                                                                          [3]=function:026B3F28}, cpath='.\?.dll;C:\Users\antogerva\pcsxrr-feos-new3\feos-tas\output\?.dll;C:\Users\antogerva\pcsxrr-feos-new3\feos-tas\output\loadall.dll', config='\
;
?
!
-', path=';.\?.lua;C:\Users\antogerva\pcsxrr-feos-new3\feos-tas\output\lua\?.lua;C:\Users\antogerva\pcsxrr-feos-new3\feos-tas\output\lua\?\init.lua;C:\Users\antogerva\pcsxrr-feos-new3\feos-tas\output\?.lua;C:\Users\antogerva\pcsxrr-feos-new3\feos-tas\output\?\init.lua;D:\Program Files (x86)\Lua\5.1\lua\?.luac', seeall=function:026B3EA8}, tostring=function:00285420, print=function:00285400, SHIFT=function:00285560, XOR=function:00285520, os=table:parent^14, unpack=function:0028D848, AND=function:00285480, require=function:026B4068, getfenv=function:086F7E30, setmetatable=function:0028D7A8, next=function:086F7F90, copytable=function:00285460, assert=function:086F8030, joypad=table:parent^10, tonumber=function:0028D7C8, io=table:parent^4, rawequal=function:086F80F0, collectgarbage=function:086F7B50, getmetatable=function:086F7EB0, BIT=function:002855A0, module=function:026B4028, bit=table:parent^9, addressof=function:00285440, OR=function:002854C0, setfenv=function:0028D768, rawset=function:0028D6E8, emu=table:parent^15, gui=table:parent^2, movie=table:parent^3, savestate=table:parent^6, memory=table:parent^8, pcsx=table:parent^7, math=table:parent^12, debug=table:parent^11, pcall=function:086F8010, table=table:parent^13, newproxy=function:0028B660, type=function:0028D808, coroutine=table:parent^25, _G=table:parent^20, select=function:0028D728, gcinfo=function:086F7DD0, pairs=function:0028B630, rawget=function:086F7D10, loadstring=function:086F7F70, ipairs=function:0028B600, _VERSION='Lua 5.1', dofile=function:086F7C30, input=table:parent^5, load=function:086F7F10, error=function:086F7A50, loadfile=function:086F7EF0}




SHIFT=function:00285560, XOR=function:00285520,AND=function:00285480,copytable=function:00285460,
newproxy=function:0028B660, addressof=function:00285440, OR=function:002854C0, 


--]]
