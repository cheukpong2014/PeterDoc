using System;
using System.Web.Caching;
using DotNetNuke.Common.Utilities;
using DotNetNuke.ComponentModel.DataAnnotations;
using DotNetNuke.Entities.Content;
using DotNetNuke.Data;
using System.Collections.Generic;

namespace Milton.Modules.eClaim.Components
{
    [TableName("vw_eClaim_BusinessUnit")]
    public class BusinessUnit
    {
        public string BUCode { get; set; }
    }
    public class BusinessUnitController
    {
        public IEnumerable<BusinessUnit> GetBusinessUnit()
        {
            IEnumerable<BusinessUnit> t;
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<BusinessUnit>();
                t = rep.Get();
            }
            return t;
        }
    }
}