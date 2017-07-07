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
    [TableName("eClaim_CostType")]
    [PrimaryKey("ID", AutoIncrement = true)]
    public class CostType
    {
        public int ID { get; set; }
        public string FormType { get; set; }
        public string CostTypeDesc { get; set; }
        public string AccountCode { get; set; }
        public string Region { get; set; }
        public string DisplayType { get; set; }
    }

    public class CostTypeController
    {
        //create
        public void CreateCostType(CostType t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<CostType>();
                rep.Insert(t);
            }
        }
        //update
        public void UpdateCostType(CostType t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<CostType>();
                rep.Update(t);
            }
        }
        //delete
        public void DeleteCostType(int ID)
        {
            var t = GetCostTypeBySql1(ID);
            DeleteCostType(t.First());
        }
        public void DeleteCostType(CostType t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<CostType>();
                //rep.Delete("where RefId = @0", refId);
                rep.Delete(t);
            }
        }
        //get
        public IEnumerable<CostType> GetCostTypes()
        {
            IEnumerable<CostType> t;
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<CostType>();
                t = rep.Get();
            }
            return t;
        }
        //get by sql
        public IEnumerable<CostType> GetCostTypeBySql1(int ID)
        {
            IEnumerable<CostType> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<CostType>();
                t = rep.Find("where ID = @0", ID);
            }
            return t;
        }
        //get by sql
        public IEnumerable<CostType> GetCostTypeByRegion(string Region)
        {
            IEnumerable<CostType> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<CostType>();
                t = rep.Find("where Region = @0", Region);
            }
            return t;
        }
        //get by sql
        public IEnumerable<CostType> GetCostTypeBySql3(int ID)
        {
            IEnumerable<CostType> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<CostType>();
                t = rep.Find("where  = @0", ID);
            }
            return t;
        }
    }
}