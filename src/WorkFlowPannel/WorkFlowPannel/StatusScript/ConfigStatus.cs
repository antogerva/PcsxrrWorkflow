using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WorkFlowPannel
{
    public class ConfigStatus
    {
        private string pcsxrrPath = "";
        private string moviePath = "";
        private string tasSpuPath = "";
        private string eternalSpuPath = "";
        private string workflowPath = "";
        private string luaScriptPath = "";

        private string kkapturePath = "";

        public string PcsxrrPath
        {
            get { return pcsxrrPath; }
            set { pcsxrrPath = value; }
        }
        public string MoviePath
        {
            get { return moviePath; }
            set { moviePath = value; }
        }
        public string TasSpuPath
        {
            get { return tasSpuPath; }
            set { tasSpuPath = value; }
        }
        public string EternalSpuPath
        {
            get { return eternalSpuPath; }
            set { eternalSpuPath = value; }
        }
        public string WorkflowPath
        {
            get { return workflowPath; }
            set { workflowPath = value; }
        }
        public string LuaScriptPath
        {
            get { return luaScriptPath; }
            set { luaScriptPath = value; }
        }
        public string KkapturePath
        {
            get { return kkapturePath; }
            set { kkapturePath = value; }
        }

        public static ConfigStatus getInstance() {
            return ConfigStatus.ConfigStatusKeeper.instance;
        }
        
	    private static class ConfigStatusKeeper{
            public static ConfigStatus instance = new ConfigStatus();
	    }	

        public ConfigStatus(){
        }
    }
}
