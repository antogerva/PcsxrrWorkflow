using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.IO;
using System.Xml.Linq;

namespace WorkFlowPannel
{
    class ConfigParser : XmlParser
    {
        public const string FILE_CONFIG = "WorkflowAppConfig.xml";
        public const string FILE_CONFIG_XML = "workflowAppConfig.xml";

        //XML Element:
        public const string XE_CONFIG_ROOT = "PcsxrrWorfkflow";
        public const string XE_CONFIG_PCSXRR_PATH = "PcsxrrPath";
        public const string XE_CONFIG_MOVIE_PATH = "MoviePath";
        public const string XE_CONFIG_TAS_SPU_PATH = "TasSpuPath";
        public const string XE_CONFIG_ETERNAL_SPU_PATH = "EternalSpuPath";
        public const string XE_CONFIG_WORKFLOW_PATH = "WorkflowPath";
        public const string XE_CONFIG_LUA_SCRIPT_PATH = "LuaScriptPath";
        public const string XE_CONFIG_KKAPTURE_PATH = "KkapturePath";

        private XmlNodeWrapper pcsxrrPath = null;
        private XmlNodeWrapper moviePath = null;
        private XmlNodeWrapper tasSpuPath = null;
        private XmlNodeWrapper eternalSpuPath = null;
        private XmlNodeWrapper workflowPath = null;
        private XmlNodeWrapper luaScriptPath = null;
        private XmlNodeWrapper kkapturePath = null;

        public ConfigParser(ConfigStatus configStatus)
        {
            pcsxrrPath = new XmlNodeWrapper("/" + ConfigParser.XE_CONFIG_ROOT + "/" + ConfigParser.XE_CONFIG_PCSXRR_PATH);
            moviePath = new XmlNodeWrapper("/" + ConfigParser.XE_CONFIG_ROOT + "/" + ConfigParser.XE_CONFIG_MOVIE_PATH);
            tasSpuPath = new XmlNodeWrapper("/" + ConfigParser.XE_CONFIG_ROOT + "/" + ConfigParser.XE_CONFIG_TAS_SPU_PATH);
            eternalSpuPath = new XmlNodeWrapper("/" + ConfigParser.XE_CONFIG_ROOT + "/" + ConfigParser.XE_CONFIG_ETERNAL_SPU_PATH);
            workflowPath = new XmlNodeWrapper("/" + ConfigParser.XE_CONFIG_ROOT + "/" + ConfigParser.XE_CONFIG_WORKFLOW_PATH);
            luaScriptPath = new XmlNodeWrapper("/" + ConfigParser.XE_CONFIG_ROOT + "/" + ConfigParser.XE_CONFIG_LUA_SCRIPT_PATH);
            kkapturePath = new XmlNodeWrapper("/" + ConfigParser.XE_CONFIG_ROOT + "/" + ConfigParser.XE_CONFIG_KKAPTURE_PATH);

            if (configStatus != null)
            {
                //Map the node value
                pcsxrrPath.NodeValue = configStatus.PcsxrrPath;
                moviePath.NodeValue = configStatus.MoviePath;
                tasSpuPath.NodeValue = configStatus.TasSpuPath;
                eternalSpuPath.NodeValue = configStatus.EternalSpuPath;
                workflowPath.NodeValue = configStatus.WorkflowPath;
                luaScriptPath.NodeValue = configStatus.LuaScriptPath;
                kkapturePath.NodeValue = configStatus.KkapturePath;
            }
        }

        public XmlDocument updateConfig()
        {
            string pathConfig = getCurrentAppPath() + @"\" + ConfigParser.FILE_CONFIG;
            XmlDocument docConfig = XmlUtil.readXML(pathConfig);

            if (docConfig != null)
                loadConfig(docConfig);

            return buildXmlConfig();
        }

        public string getCurrentAppPath()
        {
            return System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetEntryAssembly().Location);
        }

        public void loadConfig(XmlDocument docConfig)
        {
            this.pcsxrrPath.updateValue(docConfig);
            this.moviePath.updateValue(docConfig);
            this.tasSpuPath.updateValue(docConfig);
            this.eternalSpuPath.updateValue(docConfig);
            this.workflowPath.updateValue(docConfig);
            this.luaScriptPath.updateValue(docConfig);
            this.kkapturePath.updateValue(docConfig);
        }

        public XmlDocument buildXmlConfig()
        {
            XmlDocument document = XmlUtil.createXml();
            XmlNode root = XmlUtil.createXmlNode(document, ConfigParser.XE_CONFIG_ROOT, null);
            XmlNode pcsxrrPath = XmlUtil.createXmlNode(document, ConfigParser.XE_CONFIG_PCSXRR_PATH, this.pcsxrrPath.NodeValue);
            XmlNode moviePath = XmlUtil.createXmlNode(document, ConfigParser.XE_CONFIG_MOVIE_PATH, this.moviePath.NodeValue);
            XmlNode tasSpuPath = XmlUtil.createXmlNode(document, ConfigParser.XE_CONFIG_TAS_SPU_PATH, this.tasSpuPath.NodeValue);
            XmlNode eternalSpuPath = XmlUtil.createXmlNode(document, ConfigParser.XE_CONFIG_ETERNAL_SPU_PATH, this.eternalSpuPath.NodeValue);
            XmlNode workflowPath = XmlUtil.createXmlNode(document, ConfigParser.XE_CONFIG_WORKFLOW_PATH, this.workflowPath.NodeValue);
            XmlNode luaScriptPath = XmlUtil.createXmlNode(document, ConfigParser.XE_CONFIG_LUA_SCRIPT_PATH, this.luaScriptPath.NodeValue);
            XmlNode kkapturePath = XmlUtil.createXmlNode(document, ConfigParser.XE_CONFIG_KKAPTURE_PATH, this.kkapturePath.NodeValue);

            document.AppendChild(root);
            root.AppendChild(pcsxrrPath);
            root.AppendChild(moviePath);
            root.AppendChild(tasSpuPath);
            root.AppendChild(eternalSpuPath);
            root.AppendChild(workflowPath);
            root.AppendChild(luaScriptPath);
            root.AppendChild(kkapturePath);

            return document;
        }

        public ConfigStatus updateStatus()
        {
            ConfigStatus configStatus = ConfigStatus.getInstance();

            configStatus.PcsxrrPath = this.pcsxrrPath.NodeValue;
            configStatus.MoviePath = this.moviePath.NodeValue;
            configStatus.TasSpuPath = this.tasSpuPath.NodeValue;
            configStatus.EternalSpuPath = this.eternalSpuPath.NodeValue;
            configStatus.WorkflowPath = this.workflowPath.NodeValue;
            configStatus.LuaScriptPath = this.luaScriptPath.NodeValue;
            configStatus.KkapturePath = this.kkapturePath.NodeValue;

            return configStatus;
        }
    }
}
