using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.IO;
using System.Xml.Linq;

namespace WorkFlowPannel
{
    public class DetectParser : XmlParser
    {
        public const string FILE_DETECT_SCRIPT = "detectCheckpoint.lua";
        public const string FILE_DETECT_XML = "detectInfoStatus.xml";

        //XML Element:
        public const string XE_DETECT_ROOT = "DetectStatus";
        public const string XE_DETECT_MOVIE_PROCESSED = "MovieProcessed";
        public const string XE_DETECT_MOVIE_DURATION = "MovieDuration";
        //TODO: Add patrolling mode?

        public const string XE_DETECT_FIRST_LAGLESS_FRAME_ZONE = "FirstLaglessFrameZone";
        public const string XE_DETECT_SCREENSHOT_OFFSET = "ScreenshotOffSet";
        public const string XE_DETECT_STATE_PROCESS = "StateProcess";
        public const string XE_DETECT_CURRENT_SCREENSHOT_PROCESS = "CurrentScreenShotProcess";

        public const string XE_DETECT_CHECKPOINTS = "CheckPoints";
        public const string XE_DETECT_FIXED_DESYNCS = "FixedDesyncs";

        private XmlNodeWrapper movieProcessed = null;
        private XmlNodeWrapper movieDuration = null;

        private XmlNodeWrapper firstLaglessFrameZone = null;
        private XmlNodeWrapper screenshotOffSet = null;
        private XmlNodeWrapper stateProcess = null;
        private XmlNodeWrapper currentScreenShotProcess = null;

        private XmlNodeWrapper checkPoints = null;
        private XmlNodeWrapper fixedDesyncs = null;

        //all node
        private List<XmlNodeWrapper> xmlListNode = null;

        public DetectParser(DetectStatus detectStatus)
        {
            movieProcessed = new XmlNodeWrapper("/" + DetectParser.XE_DETECT_ROOT + "/" + DetectParser.XE_DETECT_MOVIE_PROCESSED);
            movieDuration = new XmlNodeWrapper("/" + DetectParser.XE_DETECT_ROOT + "/" + DetectParser.XE_DETECT_MOVIE_DURATION);
            screenshotOffSet = new XmlNodeWrapper("/" + DetectParser.XE_DETECT_ROOT + "/" + DetectParser.XE_DETECT_SCREENSHOT_OFFSET);
            firstLaglessFrameZone = new XmlNodeWrapper("/" + DetectParser.XE_DETECT_ROOT + "/" + DetectParser.XE_DETECT_FIRST_LAGLESS_FRAME_ZONE);
            stateProcess = new XmlNodeWrapper("/" + DetectParser.XE_DETECT_ROOT + "/" + DetectParser.XE_DETECT_STATE_PROCESS);
            currentScreenShotProcess = new XmlNodeWrapper("/" + DetectParser.XE_DETECT_ROOT + "/" + DetectParser.XE_DETECT_CURRENT_SCREENSHOT_PROCESS);
            checkPoints = new XmlNodeWrapper("/" + DetectParser.XE_DETECT_ROOT + "/" + DetectParser.XE_DETECT_CHECKPOINTS);
            fixedDesyncs = new XmlNodeWrapper("/" + DetectParser.XE_DETECT_ROOT + "/" + DetectParser.XE_DETECT_FIXED_DESYNCS);
            
            if (detectStatus != null)
            {
                //Map the node value
                movieProcessed.NodeValue = detectStatus.MovieProcessed;
                movieDuration.NodeValue = detectStatus.MovieDuration.ToString();
                screenshotOffSet.NodeValue = detectStatus.ScreenhotOffset.ToString();
                stateProcess.NodeValue = detectStatus.StateProcess;
                currentScreenShotProcess.NodeValue = detectStatus.CurrentScreenshotProcess.ToString();
                //checkPoints.NodeValue = detectStatus.Checkpoints;
                //fixedDesyncs.NodeValue = detectStatus.FixedDesyncs;
            }

            xmlListNode = new List<XmlNodeWrapper>();
            xmlListNode.Add(movieProcessed);
            xmlListNode.Add(movieDuration);
            xmlListNode.Add(screenshotOffSet);
            xmlListNode.Add(stateProcess);
            xmlListNode.Add(currentScreenShotProcess);
            xmlListNode.Add(checkPoints);
            xmlListNode.Add(fixedDesyncs);

            //updateConfig();
        }

        public XmlDocument updateConfig(string workflowPath, bool updateOnlyNullValue)
        {
            string pathDetect = workflowPath + @"\" + DetectParser.FILE_DETECT_XML;
            XmlDocument docDetect = XmlUtil.readXML(pathDetect);

            if (docDetect != null)
                loadConfig(docDetect, updateOnlyNullValue);

            return buildXmlConfig();
        }

        public string getCurrentAppPath()
        {
            return System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetEntryAssembly().Location);
        }

        public void loadConfig(XmlDocument docConfig, bool updateOnlyNullValue)
        {
            foreach (XmlNodeWrapper xmlNode in xmlListNode)
            {
                if (updateOnlyNullValue == true && (xmlNode.NodeValue == null || xmlNode.NodeValue == "-1" || xmlNode.NodeValue == "0"))                    
                    xmlNode.updateValue(docConfig);
                else if (updateOnlyNullValue == false)
                    xmlNode.updateValue(docConfig);
            }
            //this.movieProcessed.updateValue(docConfig);
            //this.movieDuration.updateValue(docConfig);
            //this.screenshotOffSet.updateValue(docConfig);
            //this.stateProcess.updateValue(docConfig);
            //this.currentScreenShotProcess.updateValue(docConfig);
            //this.checkPoints.updateValue(docConfig);
        }

        public XmlDocument buildXmlConfig()
        {
            XmlDocument document = XmlUtil.createXml();
            XmlNode root = XmlUtil.createXmlNode(document, DetectParser.XE_DETECT_ROOT, null);
            XmlNode movieProcessed = XmlUtil.createXmlNode(document, DetectParser.XE_DETECT_MOVIE_PROCESSED, this.movieProcessed.NodeValue);
            XmlNode movieDuration = XmlUtil.createXmlNode(document, DetectParser.XE_DETECT_MOVIE_DURATION, this.movieDuration.NodeValue);
            XmlNode firstLaglessFrameZone = XmlUtil.createXmlNode(document, DetectParser.XE_DETECT_FIRST_LAGLESS_FRAME_ZONE, this.firstLaglessFrameZone.NodeValue);
            XmlNode screenshotOffSet = XmlUtil.createXmlNode(document, DetectParser.XE_DETECT_SCREENSHOT_OFFSET, this.screenshotOffSet.NodeValue);
            XmlNode stateProcess = XmlUtil.createXmlNode(document, DetectParser.XE_DETECT_STATE_PROCESS, this.stateProcess.NodeValue);
            XmlNode currentScreenShotProcess = XmlUtil.createXmlNode(document, DetectParser.XE_DETECT_CURRENT_SCREENSHOT_PROCESS, this.currentScreenShotProcess.NodeValue);
            XmlNode checkpoints = XmlUtil.createXmlNode(document, DetectParser.XE_DETECT_CHECKPOINTS, null); //TODO
            XmlNode fixedDesyncs = XmlUtil.createXmlNode(document, DetectParser.XE_DETECT_FIXED_DESYNCS, null); //TODO

            document.AppendChild(root);
            root.AppendChild(movieProcessed);
            root.AppendChild(movieDuration);
            root.AppendChild(firstLaglessFrameZone);
            root.AppendChild(screenshotOffSet);
            root.AppendChild(stateProcess);
            root.AppendChild(currentScreenShotProcess);
            root.AppendChild(checkpoints);
            root.AppendChild(fixedDesyncs);

            return document;
        }


    }
}
