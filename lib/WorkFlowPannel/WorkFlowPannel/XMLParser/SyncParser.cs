using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.IO;
using System.Xml.Linq;

namespace WorkFlowPannel
{
    public class SyncParser : XmlParser
    {
        public const string FILE_SYNC_SCRIPT = "synchCheckpoint.lua";
        public const string FILE_SYNC_XML = "syncInfoStatus.xml";

        //XML Element:
        public const string XE_SYNC_ROOT = "SyncStatus";
        public const string XE_SYNC_MOVIE_PROCESSED = "MovieProcessed";
        public const string XE_SYNC_MOVIE_DURATION = "MovieDuration";

        public const string XE_SYNC_CURRENT_FRAME = "CurrentFrame";
        public const string XE_SYNC_STATE_PROCESS = "StateProcess";

        public const string XE_SYNC_POSSIBLE_DESYNCS = "PossibleDesyncs";

        private XmlNodeWrapper movieProcessed = null;
        private XmlNodeWrapper movieDuration = null;

        private XmlNodeWrapper currentFrame = null;
        private XmlNodeWrapper stateProcess = null;

        private XmlNodeWrapper possibleDesyncs = null;

        //all node
        private List<XmlNodeWrapper> xmlListNode = null;

        public SyncParser()
        {
            movieProcessed = new XmlNodeWrapper("/" + SyncParser.XE_SYNC_ROOT + "/" + SyncParser.XE_SYNC_MOVIE_PROCESSED);
            movieDuration = new XmlNodeWrapper("/" + SyncParser.XE_SYNC_ROOT + "/" + SyncParser.XE_SYNC_MOVIE_DURATION);
            currentFrame = new XmlNodeWrapper("/" + SyncParser.XE_SYNC_ROOT + "/" + SyncParser.XE_SYNC_CURRENT_FRAME);
            stateProcess = new XmlNodeWrapper("/" + SyncParser.XE_SYNC_ROOT + "/" + SyncParser.XE_SYNC_STATE_PROCESS);
            possibleDesyncs = new XmlNodeWrapper("/" + SyncParser.XE_SYNC_ROOT + "/" + SyncParser.XE_SYNC_POSSIBLE_DESYNCS);

            xmlListNode = new List<XmlNodeWrapper>();
            xmlListNode.Add(movieProcessed);
            xmlListNode.Add(movieDuration);
            xmlListNode.Add(currentFrame);
            xmlListNode.Add(stateProcess);
            xmlListNode.Add(possibleDesyncs);

            updateConfig();
        }

        public XmlDocument updateConfig()
        {
            string pathConfig = getCurrentAppPath() + @"\" + SyncParser.FILE_SYNC_SCRIPT;
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
            foreach (XmlNodeWrapper xmlNode in xmlListNode)
            {
                
            }
            this.movieProcessed.updateValue(docConfig);
            this.movieDuration.updateValue(docConfig);
            this.currentFrame.updateValue(docConfig);
            this.stateProcess.updateValue(docConfig);
            this.possibleDesyncs.updateValue(docConfig);
        }

        public XmlDocument buildXmlConfig()
        {
            XmlDocument document = XmlUtil.createXml();
            XmlNode root = XmlUtil.createXmlNode(document, SyncParser.XE_SYNC_ROOT, null);
            XmlNode movieProcessed = XmlUtil.createXmlNode(document, SyncParser.XE_SYNC_MOVIE_PROCESSED, this.movieProcessed.NodeValue);
            XmlNode movieDuration = XmlUtil.createXmlNode(document, SyncParser.XE_SYNC_MOVIE_DURATION, this.movieDuration.NodeValue);
            XmlNode currentFrame = XmlUtil.createXmlNode(document, SyncParser.XE_SYNC_CURRENT_FRAME, this.currentFrame.NodeValue);
            XmlNode stateProcess = XmlUtil.createXmlNode(document, SyncParser.XE_SYNC_STATE_PROCESS, this.stateProcess.NodeValue);
            XmlNode possibleDesyncs = XmlUtil.createXmlNode(document, SyncParser.XE_SYNC_POSSIBLE_DESYNCS, this.possibleDesyncs.NodeValue);

            document.AppendChild(root);
            root.AppendChild(movieProcessed);
            root.AppendChild(movieDuration);
            root.AppendChild(currentFrame);
            root.AppendChild(stateProcess);
            root.AppendChild(possibleDesyncs);

            return document;
        }
    }
}
