using System.Data;
using PUBLIC;

namespace DAL
{
    public class AreaDal
    {
        private readonly DataProvider _conn = new();

        public DataTable load_area()
        {
            var sql = @"LoadArea";
            return _conn.Load_Data(sql);
        }

        public int insert_area(AreaPublic areaPublic)
        {
            var parameter = 5;
            var name = new string[parameter];
            var values = new object[parameter];
            name[0] = "@Aid";
            name[1] = "@Location";
            name[2] = "@Size";
            name[3] = "@Opentime";
            name[4] = "@Closetime";
            values[0] = areaPublic.AID;
            values[1] = areaPublic.LOCATION;
            values[2] = areaPublic.SIZE;
            values[3] = areaPublic.OPENTIME;
            values[4] = areaPublic.CLOSETIME;
            var sql = "InputArea";
            return _conn.ExecuteData(sql, name, values, parameter);
        }

        public int update_area(AreaPublic areaPublic)
        {
            var parameter = 5;
            var name = new string[parameter];
            var values = new object[parameter];
            name[0] = "@Aid";
            name[1] = "@Location";
            name[2] = "@Size";
            name[3] = "@Opentime";
            name[4] = "@Closetime";
            values[0] = areaPublic.AID;
            values[1] = areaPublic.LOCATION;
            values[2] = areaPublic.SIZE;
            values[3] = areaPublic.OPENTIME;
            values[4] = areaPublic.CLOSETIME;
            var sql = "UpdateArea";
            return _conn.ExecuteData(sql, name, values, parameter);
        }

        public int delete_area(AreaPublic areaPublic)
        {
            var parameter = 1;
            var name = new string[parameter];
            var values = new object[parameter];
            name[0] = "@id";
            values[0] = areaPublic.AID;
            var sql = "DeleteArea";
            return _conn.ExecuteData(sql, name, values, parameter);
        }
    }
}