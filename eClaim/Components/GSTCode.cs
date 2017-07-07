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
    [TableName("eClaim_GSTCode")]
    [PrimaryKey("ID", AutoIncrement = false)]
    public class GSTCode
    {
        public int ID { get; set; }
        public string Code { get; set; }
        public string TaxDesc { get; set; }
        public int TaxRate { get; set; }
        public string Region { get; set; }
    }

    public class GSTCodeController
    {
        //create
        public void CreateGSTCode(GSTCode t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<GSTCode>();
                rep.Insert(t);
            }
        }
        //update
        public void UpdateGSTCode(GSTCode t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<GSTCode>();
                rep.Update(t);
            }
        }
        //delete
        public void DeleteGSTCode(int ID)
        {
            var t = GetGSTCodeBySql1(ID);
            DeleteGSTCode(t.First());
        }
        public void DeleteGSTCode(GSTCode t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<GSTCode>();
                //rep.Delete("where RefId = @0", refId);
                rep.Delete(t);
            }
        }
        //get
        public IEnumerable<GSTCode> GetGSTCodes()
        {
            IEnumerable<GSTCode> t;
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<GSTCode>();
                t = rep.Get();
            }
            return t;
        }
        //get by sql
        public IEnumerable<GSTCode> GetGSTCodeBySql1(int ID)
        {
            IEnumerable<GSTCode> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<GSTCode>();
                t = rep.Find("where ID = @0", ID);
            }
            return t;
        }
        //get by sql
        public IEnumerable<GSTCode> GetGSTCodeByRegion(string Region)
        {
            IEnumerable<GSTCode> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<GSTCode>();
                t = rep.Find("where Region = @0", Region);
            }
            return t;
        }
        //get by sql
        public IEnumerable<GSTCode> GetGSTCodeBySql3(int ID)
        {
            IEnumerable<GSTCode> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<GSTCode>();
                t = rep.Find("where  = @0", ID);
            }
            return t;
        }
    }
}