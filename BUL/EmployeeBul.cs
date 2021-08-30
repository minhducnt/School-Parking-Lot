using System.Data;
using DAL;
using PUBLIC;

namespace BUL
{
    public class EmployeeBul
    {
        private readonly EmployeeDal _employeeDal = new();

        public DataTable load_employee()
        {
            return _employeeDal.load_employee();
        }

        public int insert_employee(EmployeePublic employeePublic)
        {
            return _employeeDal.insert_employee(employeePublic);
        }

        public int update_employee(EmployeePublic employeePublic)
        {
            return _employeeDal.update_employee(employeePublic);
        }

        public int delete_employee(EmployeePublic employeePublic)
        {
            return _employeeDal.delete_employee(employeePublic);
        }

        public int count_employee()
        {
            return _employeeDal.count_employee();
        }

        public DataTable find_employee(int areaId)
        {
            return _employeeDal.find_employee(areaId);
        }
    }
}