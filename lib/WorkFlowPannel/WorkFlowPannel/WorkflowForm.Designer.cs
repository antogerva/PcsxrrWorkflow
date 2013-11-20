namespace WorkFlowPannel
{
    partial class frmWorkFlowPannel
    {
        /// <summary>
        /// Variable nécessaire au concepteur.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Nettoyage des ressources utilisées.
        /// </summary>
        /// <param name="disposing">true si les ressources managées doivent être supprimées ; sinon, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Code généré par le Concepteur Windows Form

        /// <summary>
        /// Méthode requise pour la prise en charge du concepteur - ne modifiez pas
        /// le contenu de cette méthode avec l'éditeur de code.
        /// </summary>
        private void InitializeComponent()
        {
            this.btnLoadSavestateDetect = new System.Windows.Forms.Button();
            this.grpDetect = new System.Windows.Forms.GroupBox();
            this.lblDetectSatus = new System.Windows.Forms.Label();
            this.cboSavestateDetect = new System.Windows.Forms.ComboBox();
            this.lvlSavestateDetect = new System.Windows.Forms.Label();
            this.grpSync = new System.Windows.Forms.GroupBox();
            this.lblSyncStatus = new System.Windows.Forms.Label();
            this.cboSavestateSync = new System.Windows.Forms.ComboBox();
            this.btnLoadSaveStateSync = new System.Windows.Forms.Button();
            this.lblSavestateSync = new System.Windows.Forms.Label();
            this.chkLastFrameMovie = new System.Windows.Forms.CheckBox();
            this.grpSetting = new System.Windows.Forms.GroupBox();
            this.chkCreateWorkflowFolder = new System.Windows.Forms.CheckBox();
            this.btnLuaScriptPath = new System.Windows.Forms.Button();
            this.lblLuaScriptPath = new System.Windows.Forms.Label();
            this.lblWorkflowPath = new System.Windows.Forms.Label();
            this.txtLuaScriptPath = new System.Windows.Forms.TextBox();
            this.txtWorkflowPath = new System.Windows.Forms.TextBox();
            this.btnSaveProfile = new System.Windows.Forms.Button();
            this.btnWorkflowPath = new System.Windows.Forms.Button();
            this.btnKKapturePath = new System.Windows.Forms.Button();
            this.btnEternalSpuPath = new System.Windows.Forms.Button();
            this.btnTasSpuPath = new System.Windows.Forms.Button();
            this.btnPcsxrrPath = new System.Windows.Forms.Button();
            this.btnMoviePath = new System.Windows.Forms.Button();
            this.lblEternalSpuPath = new System.Windows.Forms.Label();
            this.txtEternalSpuPath = new System.Windows.Forms.TextBox();
            this.lblTasSpuPath = new System.Windows.Forms.Label();
            this.txtTasSpuPath = new System.Windows.Forms.TextBox();
            this.lblKKapturePath = new System.Windows.Forms.Label();
            this.txtKKapturePath = new System.Windows.Forms.TextBox();
            this.lblMoviePath = new System.Windows.Forms.Label();
            this.txtMoviePath = new System.Windows.Forms.TextBox();
            this.lblPcsxrrPath = new System.Windows.Forms.Label();
            this.txtPcsxrrPath = new System.Windows.Forms.TextBox();
            this.grpWorkFlow = new System.Windows.Forms.GroupBox();
            this.btnStartSync = new System.Windows.Forms.Button();
            this.lblStatus = new System.Windows.Forms.Label();
            this.btnStartWorkflow = new System.Windows.Forms.Button();
            this.lstWorkflowStatus = new System.Windows.Forms.TextBox();
            this.lstInfoDetect = new System.Windows.Forms.TextBox();
            this.lstInfoSync = new System.Windows.Forms.TextBox();
            this.grpDetect.SuspendLayout();
            this.grpSync.SuspendLayout();
            this.grpSetting.SuspendLayout();
            this.grpWorkFlow.SuspendLayout();
            this.SuspendLayout();
            // 
            // btnLoadSavestateDetect
            // 
            this.btnLoadSavestateDetect.Location = new System.Drawing.Point(249, 188);
            this.btnLoadSavestateDetect.Name = "btnLoadSavestateDetect";
            this.btnLoadSavestateDetect.Size = new System.Drawing.Size(152, 23);
            this.btnLoadSavestateDetect.TabIndex = 0;
            this.btnLoadSavestateDetect.Text = "Load Savestate";
            this.btnLoadSavestateDetect.UseVisualStyleBackColor = true;
            this.btnLoadSavestateDetect.Click += new System.EventHandler(this.btnLoadSavestateDetect_Click);
            // 
            // grpDetect
            // 
            this.grpDetect.Controls.Add(this.lstInfoDetect);
            this.grpDetect.Controls.Add(this.lblDetectSatus);
            this.grpDetect.Controls.Add(this.cboSavestateDetect);
            this.grpDetect.Controls.Add(this.lvlSavestateDetect);
            this.grpDetect.Controls.Add(this.btnLoadSavestateDetect);
            this.grpDetect.Location = new System.Drawing.Point(12, 415);
            this.grpDetect.Name = "grpDetect";
            this.grpDetect.Size = new System.Drawing.Size(435, 259);
            this.grpDetect.TabIndex = 1;
            this.grpDetect.TabStop = false;
            this.grpDetect.Text = "Detection Script";
            // 
            // lblDetectSatus
            // 
            this.lblDetectSatus.AutoSize = true;
            this.lblDetectSatus.Location = new System.Drawing.Point(6, 27);
            this.lblDetectSatus.Name = "lblDetectSatus";
            this.lblDetectSatus.Size = new System.Drawing.Size(95, 17);
            this.lblDetectSatus.TabIndex = 8;
            this.lblDetectSatus.Text = "Detect status:";
            // 
            // cboSavestateDetect
            // 
            this.cboSavestateDetect.FormattingEnabled = true;
            this.cboSavestateDetect.Location = new System.Drawing.Point(9, 189);
            this.cboSavestateDetect.Name = "cboSavestateDetect";
            this.cboSavestateDetect.Size = new System.Drawing.Size(212, 24);
            this.cboSavestateDetect.TabIndex = 7;
            // 
            // lvlSavestateDetect
            // 
            this.lvlSavestateDetect.AutoSize = true;
            this.lvlSavestateDetect.Location = new System.Drawing.Point(6, 153);
            this.lvlSavestateDetect.Name = "lvlSavestateDetect";
            this.lvlSavestateDetect.Size = new System.Drawing.Size(123, 17);
            this.lvlSavestateDetect.TabIndex = 3;
            this.lvlSavestateDetect.Text = "Load a Savestate:";
            // 
            // grpSync
            // 
            this.grpSync.Controls.Add(this.lstInfoSync);
            this.grpSync.Controls.Add(this.lblSyncStatus);
            this.grpSync.Controls.Add(this.cboSavestateSync);
            this.grpSync.Controls.Add(this.btnLoadSaveStateSync);
            this.grpSync.Controls.Add(this.lblSavestateSync);
            this.grpSync.Controls.Add(this.chkLastFrameMovie);
            this.grpSync.Location = new System.Drawing.Point(482, 420);
            this.grpSync.Name = "grpSync";
            this.grpSync.Size = new System.Drawing.Size(440, 254);
            this.grpSync.TabIndex = 2;
            this.grpSync.TabStop = false;
            this.grpSync.Text = "Sync Script";
            // 
            // lblSyncStatus
            // 
            this.lblSyncStatus.AutoSize = true;
            this.lblSyncStatus.Location = new System.Drawing.Point(6, 22);
            this.lblSyncStatus.Name = "lblSyncStatus";
            this.lblSyncStatus.Size = new System.Drawing.Size(85, 17);
            this.lblSyncStatus.TabIndex = 7;
            this.lblSyncStatus.Text = "Sync status:";
            // 
            // cboSavestateSync
            // 
            this.cboSavestateSync.FormattingEnabled = true;
            this.cboSavestateSync.Location = new System.Drawing.Point(9, 183);
            this.cboSavestateSync.Name = "cboSavestateSync";
            this.cboSavestateSync.Size = new System.Drawing.Size(215, 24);
            this.cboSavestateSync.TabIndex = 6;
            // 
            // btnLoadSaveStateSync
            // 
            this.btnLoadSaveStateSync.Location = new System.Drawing.Point(241, 184);
            this.btnLoadSaveStateSync.Name = "btnLoadSaveStateSync";
            this.btnLoadSaveStateSync.Size = new System.Drawing.Size(164, 23);
            this.btnLoadSaveStateSync.TabIndex = 3;
            this.btnLoadSaveStateSync.Text = "Load Savestate";
            this.btnLoadSaveStateSync.UseVisualStyleBackColor = true;
            this.btnLoadSaveStateSync.Click += new System.EventHandler(this.btnLoadSaveStateSync_Click);
            // 
            // lblSavestateSync
            // 
            this.lblSavestateSync.AutoSize = true;
            this.lblSavestateSync.Location = new System.Drawing.Point(6, 148);
            this.lblSavestateSync.Name = "lblSavestateSync";
            this.lblSavestateSync.Size = new System.Drawing.Size(123, 17);
            this.lblSavestateSync.TabIndex = 2;
            this.lblSavestateSync.Text = "Load a Savestate:";
            // 
            // chkLastFrameMovie
            // 
            this.chkLastFrameMovie.AutoSize = true;
            this.chkLastFrameMovie.Checked = true;
            this.chkLastFrameMovie.CheckState = System.Windows.Forms.CheckState.Checked;
            this.chkLastFrameMovie.Enabled = false;
            this.chkLastFrameMovie.Location = new System.Drawing.Point(241, 222);
            this.chkLastFrameMovie.Name = "chkLastFrameMovie";
            this.chkLastFrameMovie.Size = new System.Drawing.Size(181, 21);
            this.chkLastFrameMovie.TabIndex = 0;
            this.chkLastFrameMovie.Text = "Secure Sync-Movie End";
            this.chkLastFrameMovie.UseVisualStyleBackColor = true;
            // 
            // grpSetting
            // 
            this.grpSetting.Controls.Add(this.chkCreateWorkflowFolder);
            this.grpSetting.Controls.Add(this.btnLuaScriptPath);
            this.grpSetting.Controls.Add(this.lblLuaScriptPath);
            this.grpSetting.Controls.Add(this.lblWorkflowPath);
            this.grpSetting.Controls.Add(this.txtLuaScriptPath);
            this.grpSetting.Controls.Add(this.txtWorkflowPath);
            this.grpSetting.Controls.Add(this.btnSaveProfile);
            this.grpSetting.Controls.Add(this.btnWorkflowPath);
            this.grpSetting.Controls.Add(this.btnKKapturePath);
            this.grpSetting.Controls.Add(this.btnEternalSpuPath);
            this.grpSetting.Controls.Add(this.btnTasSpuPath);
            this.grpSetting.Controls.Add(this.btnPcsxrrPath);
            this.grpSetting.Controls.Add(this.btnMoviePath);
            this.grpSetting.Controls.Add(this.lblEternalSpuPath);
            this.grpSetting.Controls.Add(this.txtEternalSpuPath);
            this.grpSetting.Controls.Add(this.lblTasSpuPath);
            this.grpSetting.Controls.Add(this.txtTasSpuPath);
            this.grpSetting.Controls.Add(this.lblKKapturePath);
            this.grpSetting.Controls.Add(this.txtKKapturePath);
            this.grpSetting.Controls.Add(this.lblMoviePath);
            this.grpSetting.Controls.Add(this.txtMoviePath);
            this.grpSetting.Controls.Add(this.lblPcsxrrPath);
            this.grpSetting.Controls.Add(this.txtPcsxrrPath);
            this.grpSetting.Location = new System.Drawing.Point(12, 12);
            this.grpSetting.Name = "grpSetting";
            this.grpSetting.Size = new System.Drawing.Size(910, 261);
            this.grpSetting.TabIndex = 3;
            this.grpSetting.TabStop = false;
            this.grpSetting.Text = "Setting";
            // 
            // chkCreateWorkflowFolder
            // 
            this.chkCreateWorkflowFolder.AutoSize = true;
            this.chkCreateWorkflowFolder.Enabled = false;
            this.chkCreateWorkflowFolder.Location = new System.Drawing.Point(22, 230);
            this.chkCreateWorkflowFolder.Name = "chkCreateWorkflowFolder";
            this.chkCreateWorkflowFolder.Size = new System.Drawing.Size(225, 21);
            this.chkCreateWorkflowFolder.TabIndex = 21;
            this.chkCreateWorkflowFolder.Text = "Auto-create the workflow folder";
            this.chkCreateWorkflowFolder.UseVisualStyleBackColor = true;
            // 
            // btnLuaScriptPath
            // 
            this.btnLuaScriptPath.Font = new System.Drawing.Font("Microsoft Sans Serif", 6.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnLuaScriptPath.Location = new System.Drawing.Point(855, 137);
            this.btnLuaScriptPath.Name = "btnLuaScriptPath";
            this.btnLuaScriptPath.Size = new System.Drawing.Size(39, 22);
            this.btnLuaScriptPath.TabIndex = 20;
            this.btnLuaScriptPath.Text = "Pick";
            this.btnLuaScriptPath.UseVisualStyleBackColor = true;
            this.btnLuaScriptPath.Click += new System.EventHandler(this.btnLuaScriptPath_Click);
            // 
            // lblLuaScriptPath
            // 
            this.lblLuaScriptPath.AutoSize = true;
            this.lblLuaScriptPath.Location = new System.Drawing.Point(19, 137);
            this.lblLuaScriptPath.Name = "lblLuaScriptPath";
            this.lblLuaScriptPath.Size = new System.Drawing.Size(109, 17);
            this.lblLuaScriptPath.TabIndex = 19;
            this.lblLuaScriptPath.Text = "Lua Script Path:";
            // 
            // lblWorkflowPath
            // 
            this.lblWorkflowPath.AutoSize = true;
            this.lblWorkflowPath.Location = new System.Drawing.Point(19, 195);
            this.lblWorkflowPath.Name = "lblWorkflowPath";
            this.lblWorkflowPath.Size = new System.Drawing.Size(106, 17);
            this.lblWorkflowPath.TabIndex = 11;
            this.lblWorkflowPath.Text = "WorkFlow Path:";
            // 
            // txtLuaScriptPath
            // 
            this.txtLuaScriptPath.Location = new System.Drawing.Point(139, 137);
            this.txtLuaScriptPath.Name = "txtLuaScriptPath";
            this.txtLuaScriptPath.Size = new System.Drawing.Size(710, 22);
            this.txtLuaScriptPath.TabIndex = 18;
            // 
            // txtWorkflowPath
            // 
            this.txtWorkflowPath.Location = new System.Drawing.Point(139, 195);
            this.txtWorkflowPath.Name = "txtWorkflowPath";
            this.txtWorkflowPath.Size = new System.Drawing.Size(710, 22);
            this.txtWorkflowPath.TabIndex = 10;
            // 
            // btnSaveProfile
            // 
            this.btnSaveProfile.Location = new System.Drawing.Point(661, 228);
            this.btnSaveProfile.Name = "btnSaveProfile";
            this.btnSaveProfile.Size = new System.Drawing.Size(188, 23);
            this.btnSaveProfile.TabIndex = 11;
            this.btnSaveProfile.Text = "Save Profile";
            this.btnSaveProfile.UseVisualStyleBackColor = true;
            this.btnSaveProfile.Click += new System.EventHandler(this.btnSaveProfile_Click);
            // 
            // btnWorkflowPath
            // 
            this.btnWorkflowPath.Font = new System.Drawing.Font("Microsoft Sans Serif", 6.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnWorkflowPath.Location = new System.Drawing.Point(855, 195);
            this.btnWorkflowPath.Name = "btnWorkflowPath";
            this.btnWorkflowPath.Size = new System.Drawing.Size(39, 22);
            this.btnWorkflowPath.TabIndex = 16;
            this.btnWorkflowPath.Text = "Pick";
            this.btnWorkflowPath.UseVisualStyleBackColor = true;
            this.btnWorkflowPath.Click += new System.EventHandler(this.btnWorkflow_Click);
            // 
            // btnKKapturePath
            // 
            this.btnKKapturePath.Font = new System.Drawing.Font("Microsoft Sans Serif", 6.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnKKapturePath.Location = new System.Drawing.Point(855, 167);
            this.btnKKapturePath.Name = "btnKKapturePath";
            this.btnKKapturePath.Size = new System.Drawing.Size(39, 22);
            this.btnKKapturePath.TabIndex = 17;
            this.btnKKapturePath.Text = "Pick";
            this.btnKKapturePath.UseVisualStyleBackColor = true;
            this.btnKKapturePath.Click += new System.EventHandler(this.btnKKapturePath_Click);
            // 
            // btnEternalSpuPath
            // 
            this.btnEternalSpuPath.Font = new System.Drawing.Font("Microsoft Sans Serif", 6.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnEternalSpuPath.Location = new System.Drawing.Point(855, 107);
            this.btnEternalSpuPath.Name = "btnEternalSpuPath";
            this.btnEternalSpuPath.Size = new System.Drawing.Size(39, 22);
            this.btnEternalSpuPath.TabIndex = 15;
            this.btnEternalSpuPath.Text = "Pick";
            this.btnEternalSpuPath.UseVisualStyleBackColor = true;
            this.btnEternalSpuPath.Click += new System.EventHandler(this.btnEternalSpu_Click);
            // 
            // btnTasSpuPath
            // 
            this.btnTasSpuPath.Font = new System.Drawing.Font("Microsoft Sans Serif", 6.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnTasSpuPath.Location = new System.Drawing.Point(855, 78);
            this.btnTasSpuPath.Name = "btnTasSpuPath";
            this.btnTasSpuPath.Size = new System.Drawing.Size(39, 22);
            this.btnTasSpuPath.TabIndex = 14;
            this.btnTasSpuPath.Text = "Pick";
            this.btnTasSpuPath.UseVisualStyleBackColor = true;
            this.btnTasSpuPath.Click += new System.EventHandler(this.btnTasSpu_Click);
            // 
            // btnPcsxrrPath
            // 
            this.btnPcsxrrPath.Font = new System.Drawing.Font("Microsoft Sans Serif", 6.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnPcsxrrPath.Location = new System.Drawing.Point(855, 49);
            this.btnPcsxrrPath.Name = "btnPcsxrrPath";
            this.btnPcsxrrPath.Size = new System.Drawing.Size(39, 22);
            this.btnPcsxrrPath.TabIndex = 13;
            this.btnPcsxrrPath.Text = "Pick";
            this.btnPcsxrrPath.UseVisualStyleBackColor = true;
            this.btnPcsxrrPath.Click += new System.EventHandler(this.btnPcsxrrPath_Click);
            // 
            // btnMoviePath
            // 
            this.btnMoviePath.Font = new System.Drawing.Font("Microsoft Sans Serif", 6.8F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnMoviePath.Location = new System.Drawing.Point(855, 21);
            this.btnMoviePath.Name = "btnMoviePath";
            this.btnMoviePath.Size = new System.Drawing.Size(39, 22);
            this.btnMoviePath.TabIndex = 12;
            this.btnMoviePath.Text = "Pick";
            this.btnMoviePath.UseVisualStyleBackColor = true;
            this.btnMoviePath.Click += new System.EventHandler(this.btnMoviePath_Click);
            // 
            // lblEternalSpuPath
            // 
            this.lblEternalSpuPath.AutoSize = true;
            this.lblEternalSpuPath.Location = new System.Drawing.Point(19, 107);
            this.lblEternalSpuPath.Name = "lblEternalSpuPath";
            this.lblEternalSpuPath.Size = new System.Drawing.Size(122, 17);
            this.lblEternalSpuPath.TabIndex = 9;
            this.lblEternalSpuPath.Text = "Eternal SPU Path:";
            // 
            // txtEternalSpuPath
            // 
            this.txtEternalSpuPath.Location = new System.Drawing.Point(139, 107);
            this.txtEternalSpuPath.Name = "txtEternalSpuPath";
            this.txtEternalSpuPath.Size = new System.Drawing.Size(710, 22);
            this.txtEternalSpuPath.TabIndex = 8;
            // 
            // lblTasSpuPath
            // 
            this.lblTasSpuPath.AutoSize = true;
            this.lblTasSpuPath.Location = new System.Drawing.Point(19, 78);
            this.lblTasSpuPath.Name = "lblTasSpuPath";
            this.lblTasSpuPath.Size = new System.Drawing.Size(104, 17);
            this.lblTasSpuPath.TabIndex = 7;
            this.lblTasSpuPath.Text = "TAS SPU Path:";
            // 
            // txtTasSpuPath
            // 
            this.txtTasSpuPath.Location = new System.Drawing.Point(139, 78);
            this.txtTasSpuPath.Name = "txtTasSpuPath";
            this.txtTasSpuPath.Size = new System.Drawing.Size(710, 22);
            this.txtTasSpuPath.TabIndex = 6;
            // 
            // lblKKapturePath
            // 
            this.lblKKapturePath.AutoSize = true;
            this.lblKKapturePath.Location = new System.Drawing.Point(19, 167);
            this.lblKKapturePath.Name = "lblKKapturePath";
            this.lblKKapturePath.Size = new System.Drawing.Size(104, 17);
            this.lblKKapturePath.TabIndex = 5;
            this.lblKKapturePath.Text = ".kkapture Path:";
            // 
            // txtKKapturePath
            // 
            this.txtKKapturePath.Location = new System.Drawing.Point(139, 167);
            this.txtKKapturePath.Name = "txtKKapturePath";
            this.txtKKapturePath.Size = new System.Drawing.Size(710, 22);
            this.txtKKapturePath.TabIndex = 4;
            // 
            // lblMoviePath
            // 
            this.lblMoviePath.AutoSize = true;
            this.lblMoviePath.Location = new System.Drawing.Point(19, 26);
            this.lblMoviePath.Name = "lblMoviePath";
            this.lblMoviePath.Size = new System.Drawing.Size(82, 17);
            this.lblMoviePath.TabIndex = 3;
            this.lblMoviePath.Text = "Movie Path:";
            // 
            // txtMoviePath
            // 
            this.txtMoviePath.Location = new System.Drawing.Point(139, 21);
            this.txtMoviePath.Name = "txtMoviePath";
            this.txtMoviePath.Size = new System.Drawing.Size(710, 22);
            this.txtMoviePath.TabIndex = 2;
            // 
            // lblPcsxrrPath
            // 
            this.lblPcsxrrPath.AutoSize = true;
            this.lblPcsxrrPath.Location = new System.Drawing.Point(19, 49);
            this.lblPcsxrrPath.Name = "lblPcsxrrPath";
            this.lblPcsxrrPath.Size = new System.Drawing.Size(84, 17);
            this.lblPcsxrrPath.TabIndex = 1;
            this.lblPcsxrrPath.Text = "Pcsxrr Path:";
            // 
            // txtPcsxrrPath
            // 
            this.txtPcsxrrPath.Location = new System.Drawing.Point(139, 49);
            this.txtPcsxrrPath.Name = "txtPcsxrrPath";
            this.txtPcsxrrPath.Size = new System.Drawing.Size(710, 22);
            this.txtPcsxrrPath.TabIndex = 0;
            // 
            // grpWorkFlow
            // 
            this.grpWorkFlow.Controls.Add(this.lstWorkflowStatus);
            this.grpWorkFlow.Controls.Add(this.btnStartSync);
            this.grpWorkFlow.Controls.Add(this.lblStatus);
            this.grpWorkFlow.Controls.Add(this.btnStartWorkflow);
            this.grpWorkFlow.Location = new System.Drawing.Point(12, 283);
            this.grpWorkFlow.Name = "grpWorkFlow";
            this.grpWorkFlow.Size = new System.Drawing.Size(910, 116);
            this.grpWorkFlow.TabIndex = 4;
            this.grpWorkFlow.TabStop = false;
            this.grpWorkFlow.Text = "WorkFlow";
            // 
            // btnStartSync
            // 
            this.btnStartSync.Location = new System.Drawing.Point(361, 15);
            this.btnStartSync.Name = "btnStartSync";
            this.btnStartSync.Size = new System.Drawing.Size(188, 23);
            this.btnStartSync.TabIndex = 11;
            this.btnStartSync.Text = "Start Sync";
            this.btnStartSync.UseVisualStyleBackColor = true;
            this.btnStartSync.Click += new System.EventHandler(this.btnStartSync_Click);
            // 
            // lblStatus
            // 
            this.lblStatus.AutoSize = true;
            this.lblStatus.Location = new System.Drawing.Point(6, 21);
            this.lblStatus.Name = "lblStatus";
            this.lblStatus.Size = new System.Drawing.Size(115, 17);
            this.lblStatus.TabIndex = 10;
            this.lblStatus.Text = "WorkFlow status:";
            // 
            // btnStartWorkflow
            // 
            this.btnStartWorkflow.Location = new System.Drawing.Point(139, 15);
            this.btnStartWorkflow.Name = "btnStartWorkflow";
            this.btnStartWorkflow.Size = new System.Drawing.Size(188, 23);
            this.btnStartWorkflow.TabIndex = 0;
            this.btnStartWorkflow.Text = "Start WorkFlow";
            this.btnStartWorkflow.UseVisualStyleBackColor = true;
            this.btnStartWorkflow.Click += new System.EventHandler(this.btnStartWorkflow_Click);
            // 
            // lstWorkflowStatus
            // 
            this.lstWorkflowStatus.Location = new System.Drawing.Point(9, 41);
            this.lstWorkflowStatus.Multiline = true;
            this.lstWorkflowStatus.Name = "lstWorkflowStatus";
            this.lstWorkflowStatus.Size = new System.Drawing.Size(885, 66);
            this.lstWorkflowStatus.TabIndex = 9;
            // 
            // lstInfoDetect
            // 
            this.lstInfoDetect.Location = new System.Drawing.Point(9, 47);
            this.lstInfoDetect.Multiline = true;
            this.lstInfoDetect.Name = "lstInfoDetect";
            this.lstInfoDetect.Size = new System.Drawing.Size(392, 92);
            this.lstInfoDetect.TabIndex = 12;
            // 
            // lstInfoSync
            // 
            this.lstInfoSync.Location = new System.Drawing.Point(9, 42);
            this.lstInfoSync.Multiline = true;
            this.lstInfoSync.Name = "lstInfoSync";
            this.lstInfoSync.Size = new System.Drawing.Size(392, 92);
            this.lstInfoSync.TabIndex = 13;
            // 
            // frmWorkFlowPannel
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(934, 690);
            this.Controls.Add(this.grpWorkFlow);
            this.Controls.Add(this.grpSetting);
            this.Controls.Add(this.grpSync);
            this.Controls.Add(this.grpDetect);
            this.Name = "frmWorkFlowPannel";
            this.Text = "WorkFlowPannel";
            this.grpDetect.ResumeLayout(false);
            this.grpDetect.PerformLayout();
            this.grpSync.ResumeLayout(false);
            this.grpSync.PerformLayout();
            this.grpSetting.ResumeLayout(false);
            this.grpSetting.PerformLayout();
            this.grpWorkFlow.ResumeLayout(false);
            this.grpWorkFlow.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button btnLoadSavestateDetect;
        private System.Windows.Forms.GroupBox grpDetect;
        private System.Windows.Forms.ComboBox cboSavestateDetect;
        private System.Windows.Forms.Label lvlSavestateDetect;
        private System.Windows.Forms.GroupBox grpSync;
        private System.Windows.Forms.ComboBox cboSavestateSync;
        private System.Windows.Forms.Button btnLoadSaveStateSync;
        private System.Windows.Forms.Label lblSavestateSync;
        private System.Windows.Forms.CheckBox chkLastFrameMovie;
        private System.Windows.Forms.Label lblDetectSatus;
        private System.Windows.Forms.Label lblSyncStatus;
        private System.Windows.Forms.GroupBox grpSetting;
        private System.Windows.Forms.Label lblTasSpuPath;
        private System.Windows.Forms.TextBox txtTasSpuPath;
        private System.Windows.Forms.Label lblKKapturePath;
        private System.Windows.Forms.TextBox txtKKapturePath;
        private System.Windows.Forms.Label lblMoviePath;
        private System.Windows.Forms.TextBox txtMoviePath;
        private System.Windows.Forms.Label lblPcsxrrPath;
        private System.Windows.Forms.TextBox txtPcsxrrPath;
        private System.Windows.Forms.Label lblWorkflowPath;
        private System.Windows.Forms.TextBox txtWorkflowPath;
        private System.Windows.Forms.Label lblEternalSpuPath;
        private System.Windows.Forms.TextBox txtEternalSpuPath;
        private System.Windows.Forms.GroupBox grpWorkFlow;
        private System.Windows.Forms.Label lblStatus;
        private System.Windows.Forms.Button btnStartWorkflow;
        private System.Windows.Forms.Button btnKKapturePath;
        private System.Windows.Forms.Button btnWorkflowPath;
        private System.Windows.Forms.Button btnEternalSpuPath;
        private System.Windows.Forms.Button btnTasSpuPath;
        private System.Windows.Forms.Button btnPcsxrrPath;
        private System.Windows.Forms.Button btnMoviePath;
        private System.Windows.Forms.Button btnSaveProfile;
        private System.Windows.Forms.Button btnLuaScriptPath;
        private System.Windows.Forms.Label lblLuaScriptPath;
        private System.Windows.Forms.TextBox txtLuaScriptPath;
        private System.Windows.Forms.CheckBox chkCreateWorkflowFolder;
        private System.Windows.Forms.Button btnStartSync;
        private System.Windows.Forms.TextBox lstInfoDetect;
        private System.Windows.Forms.TextBox lstInfoSync;
        private System.Windows.Forms.TextBox lstWorkflowStatus;
    }
}

