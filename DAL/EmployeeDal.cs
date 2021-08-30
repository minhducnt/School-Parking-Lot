using System.Data;
using PUBLIC;

namespace DAL
{
    public class EmployeeDal
    {
        private readonly DataProvider _conn = new();

        public DataTable load_employee()
        {
            var sql = @"LoadEmployee";
            return _conn.Load_Data(sql);
        }

        public int insert_employee(EmployeePublic employeePublic)
        {
            var parameter = 10;
            var name = new string[parameter];
            var values = new object[parameter];
            name[0] = "@Eid";
            name[1] = "@Name";
            name[2] = "@Birthday";
            name[3] = "@Address";
            name[4] = "@Phone";
            name[5] = "@Gender";
            name[6] = "@Area";
            name[7] = "@MG_id";
            name[8] = "@Base_Salary";
            name[9] = "@Password";
            values[0] = employeePublic.EID;
            values[1] = employeePublic.NAME;
            values[2] = employeePublic.BIRTHDAY;
            values[3] = employeePublic.ADDRESS;
            values[4] = employeePublic.PHONE;
            values[5] = employeePublic.GENDER;
            values[6] = employeePublic.AREA;
            values[7] = employeePublic.MANAGERID;
            values[8] = employeePublic.SALARY;
            values[9] = employeePublic.PASSWORD;
            var sql = "InputEmployee";
            return _conn.ExecuteData(sql, name, values, parameter);
        }

        public int update_employee(EmployeePublic employeePublic)
        {
            var parameter = 10;
            var name = new string[parameter];
            var values = new object[parameter];
            name[0] = "@Eid";
            name[1] = "@Name";
            name[2] = "@Birthday";
            name[3] = "@Address";
            name[4] = "@Phone";
            name[5] = "@Gender";
            name[6] = "@Area";
            name[7] = "@MG_id";
            name[8] = "@Base_Salary";
            name[9] = "@Password";
            values[0] = employeePublic.EID;
            values[1] = employeePublic.NAME;
            values[2] = employeePublic.BIRTHDAY;
            values[3] = employeePublic.ADDRESS;
            values[4] = employeePublic.PHONE;
            values[5] = employeePublic.GENDER;
            values[6] = employeePublic.AREA;
            values[7] = employeePublic.MANAGERID;
            values[8] = employeePublic.SALARY;
            values[9] = employeePublic.PASSWORD;
            var sql = "UpdateEmployee";
            return _conn.ExecuteData(sql, name, values, parameter);
        }

        public int delete_employee(EmployeePublic employeePublic)
        {
            var parameter = 1;
            var name = new string[parameter];
            var values = new object[parameter];
            name[0] = "@id";
            values[0] = employeePublic.EID;
            var sql = "DeleteEmployee";
            return _conn.ExecuteData(sql, name, values, parameter);
        }

        public int count_employee()
        {
            var sql = "CountEmployee";
            return _conn.ReturnValueInt(sql);
        }

        public DataTable find_employee(int areaId)
        {
            var parameter = 1;
            var name = new string[parameter];
            var values = new object[parameter];
            name[0] = "@id_area";
            values[0] = areaId;
            var sql = "FindEmployee";
            return _conn.LoadDataWithParameter(sql, name, values, parameter);
        }
    }
}