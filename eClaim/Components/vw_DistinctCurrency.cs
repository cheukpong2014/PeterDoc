using System;
using System.Web.Caching;
using DotNetNuke.Common.Utilities;
using DotNetNuke.ComponentModel.DataAnnotations;
using DotNetNuke.Entities.Content;
using DotNetNuke.Data;
using System.Collections.Generic;

namespace Milton.Modules.eClaim.Components
{
    [TableName("vw_eClaim_DistCurr")]
    public class vw_DistinctCurrency
    {
        public string CurrencyCode { get; set; }
    }
    public class vw_DistinctCurrencyController
    {
        public IEnumerable<vw_DistinctCurrency> GetDistinctCurrency()
        {
            IEnumerable<vw_DistinctCurrency> t;
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<vw_DistinctCurrency>();
                t = rep.Get();
            }
            return t;
        }
    }
}