using System;
using System.Windows.Forms;

namespace Garage
{
    public partial class FLoading : Form
    {
        public FLoading()
        {
            InitializeComponent();
        }

        private void FLoading_Load(object sender, EventArgs e)
        {
            timer.Start();
        }

        private void timer_Tick(object sender, EventArgs e)
        {
            if (ProgressBar.Value == 100)
            {
                timer.Stop();
                Hide();
                var f = new FMainMenu();
                f.Show();
            }
            else
            {
                ProgressBar.Increment(5);
                label_val.Text = (Convert.ToInt32(label_val.Text) + 1).ToString();
            }
        }
    }
}