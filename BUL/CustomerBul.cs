using System.Data;
using DAL;
using PUBLIC;

namespace BUL
{
    public class CustomerBul
    {
        private readonly CustomerDal _customerDal = new();

        public DataTable load_customer()
        {
            return _customerDal.load_customer();
        }

        public int insert_customer(CustomerPublic customerPublic)
        {
            return _customerDal.insert_customer(customerPublic);
        }

        public int update_customer(CustomerPublic customerPublic)
        {
            return _customerDal.update_customer(customerPublic);
        }

        public int delete_customer(CustomerPublic customerPublic)
        {
            return _customerDal.delete_customer(customerPublic);
        }

        public int count_customer()
        {
            return _customerDal.count_customer();
        }
    }
}