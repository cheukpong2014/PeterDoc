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
    [TableName("eClaim_Currency")]
    [PrimaryKey("CurrencyCode", AutoIncrement = false)]
    public class Currency
    {
        public string CurrencyCode { get; set; }
        public string CurrencyRegion { get; set; }
    }

    public class CurrencyController
    {
        //create
        public void CreateCurrency(Currency t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<Currency>();
                rep.Insert(t);
            }
        }
        //update
        public void UpdateCurrency(Currency t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<Currency>();
                rep.Update(t);
            }
        }
        //delete
        public void DeleteCurrency(string ID)
        {
            var t = GetCurrencyBySql1(ID);
            DeleteCurrency(t.First());
        }
        public void DeleteCurrency(Currency t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<Currency>();
                //rep.Delete("where RefId = @0", refId);
                rep.Delete(t);
            }
        }
        //get
        public IEnumerable<Currency> GetCurrencys()
        {
            IEnumerable<Currency> t;
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<Currency>();
                t = rep.Get();
            }
            return t;
        }
        //get by sql
        public IEnumerable<Currency> GetCurrencyBySql1(string ID)
        {
            IEnumerable<Currency> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<Currency>();
                t = rep.Find("where CurrencyCode = @0", ID);
            }
            return t;
        }
        //get by sql
        public IEnumerable<Currency> GetCurrencyByRegion(string Region)
        {
            IEnumerable<Currency> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<Currency>();
                t = rep.Find("where CurrencyRegion = @0", Region);
            }
            return t;
        }
        //get by sql
        public IEnumerable<Currency> GetCurrencyBySql3(string ID)
        {
            IEnumerable<Currency> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<Currency>();
                t = rep.Find("where  = @0", ID);
            }
            return t;
        }
    }
}