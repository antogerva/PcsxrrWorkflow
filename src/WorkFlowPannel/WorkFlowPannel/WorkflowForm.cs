using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Microsoft.Win32;
using System.Xml;
using System.Threading;
using System.IO;
using System.Text.RegularExpressions;

namespace WorkFlowPannel
{
    public partial class frmWorkFlowPannel : Form
    {

        public frmWorkFlowPannel()
        {
            InitializeComponent();
            init();
        }


        public void init()
        {
            //TODO...

            if (File.Exists(ConfigParser.FILE_CONFIG))
            {
                ConfigParser configParser = new ConfigParser(null);
                configParser.updateConfig();
                ConfigStatus configStatus = configParser.updateStatus();

                if (configStatus != null)
                {
                    txtPcsxrrPath.Text = configStatus.PcsxrrPath;
                    txtMoviePath.Text = configStatus.MoviePath;
                    txtTasSpuPath.Text = configStatus.TasSpuPath;
                    txtEternalSpuPath.Text = configStatus.EternalSpuPath;
                    txtWorkflowPath.Text = configStatus.WorkflowPath;
                    txtLuaScriptPath.Text = configStatus.LuaScriptPath;
                    txtKKapturePath.Text = configStatus.KkapturePath;
                }
            }
        }


        public bool validatePlugin()
        {
            RegistryKey rk = Registry.CurrentUser.OpenSubKey(@"Software\PCSX-RR", true);
            try
            {
                if ((string)(rk.GetValue("PluginSPU")) != "")
                    return true;
                else return false;
                //rk.SetValue("PluginSPU", "spuEternal_b.dll");

            }
            catch (Exception e)
            {
                return false;
            }

        }

        public void setPathTextBox(TextBox txtBox, Boolean isFolder)
        {
            if (isFolder)
            {
                FolderBrowserDialog fbd = new FolderBrowserDialog();
                if( fbd.ShowDialog() == DialogResult.OK)
                    txtBox.Text = fbd.SelectedPath;
                return;
            }

            string path = "";
            OpenFileDialog file = new OpenFileDialog();
            if (file.ShowDialog() == DialogResult.OK)
            {
                path = file.FileName;
            }
            txtBox.Text = path;

        }


        private void btnLoadSavestateDetect_Click(object sender, EventArgs e)
        {

        }

        private void btnLoadSaveStateSync_Click(object sender, EventArgs e)
        {
            /*
            //TODO: temp
            XmlDocument document = XmlUtil.createXml();
            XmlNode root = XmlUtil.createXmlNode(document, "root", null);
            document.AppendChild(root);
            XmlNode test = XmlUtil.createXmlNode(document, "test", "bob");
            root.AppendChild(test);
            XmlNode ttt = XmlUtil.createXmlNode(document, "ttt", "ffff");
            root.AppendChild(ttt);

            //ConfigParser.writeXML(document, @"C:\Users\antogerva\emu\pcsxrr-13c\PcsxrrEncodeWofkflowV5.01\stuff\bla.xml");

            XmlDocument document2 = XmlUtil.readXML(@"C:\Users\antogerva\emu\pcsxrr-13c\PcsxrrEncodeWofkflowV5.01\stuff\bla3.xml");

            XmlUtil.writeXML(document2, @"C:\Users\antogerva\emu\pcsxrr-13c\PcsxrrEncodeWofkflowV5.01\stuff\bla2.xml");
            */


        }

        public void startConfig(ConfigStatus configStatus)
        {            
            //TODO put that movieName info elsewere
            Regex rgx = new Regex(@"[^\\]*.pxm$");
            string movieName = rgx.Matches(configStatus.MoviePath)[0].Value;
            string backupMovie = configStatus.WorkflowPath + "\\" + movieName;



            if(!File.Exists(backupMovie))
                File.Copy(configStatus.MoviePath, backupMovie);

            PCSX movieInfo = new PCSX(backupMovie);
            DetectStatus detectStatus = new DetectStatus();
            detectStatus.MovieProcessed = movieInfo.Filename;
            detectStatus.MovieDuration = movieInfo.Header.FrameCount;
            DetectParser detectParser = new DetectParser(detectStatus);
            detectParser.updateConfig(configStatus.WorkflowPath, true);            

            string pathDetectXml = configStatus.WorkflowPath + "\\" + DetectParser.FILE_DETECT_XML;
            //TODO: check this out
            //XmlUtil.writeXML(detectParser.buildXmlConfig(), pathDetectXml);
        }


        private void btnStartWorkflow_Click(object sender, EventArgs e)
        {
            ConfigStatus configStatus = ConfigStatus.getInstance();
            if (!File.Exists(configStatus.PcsxrrPath))
            {
                MessageBox.Show("Please make sure the pcsxrr path is valid");
                return;
            }
            else if (!File.Exists(configStatus.MoviePath))
            {
                MessageBox.Show("Please make sure the movie path is valid");
                return;
            }

            startConfig(configStatus);
            //updateConfig();
            PcsxrrRunner runner = new PcsxrrRunner();
            runner.startDetect(configStatus);

        }

        private void btnStartSync_Click(object sender, EventArgs e)
        {
            ConfigStatus configStatus = ConfigStatus.getInstance();
            if (!File.Exists(configStatus.PcsxrrPath))
            {
                MessageBox.Show("Please make sure the pcsxrr path is valid");
                return;
            }
            else if (!File.Exists(configStatus.MoviePath))
            {
                MessageBox.Show("Please make sure the movie path is valid");
                return;
            }

            startConfig(configStatus);
            //updateConfig();
            PcsxrrRunner runner = new PcsxrrRunner();
            runner.startSync(configStatus);

        }


        private void btnMoviePath_Click(object sender, EventArgs e)
        {
            setPathTextBox(txtMoviePath, false);
        }

        private void btnPcsxrrPath_Click(object sender, EventArgs e)
        {
            setPathTextBox(txtPcsxrrPath, false);
        }

        private void btnTasSpu_Click(object sender, EventArgs e)
        {
            setPathTextBox(txtTasSpuPath, false);
        }

        private void btnEternalSpu_Click(object sender, EventArgs e)
        {
            setPathTextBox(txtEternalSpuPath, false);
        }

        private void btnWorkflow_Click(object sender, EventArgs e)
        {
            setPathTextBox(txtWorkflowPath, true);
        }

        private void btnLuaScriptPath_Click(object sender, EventArgs e)
        {
            setPathTextBox(txtLuaScriptPath, true);
        }

        private void btnKKapturePath_Click(object sender, EventArgs e)
        {
            setPathTextBox(txtKKapturePath, false);
        }
        private void btnSaveProfile_Click(object sender, EventArgs e)
        {
            ConfigStatus configStatus = ConfigStatus.getInstance();
            configStatus.PcsxrrPath = txtPcsxrrPath.Text;
            configStatus.MoviePath = txtMoviePath.Text;
            configStatus.TasSpuPath = txtTasSpuPath.Text;
            configStatus.EternalSpuPath = txtEternalSpuPath.Text;
            configStatus.WorkflowPath = txtWorkflowPath.Text;
            configStatus.LuaScriptPath = txtLuaScriptPath.Text;
            configStatus.KkapturePath = txtKKapturePath.Text;

            Directory.CreateDirectory(configStatus.WorkflowPath);

            ConfigParser parser = new ConfigParser(configStatus);
            XmlUtil.writeXML(parser.buildXmlConfig(), ConfigParser.FILE_CONFIG);
        }
    }
}
