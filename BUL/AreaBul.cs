using System.Data;
using DAL;
using PUBLIC;

namespace BUL
{
    public class AreaBul
    {
        private readonly AreaDal _areaDal = new();

        public DataTable load_area()
        {
            return _areaDal.load_area();
        }

        public int insert_area(AreaPublic areaPublic)
        {
            return _areaDal.insert_area(areaPublic);
        }

        public int update_area(AreaPublic areaPublic)
        {
            return _areaDal.update_area(areaPublic);
        }

        public int delete_area(AreaPublic areaPublic)
        {
            return _areaDal.delete_area(areaPublic);
        }
    }
}