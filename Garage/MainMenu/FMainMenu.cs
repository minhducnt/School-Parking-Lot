using System;
using System.Windows.Forms;

namespace Garage
{
    public partial class FMainMenu : Form
    {
        private static FMainMenu Mainmenu;
        private readonly FParking _baidau = new();
        private readonly FStaff _nhanvien = new();
        private readonly FTicket _thexe = new();
        private readonly FAbout _thongtin = new();

        private Form _activeForm;

        public FMainMenu()
        {
            InitializeComponent();
            Mainmenu = this;
        }

        #region Event

        private void FMainMenu_Load(object sender, EventArgs e)
        {
            AnimatedWindow.TargetForm = this;
        }

        #endregion

        private void btGarage_Click(object sender, EventArgs e)
        {
            OpenChildForm(_thexe);
        }

        private void btStaff_Click(object sender, EventArgs e)
        {
            OpenChildForm(_nhanvien);
        }

        private void btnAbout_Click(object sender, EventArgs e)
        {
            OpenChildForm(_thongtin);
        }

        private void btParking_Click(object sender, EventArgs e)
        {
            OpenChildForm(_baidau);
        }

        private void btExit_Click(object sender, EventArgs e)
        {
            Hide();
            var h = new FLogin();
            h.ShowDialog();
        }

        #region Method

        private void OpenChildForm(Form childForm)
        {
            _activeForm?.Hide();
            _activeForm = childForm;
            childForm.TopLevel = false;
            childForm.FormBorderStyle = FormBorderStyle.None;
            childForm.Dock = DockStyle.Fill;
            panelChildForm.Controls.Add(childForm);
            panelChildForm.Tag = childForm;
            childForm.BringToFront();
            childForm.Show();
        }

        #endregion

        private void cBox1_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }
    }
}