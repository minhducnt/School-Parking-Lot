using System;
using System.Data.SqlClient;
using System.Globalization;
using System.Windows.Forms;
using BUL;
using PUBLIC;

namespace Garage
{
    public partial class FCustomer : Form
    {
        private readonly CustomerBul _khBul = new();
        private int _makh;
        private bool _nutThem, _nutSua;

        public FCustomer()
        {
            CheckForIllegalCrossThreadCalls = false;
            InitializeComponent();
        }

        #region Method

        private void Xulybuttion(bool b)
        {
            btThem.Enabled = dg_khachhang.Enabled = btSua.Enabled = btXoa.Enabled = btlammoi.Enabled = b;
            btLuu.Enabled = btHuy.Enabled = !b;
        }

        private void Mo()
        {
            txtmakh.ReadOnly = false;
            datengaylamthe.Enabled = true;
            datengayhethan.Enabled = true;
        }

        private void Tat()
        {
            txtmakh.ReadOnly = true;
            datengaylamthe.Enabled = false;
            datengayhethan.Enabled = false;
        }

        private void LoadDataGrid()
        {
            bindingSource1.DataSource = _khBul.load_customer();
            dg_khachhang.DataSource = bindingSource1;
        }

        private void EditDataGrid()
        {
            dg_khachhang.ReadOnly = true;
            dg_khachhang.Columns[0].HeaderText = @"Mã khách hàng";
            dg_khachhang.Columns[1].HeaderText = @"Ngày làm thẻ";
            dg_khachhang.Columns[2].HeaderText = @"Ngày hết hạn";
        }

        private void InsertCustomer()
        {
            _makh = int.Parse(txtmakh.Text);
            var customerPublic = new CustomerPublic
            {
                CID = _makh,
                NGAYAMTHE = DateTime.Parse(datengaylamthe.Text),
                NGAYHETHAN = DateTime.Parse(datengayhethan.Text)
            };
            _khBul.insert_customer(customerPublic);
        }


        private void UpdateCustomer()
        {
            var customerPublic = new CustomerPublic
            {
                CID = int.Parse(txtmakh.Text),
                NGAYAMTHE = DateTime.Parse(datengaylamthe.Text),
                NGAYHETHAN = DateTime.Parse(datengayhethan.Text)
            };
            _khBul.update_customer(customerPublic);
        }


        private void DeleteCustomer()
        {
            var customerPublic = new CustomerPublic {CID = int.Parse(txtmakh.Text)};
            _khBul.delete_customer(customerPublic);
        }

        private void DeleteCustomer_Error()
        {
            var staffPublic = new CustomerPublic {CID = int.Parse(txtmakh.Text)};
            _khBul.delete_customer(staffPublic);
        }

        private void Clear()
        {
            txtmakh.Clear();
            datengaylamthe.ResetText();
            datengayhethan.ResetText();
        }

        #endregion

        #region Event

        private void FCustomer_Load(object sender, EventArgs e)
        {
            Xulybuttion(true);
            LoadDataGrid();
            EditDataGrid();
            dg_khachhang.Rows[0].Selected = true;
            txtmakh.ReadOnly = true;
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
            Xulybuttion(false);
        }

        private void btXoa_Click(object sender, EventArgs e)
        {
            if (DialogResult.Yes == MessageBox.Show(@"Muốn xóa một khách hàng?", @"Thông báo", MessageBoxButtons.YesNo,
                MessageBoxIcon.Question))
                try
                {
                    DeleteCustomer();
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
                else if (datengaylamthe.Value.ToString(CultureInfo.CurrentCulture) == "")
                    MessageBox.Show(@"Chưa chọn ngày làm thẻ.", @"Thông báo", MessageBoxButtons.OK,
                        MessageBoxIcon.Warning);
                else if (datengayhethan.Value.ToString(CultureInfo.CurrentCulture) == "")
                    MessageBox.Show(@"Chưa chọn ngày hết hạn.", @"Thông báo", MessageBoxButtons.OK,
                        MessageBoxIcon.Warning);
                else
                    try
                    {
                        _nutThem = false;
                        InsertCustomer();
                        LoadDataGrid();
                        Tat();
                        Xulybuttion(true);
                    }
                    catch (SqlException loi)
                    {
                        if (loi.Message.Contains("Violation of PRIMARY KEY constraint 'PK_TENTK'"))
                        {
                            MessageBox.Show(@"Mã khách hàng bị trùng.", @"Thông báo", MessageBoxButtons.OK,
                                MessageBoxIcon.Warning);
                            DeleteCustomer_Error();
                            _nutThem = true;
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
                else if (datengaylamthe.Value.ToString(CultureInfo.CurrentCulture) == "")
                    MessageBox.Show(@"Chưa chọn ngày làm thẻ.", @"Thông báo", MessageBoxButtons.OK,
                        MessageBoxIcon.Warning);
                else if (datengayhethan.Value.ToString(CultureInfo.CurrentCulture) == "")
                    MessageBox.Show(@"Chưa chọn ngày hết hạn.", @"Thông báo", MessageBoxButtons.OK,
                        MessageBoxIcon.Warning);
                else
                    try
                    {
                        UpdateCustomer();
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

        private void dg_khachhang_RowEnter(object sender, DataGridViewCellEventArgs e)
        {
            try
            {
                var dong = e.RowIndex;
                txtmakh.Text = dg_khachhang.Rows[dong].Cells[0].Value == null
                    ? string.Empty
                    : dg_khachhang.Rows[dong].Cells[0].Value.ToString().Trim();
                datengaylamthe.Text = dg_khachhang.Rows[dong].Cells[1].Value == null
                    ? string.Empty
                    : dg_khachhang.Rows[dong].Cells[1].Value.ToString().Trim();
                datengayhethan.Text = dg_khachhang.Rows[dong].Cells[2].Value == null
                    ? string.Empty
                    : dg_khachhang.Rows[dong].Cells[2].Value.ToString().Trim();
            }
            catch
            {
                // ignored
            }
        }

        private void btlammoi_Click(object sender, EventArgs e)
        {
            dg_khachhang.DataSource = _khBul.load_customer();
            LoadDataGrid();
            Tat();
            Xulybuttion(true);
        }

        private void dg_khachhang_DataError(object sender, DataGridViewDataErrorEventArgs e)
        {
        }

        #endregion
    }
}