using System;
using System.Data.SqlClient;
using System.Globalization;
using System.Windows.Forms;
using BUL;
using PUBLIC;

namespace Garage
{
    public partial class FTicket : Form
    {
        private readonly TicketBul _tkBul = new();
        private Form _activeForm;
        private bool _nutThem, _nutSua;

        public FTicket()
        {
            CheckForIllegalCrossThreadCalls = false;
            InitializeComponent();
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

        private void Xulybuttion(bool b)
        {
            btThem.Enabled = dg_thexe.Enabled = bttim.Enabled = txttim.Enabled = btlammoi.Enabled =
                btSua.Enabled = btXoa.Enabled = b;
            btLuu.Enabled = btHuy.Enabled = !b;
        }

        private void Mo()
        {
            txtmakh.ReadOnly = false;
            txtmanv.ReadOnly = false;
            datengaygui.Enabled = true;
            timegiovao.Enabled = true;
            timegiora.Enabled = true;
            txttim.ReadOnly = true;
            datetim.Enabled = false;
        }

        private void Tat()
        {
            txtmakh.ReadOnly = true;
            txtmanv.ReadOnly = true;
            datengaygui.Enabled = false;
            timegiovao.Enabled = false;
            timegiora.Enabled = false;
            txttim.ReadOnly = false;
            datetim.Enabled = true;
        }

        private void LoadDataGrid()
        {
            bindingSource1.DataSource = _tkBul.load_ticket();
            dg_thexe.DataSource = bindingSource1;
        }

        private void EditDataGrid()
        {
            dg_thexe.ReadOnly = true;
            dg_thexe.Columns[0].HeaderText = @"Mã khách hàng";
            dg_thexe.Columns[1].HeaderText = @"Mã nhân viên";
            dg_thexe.Columns[2].HeaderText = @"Ngày gửi";
            dg_thexe.Columns[3].HeaderText = @"Giờ vào";
            dg_thexe.Columns[4].HeaderText = @"Giờ ra";
        }

        private void InsertTicket()
        {
            var ticketPublic = new TicketPublic
            {
                CID = int.Parse(txtmakh.Text),
                EID = int.Parse(txtmanv.Text),
                NGAYGUI = DateTime.Parse(datengaygui.Text),
                GIOVAO = DateTime.Parse(timegiovao.Text),
                GIORA = DateTime.Parse(timegiora.Text)
            };
            _tkBul.insert_ticket(ticketPublic);
        }

        private void UpdateTicket()
        {
            var ticketPublic = new TicketPublic
            {
                CID = int.Parse(txtmakh.Text),
                EID = int.Parse(txtmanv.Text),
                NGAYGUI = DateTime.Parse(datengaygui.Text),
                GIOVAO = DateTime.Parse(timegiovao.Text),
                GIORA = DateTime.Parse(timegiora.Text)
            };
            _tkBul.update_ticket(ticketPublic);
        }

        private void DeleteTicket()
        {
            var ticketPublic = new TicketPublic {CID = int.Parse(txtmakh.Text)};
            _tkBul.delete_ticket(ticketPublic);
        }

        private void Clear()
        {
            txtmakh.Clear();
            txtmanv.Clear();
            datengaygui.ResetText();
            timegiovao.ResetText();
            timegiora.ResetText();
        }

        #endregion

        #region Event

        private void FTicket_Load(object sender, EventArgs e)
        {
            Xulybuttion(true);
            LoadDataGrid();
            EditDataGrid();
            dg_thexe.Rows[0].Selected = true;
            txtmanv.ReadOnly = true;
            txtmakh.ReadOnly = true;
            timegiovao.ShowUpDown = true;
            timegiora.ShowUpDown = true;
            Tat();
        }

        private void btThem_Click(object sender, EventArgs e)
        {
            _nutThem = true;
            Mo();
            Xulybuttion(false);
            txtmakh.Focus();
            Clear();
        }

        private void btSua_Click(object sender, EventArgs e)
        {
            _nutSua = true;
            Mo();
            txtmakh.ReadOnly = true;
            txtmanv.ReadOnly = true;
            Xulybuttion(false);
        }

        private void btXoa_Click(object sender, EventArgs e)
        {
            if (DialogResult.Yes == MessageBox.Show(@"Muốn xóa một thẻ xe?", @"Thông báo", MessageBoxButtons.YesNo,
                MessageBoxIcon.Question))
                try
                {
                    DeleteTicket();
                    LoadDataGrid();
                }
                catch (SqlException loi)
                {
                    MessageBox.Show(loi.Message, @"Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    LoadDataGrid();
                    Tat();
                    Xulybuttion(true);
                }
        }

        private void btLuu_Click(object sender, EventArgs e)
        {
            if (_nutThem)
            {
                if (txtmakh.TextLength == 0)
                    MessageBox.Show(@"Chưa điền mã khách hàng.", @"Thông báo", MessageBoxButtons.OK,
                        MessageBoxIcon.Warning);
                if (txtmanv.TextLength == 0)
                    MessageBox.Show(@"Chưa điền mã nhân viên.", @"Thông báo", MessageBoxButtons.OK,
                        MessageBoxIcon.Warning);
                else if (datengaygui.Value.ToString(CultureInfo.CurrentCulture) == "")
                    MessageBox.Show(@"Chưa chọn ngày gửi.", @"Thông báo", MessageBoxButtons.OK,
                        MessageBoxIcon.Warning);
                else if (timegiovao.Value.ToString(CultureInfo.CurrentCulture) == "")
                    MessageBox.Show(@"Chưa chọn giờ vào.", @"Thông báo", MessageBoxButtons.OK,
                        MessageBoxIcon.Warning);
                else if (timegiora.Value.ToString(CultureInfo.CurrentCulture) == "")
                    MessageBox.Show(@"Chưa chọn giờ ra.", @"Thông báo", MessageBoxButtons.OK,
                        MessageBoxIcon.Warning);
                else
                    try
                    {
                        _nutThem = false;
                        InsertTicket();
                        LoadDataGrid();
                        Tat();
                        Xulybuttion(true);
                    }
                    catch (SqlException loi)
                    {
                        if (loi.Message.Contains("PRIMARY KEY"))
                        {
                            MessageBox.Show(@"Ma khach hang va nhan vien trung nhau.", @"Thông báo", MessageBoxButtons.OK,
                                MessageBoxIcon.Warning);
                            LoadDataGrid();
                            Tat();
                            Xulybuttion(true);
                        }
                        else if (loi.Message.Contains("Cid"))
                        {
                            MessageBox.Show(@"Khach hang khong ton tai", @"Thông báo", MessageBoxButtons.OK,
                                MessageBoxIcon.Warning);
                            LoadDataGrid();
                            Tat();
                            Xulybuttion(true);
                        }
                        else if (loi.Message.Contains("Eid"))
                        {
                            MessageBox.Show(@"Nhan vien khong thuoc ca truc", @"Thông báo", MessageBoxButtons.OK,
                                MessageBoxIcon.Warning);
                            LoadDataGrid();
                            Tat();
                            Xulybuttion(true);
                        }
                        else if (loi.Message.Contains("REFERENCE"))
                        {
                            MessageBox.Show(@"Ngay nha xe khong hoat dong", @"Thông báo", MessageBoxButtons.OK,
                                MessageBoxIcon.Warning);
                            LoadDataGrid();
                            Tat();
                            Xulybuttion(true);
                        }
                        else
                        {
                            MessageBox.Show(loi.Message, @"Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            LoadDataGrid();
                            Tat();
                            Xulybuttion(true);
                        }
                    }
            }
            else if (_nutSua)
            {
                if (txtmakh.TextLength == 0)
                    MessageBox.Show(@"Chưa điền mã khách hàng.", @"Thông báo", MessageBoxButtons.OK,
                        MessageBoxIcon.Warning);
                if (txtmanv.TextLength == 0)
                    MessageBox.Show(@"Chưa điền mã nhân viên.", @"Thông báo", MessageBoxButtons.OK,
                        MessageBoxIcon.Warning);
                else if (datengaygui.Value.ToString(CultureInfo.CurrentCulture) == "")
                    MessageBox.Show(@"Chưa chọn ngày gửi.", @"Thông báo", MessageBoxButtons.OK,
                        MessageBoxIcon.Warning);
                else if (timegiovao.Value.ToString(CultureInfo.CurrentCulture) == "")
                    MessageBox.Show(@"Chưa chọn giờ vào.", @"Thông báo", MessageBoxButtons.OK,
                        MessageBoxIcon.Warning);
                else if (timegiora.Value.ToString(CultureInfo.CurrentCulture) == "")
                    MessageBox.Show(@"Chưa chọn giờ ra.", @"Thông báo", MessageBoxButtons.OK,
                        MessageBoxIcon.Warning);
                else
                    try
                    {
                        UpdateTicket();

                        Tat();
                        Xulybuttion(true);
                        _nutSua = false;
                        LoadDataGrid();
                    }
                    catch (SqlException loi)
                    {
                        MessageBox.Show(loi.Message, @"Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                        LoadDataGrid();
                        Tat();
                        Xulybuttion(true);
                    }
            }
        }

        private void btHuy_Click(object sender, EventArgs e)
        {
            if (_nutThem)
            {
                LoadDataGrid();
                Xulybuttion(true);
                Tat();
                _nutThem = false;
            }
            else if (_nutSua)
            {
                Tat();
                Xulybuttion(true);
                _nutSua = false;
            }
        }

        private void btnBack_Click(object sender, EventArgs e)
        {
            Hide();
        }

        private void dg_thexe_RowEnter(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                var dong = e.RowIndex;
                txtmakh.Text = dg_thexe.Rows[dong].Cells[0].Value == null
                    ? string.Empty
                    : dg_thexe.Rows[dong].Cells[0].Value.ToString().Trim();

                txtmanv.Text = dg_thexe.Rows[dong].Cells[1].Value == null
                    ? string.Empty
                    : dg_thexe.Rows[dong].Cells[1].Value.ToString().Trim();

                datengaygui.Text = dg_thexe.Rows[dong].Cells[2].Value == null
                    ? string.Empty
                    : dg_thexe.Rows[dong].Cells[2].Value.ToString();

                timegiovao.Text = dg_thexe.Rows[dong].Cells[3].Value == null
                    ? string.Empty
                    : dg_thexe.Rows[dong].Cells[3].Value.ToString();

                timegiora.Text = dg_thexe.Rows[dong].Cells[4].Value == null
                    ? string.Empty
                    : dg_thexe.Rows[dong].Cells[4].Value.ToString();
            }
            catch
            {
                // ignored
            }
        }

        private void dg_thexe_DataError(object sender, DataGridViewDataErrorEventArgs e)
        {
        }

        private void bttim_Click(object sender, EventArgs e)
        {
            if (txttim.TextLength == 0)
            {
                MessageBox.Show(@"Chưa nhập Id khu vực cần tìm.", @"Thông báo", MessageBoxButtons.OK,
                    MessageBoxIcon.Warning);
            }
            else if (datetim.Value.ToString(CultureInfo.CurrentCulture) == "")
            {
                MessageBox.Show(@"Chưa chọn ngày cần tìm.", @"Thông báo", MessageBoxButtons.OK,
                    MessageBoxIcon.Warning);
            }
            else
            {
                var areaId = int.Parse(txttim.Text);
                var date = DateTime.Parse(datetim.Text);
                dg_thexe.DataSource = _tkBul.find_ticket_areaId(date, areaId);
                EditDataGrid();
                dg_thexe.Columns[5].HeaderText = @"Khu làm việc";
            }
        }

        private void btlammoi_Click(object sender, EventArgs e)
        {
            dg_thexe.DataSource = _tkBul.load_ticket();
            datetim.ResetText();
            Tat();
        }

        private void btCustomer_Click(object sender, EventArgs e)
        {
            OpenChildForm(new FCustomer());
        }

        #endregion
    }
}