using System;
using System.Windows.Forms;
using DAL;

namespace Garage
{
    public partial class FLogin : Form
    {
        private const int CpNocloseButton = 0x200;
        private readonly DataProvider _conn = new();

        public FLogin()
        {
            InitializeComponent();
        }

        private void FLogin_Load(object sender, EventArgs e)
        {
            txtUsername.Focus();
            AcceptButton = btnLogin;
        }

        private void lbClear_Click(object sender, EventArgs e)
        {
            txtUsername.Clear();
            txtPassword.Clear();
            txtUsername.Focus();
        }

        private void btnLogin_Click(object sender, EventArgs e)
        {
            Hide();
            var f = new FLoading();
            f.ShowDialog();
        }

        private void cBox1_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }
    }
}