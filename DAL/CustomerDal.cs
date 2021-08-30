using System.Data;
using PUBLIC;

namespace DAL
{
    public class CustomerDal
    {
        private readonly DataProvider _conn = new();

        public DataTable load_customer()
        {
            var sql = @"LoadCustomer";
            return _conn.Load_Data(sql);
        }

        public int insert_customer(CustomerPublic customerPublic)
        {
            var parameter = 3;
            var name = new string[parameter];
            var values = new object[parameter];
            name[0] = "@Cid";
            name[1] = "@NgayLamThe";
            name[2] = "@NgayHetHan";
            values[0] = customerPublic.CID;
            values[1] = customerPublic.NGAYAMTHE;
            values[2] = customerPublic.NGAYHETHAN;
            var sql = "InputCustomer";
            return _conn.ExecuteData(sql, name, values, parameter);
        }

        public int update_customer(CustomerPublic customerPublic)
        {
            var parameter = 3;
            var name = new string[parameter];
            var values = new object[parameter];
            name[0] = "@Cid";
            name[1] = "@NgayLamThe";
            name[2] = "@NgayHetHan";
            values[0] = customerPublic.CID;
            values[1] = customerPublic.NGAYAMTHE;
            values[2] = customerPublic.NGAYHETHAN;
            var sql = "UpdateCustomer";
            return _conn.ExecuteData(sql, name, values, parameter);
        }

        public int delete_customer(CustomerPublic customerPublic)
        {
            var parameter = 1;
            var name = new string[parameter];
            var values = new object[parameter];
            name[0] = "@id";
            values[0] = customerPublic.CID;
            var sql = "DeleteCustomer";
            return _conn.ExecuteData(sql, name, values, parameter);
        }

        public int count_customer()
        {
            var sql = "CountCustomer";
            return _conn.ReturnValueInt(sql);
        }
    }
}