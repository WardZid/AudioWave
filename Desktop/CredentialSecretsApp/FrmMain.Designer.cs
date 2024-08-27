namespace CredentialSecretsApp
{
    partial class FrmMain
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            tableLayoutPanel1 = new TableLayoutPanel();
            label1 = new Label();
            label2 = new Label();
            lblConnectionStatus = new Label();
            btnGenerateKeys = new Button();
            label5 = new Label();
            txtPublicKey = new TextBox();
            txtPrivateKey = new TextBox();
            label3 = new Label();
            tableLayoutPanel1.SuspendLayout();
            SuspendLayout();
            // 
            // tableLayoutPanel1
            // 
            tableLayoutPanel1.ColumnCount = 2;
            tableLayoutPanel1.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50F));
            tableLayoutPanel1.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50F));
            tableLayoutPanel1.Controls.Add(label1, 0, 0);
            tableLayoutPanel1.Controls.Add(label2, 0, 1);
            tableLayoutPanel1.Controls.Add(lblConnectionStatus, 1, 1);
            tableLayoutPanel1.Controls.Add(btnGenerateKeys, 0, 5);
            tableLayoutPanel1.Controls.Add(label5, 0, 4);
            tableLayoutPanel1.Controls.Add(txtPublicKey, 1, 4);
            tableLayoutPanel1.Controls.Add(txtPrivateKey, 1, 3);
            tableLayoutPanel1.Controls.Add(label3, 0, 3);
            tableLayoutPanel1.Dock = DockStyle.Fill;
            tableLayoutPanel1.Location = new Point(0, 0);
            tableLayoutPanel1.Name = "tableLayoutPanel1";
            tableLayoutPanel1.RowCount = 6;
            tableLayoutPanel1.RowStyles.Add(new RowStyle(SizeType.Absolute, 60F));
            tableLayoutPanel1.RowStyles.Add(new RowStyle(SizeType.Absolute, 60F));
            tableLayoutPanel1.RowStyles.Add(new RowStyle(SizeType.Absolute, 20F));
            tableLayoutPanel1.RowStyles.Add(new RowStyle(SizeType.Absolute, 120F));
            tableLayoutPanel1.RowStyles.Add(new RowStyle(SizeType.Absolute, 120F));
            tableLayoutPanel1.RowStyles.Add(new RowStyle(SizeType.Absolute, 60F));
            tableLayoutPanel1.Size = new Size(971, 473);
            tableLayoutPanel1.TabIndex = 1;
            // 
            // label1
            // 
            label1.AutoSize = true;
            tableLayoutPanel1.SetColumnSpan(label1, 2);
            label1.Dock = DockStyle.Fill;
            label1.Font = new Font("Segoe UI", 14.1428576F, FontStyle.Bold, GraphicsUnit.Point, 0);
            label1.Location = new Point(3, 0);
            label1.Name = "label1";
            label1.Size = new Size(965, 60);
            label1.TabIndex = 0;
            label1.Text = "AudioWave Credential Encryption Secret Manager";
            label1.TextAlign = ContentAlignment.MiddleCenter;
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Dock = DockStyle.Fill;
            label2.Font = new Font("Segoe UI Black", 9F, FontStyle.Bold);
            label2.Location = new Point(3, 60);
            label2.Name = "label2";
            label2.Size = new Size(479, 60);
            label2.TabIndex = 1;
            label2.Text = "Connection Status:";
            label2.TextAlign = ContentAlignment.MiddleCenter;
            // 
            // lblConnectionStatus
            // 
            lblConnectionStatus.AutoSize = true;
            lblConnectionStatus.BackColor = Color.LightCoral;
            lblConnectionStatus.Dock = DockStyle.Fill;
            lblConnectionStatus.Font = new Font("Segoe UI Black", 9F, FontStyle.Bold);
            lblConnectionStatus.Location = new Point(488, 60);
            lblConnectionStatus.Name = "lblConnectionStatus";
            lblConnectionStatus.Size = new Size(480, 60);
            lblConnectionStatus.TabIndex = 2;
            lblConnectionStatus.Text = "NOT CONNECTED";
            lblConnectionStatus.TextAlign = ContentAlignment.MiddleCenter;
            // 
            // btnGenerateKeys
            // 
            tableLayoutPanel1.SetColumnSpan(btnGenerateKeys, 2);
            btnGenerateKeys.Dock = DockStyle.Bottom;
            btnGenerateKeys.Location = new Point(3, 414);
            btnGenerateKeys.Name = "btnGenerateKeys";
            btnGenerateKeys.Size = new Size(965, 56);
            btnGenerateKeys.TabIndex = 3;
            btnGenerateKeys.Text = "Generate New Keys";
            btnGenerateKeys.UseVisualStyleBackColor = true;
            btnGenerateKeys.Click += btnGenerateKeys_Click;
            // 
            // label5
            // 
            label5.AutoSize = true;
            label5.Dock = DockStyle.Fill;
            label5.Font = new Font("Segoe UI Black", 9F, FontStyle.Bold);
            label5.Location = new Point(3, 260);
            label5.Name = "label5";
            label5.Size = new Size(479, 120);
            label5.TabIndex = 6;
            label5.Text = "Public Key:";
            label5.TextAlign = ContentAlignment.MiddleCenter;
            // 
            // txtPublicKey
            // 
            txtPublicKey.Dock = DockStyle.Fill;
            txtPublicKey.Location = new Point(488, 263);
            txtPublicKey.Multiline = true;
            txtPublicKey.Name = "txtPublicKey";
            txtPublicKey.ReadOnly = true;
            txtPublicKey.Size = new Size(480, 114);
            txtPublicKey.TabIndex = 8;
            // 
            // txtPrivateKey
            // 
            txtPrivateKey.Dock = DockStyle.Fill;
            txtPrivateKey.Location = new Point(488, 143);
            txtPrivateKey.Multiline = true;
            txtPrivateKey.Name = "txtPrivateKey";
            txtPrivateKey.ReadOnly = true;
            txtPrivateKey.Size = new Size(480, 114);
            txtPrivateKey.TabIndex = 7;
            // 
            // label3
            // 
            label3.AutoSize = true;
            label3.Dock = DockStyle.Fill;
            label3.Font = new Font("Segoe UI Black", 9F, FontStyle.Bold);
            label3.Location = new Point(3, 140);
            label3.Name = "label3";
            label3.Size = new Size(479, 120);
            label3.TabIndex = 4;
            label3.Text = "Private Key:";
            label3.TextAlign = ContentAlignment.MiddleCenter;
            // 
            // FrmMain
            // 
            AutoScaleDimensions = new SizeF(12F, 30F);
            AutoScaleMode = AutoScaleMode.Font;
            BackColor = SystemColors.ControlLight;
            ClientSize = new Size(971, 473);
            Controls.Add(tableLayoutPanel1);
            Name = "FrmMain";
            StartPosition = FormStartPosition.CenterScreen;
            Text = "AudioWave Credential Secrets";
            Load += FrmMain_Load;
            tableLayoutPanel1.ResumeLayout(false);
            tableLayoutPanel1.PerformLayout();
            ResumeLayout(false);
        }

        #endregion
        private TableLayoutPanel tableLayoutPanel1;
        private Label label1;
        private Label label2;
        private Label lblConnectionStatus;
        private Button btnGenerateKeys;
        private Label label5;
        private Label label3;
        private TextBox txtPrivateKey;
        private TextBox txtPublicKey;
    }
}
