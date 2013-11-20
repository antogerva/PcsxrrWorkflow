using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Diagnostics;
using System.IO;
using Microsoft.Win32;
using System.Text.RegularExpressions;

namespace WorkFlowPannel
{
    class PcsxrrRunner
    {
        public PcsxrrRunner() {

        }

        public string getStringDll(string dllPath)
        {
            Regex rgx = new Regex(@"[^\\]*.dll$");
            string dll = rgx.Matches(dllPath)[0].Value;
            return dll;
        }


        public void startDetect(ConfigStatus configStatus)
        {
            if (configStatus != null && !String.IsNullOrEmpty(configStatus.PcsxrrPath))
            {                
                string spuEternal = getStringDll(configStatus.EternalSpuPath);
                string spuTAS = getStringDll(configStatus.TasSpuPath);

                RegistryKey rk = Registry.CurrentUser.OpenSubKey(@"Software\PCSX-RR", true);
                try
                {
                    if (rk.GetValue("PluginSPU") != "")
                        rk.SetValue("PluginSPU", spuTAS);

                }
                catch (Exception e)
                {
                }
                
                string movieArgs = " -play \"" + configStatus.MoviePath + "\" -readonly";
                string luaDetectArgs = " -lua \"" + configStatus.LuaScriptPath + "\\" + DetectParser.FILE_DETECT_SCRIPT + "\"";

                //Thread t = new Thread(Thread.st);
                Process.Start(configStatus.PcsxrrPath, movieArgs + luaDetectArgs);
            }
        }

        public void startSync(ConfigStatus configStatus)
        {
            if (configStatus != null && !String.IsNullOrEmpty(configStatus.PcsxrrPath))
            {
                string spuEternal = getStringDll(configStatus.EternalSpuPath);
                string spuTAS = getStringDll(configStatus.TasSpuPath);

                RegistryKey rk = Registry.CurrentUser.OpenSubKey(@"Software\PCSX-RR", true);
                try
                {
                    if (rk.GetValue("PluginSPU") != "")
                        rk.SetValue("PluginSPU", spuEternal);

                }
                catch (Exception e)
                {
                }
                
                string movieArgs = " -play \"" + configStatus.MoviePath + "\" -readonly";
                string luaDetectArgs = " -lua \"" + configStatus.LuaScriptPath + "\\" + SyncParser.FILE_SYNC_SCRIPT + "\"";

                //Thread t = new Thread(Thread.st);
                Process.Start(configStatus.PcsxrrPath, movieArgs + luaDetectArgs);
            }


        }

    }
}
