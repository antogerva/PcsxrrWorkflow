using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.IO;
using System.Xml.Linq;

namespace WorkFlowPannel
{
    class XmlNodeWrapper 
    {
        private string nodeName = "";
        private string nodeValue = "";
        private string xpath = "";

        public string NodeName
        {
            get { return nodeName; }
            set { nodeName = value; }
        }
        public string NodeValue
        {
            get { return nodeValue; }
            set { nodeValue = value; }
        }
        public string Xpath
        {
            get { return xpath; }
            set { xpath = value; }
        }

        public XmlNodeWrapper(string xpath){
            this.xpath = xpath;
            this.nodeName = xpath.Substring(xpath.LastIndexOf('/')); 
        }

        public string updateValue(XmlDocument document)
        {
            this.nodeValue = XmlUtil.getNodeValue(document, this.xpath);
            return this.nodeValue;
        }

        public override string ToString()
        {
            return nodeName;
        }

    }
}
