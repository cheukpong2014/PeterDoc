using System;
using System.Web.Caching;
using DotNetNuke.Common.Utilities;
using DotNetNuke.ComponentModel.DataAnnotations;
using DotNetNuke.Entities.Content;
using System.Collections.Generic;
using DotNetNuke.Data;
using System.Linq;

namespace Milton.Modules.eClaim.Components
{
    [TableName("eClaim_Position")]
    [PrimaryKey("StaffID", AutoIncrement = false)]
    public class Position
    {
        public int StaffID { get; set; }
        public string StaffPosition { get; set; }
        public string Region { get; set; }
    }
    public class PositionController
    {
        //create
        public void CreatePosition(Position t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<Position>();
                rep.Insert(t);
            }
        }
        //update
        public void UpdatePosition(Position t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<Position>();
                rep.Update(t);
            }
        }

        public void DeletePosition(Position t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<Position>();
                //rep.Delete("where RefId = @0", refId);
                rep.Delete(t);
            }
        }
        //get
        public IEnumerable<Position> GetPositions()
        {
            IEnumerable<Position> t;
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<Position>();
                t = rep.Get();
            }
            return t;
        }
        //get by sql
        public IEnumerable<Position> GetPositionByStaffID(int staffID)
        {
            IEnumerable<Position> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<Position>();
                t = rep.Find("where StaffID = @0", staffID);
            }
            return t;
        }
        //get by sql
        public IEnumerable<Position> GetPositionByIDAndRegion(int StaffID, string Region)
        {
            IEnumerable<Position> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<Position>();
                t = rep.Find("where Region = @0 and StaffID = @1", Region, StaffID);
            }
            return t;
        }
        //get by sql
        public IEnumerable<Position> GetPositionBySql3(int ID)
        {
            IEnumerable<Position> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<Position>();
                t = rep.Find("where  = @0", ID);
            }
            return t;
        }
    }
}