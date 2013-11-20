using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.IO;
using System.Xml.Linq;

namespace WorkFlowPannel
{
    public static class XmlUtil
    {
        public static XmlDocument createXml()
        {
            XmlDocument document = new XmlDocument();
            XmlDeclaration xmlDeclaration = document.CreateXmlDeclaration((new Version(1, 0)).ToString(), Encoding.UTF8.BodyName, string.Empty);
            document.AppendChild(xmlDeclaration);
            return document;
        }

        public static XmlNode createXmlNode(XmlDocument xmlDocument, string name, string value)
        {
            XmlNode node = xmlDocument.CreateNode(XmlNodeType.Element, name, string.Empty);
            node.AppendChild(xmlDocument.CreateTextNode(value));
            return node;
        }

        public static void setXmlNodeValue(XmlNode xmlae, object value)
        {
            setXmlNodeValue(xmlae, value, string.Empty);
        }

        public static void setXmlNodeValue(XmlNode xmlae, string value)
        {
            XmlDocument ownerDocument = xmlae.OwnerDocument;
            foreach (XmlNode node in xmlae.ChildNodes)
            {
                if (node.NodeType == XmlNodeType.Text)
                {
                    node.Value = value;
                }
            }
        }

        public static void setXmlNodeValue(XmlNode xmlae, object value, string defaultStr)
        {
            string str = defaultStr;
            if (value != null)
            {
                str = value.ToString();
            }
            if (str != null)
            {
                setXmlNodeValue(xmlae, str.ToString());
            }
        }
        
        public static string loadString(XmlNode parent, string nodeName)
        {
            string value = "";
            try
            {
                XmlElement elem = parent[nodeName];
                if (elem != null)
                    value = elem.InnerText.Trim();
            }
            catch
            {
                value = string.Empty;
            }

            return value;
        }

        public static string getNodeValue(XmlDocument document, string xpath)
        {
            XmlNode node = document.SelectSingleNode(xpath);
            if (node != null && node.FirstChild != null)
                return node.FirstChild.Value;
            else
                return "";
        }


        public static void writeXML(XmlDocument document, string path)
        {
            using (XmlTextWriter writer = new XmlTextWriter(path, null))
            {
                writer.Formatting = Formatting.Indented;
                writer.Indentation = 3;

                document.Save(writer);
            }
        }


        public static XmlDocument readXML(string path)
        {
            if (!File.Exists(path))
                return null;

            string xmlText = File.ReadAllText(path);
            if(String.IsNullOrEmpty(xmlText))
                return null;
            var doc = new XmlDocument();
            doc.LoadXml(xmlText);

            return doc;
        }

    }
}
