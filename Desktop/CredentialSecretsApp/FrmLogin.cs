using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace CredentialSecretsApp
{
    public partial class FrmLogin : Form
    {
        public string Username { get; private set; }
        public string Password { get; private set; }

        public FrmLogin()
        {
            InitializeComponent();
            txtUsername.Text = Username;
            txtPassword.Text = Password;
        }

        private void btnLogin_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtUsername.Text) || string.IsNullOrWhiteSpace(txtPassword.Text))
            {
                MessageBox.Show("Please enter both username and password.", "Login Failed", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            Username = txtUsername.Text;
            Password = txtPassword.Text;

            DialogResult = DialogResult.OK;
        }
    }
}
