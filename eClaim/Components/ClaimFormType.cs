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
    [TableName("eClaim_ClaimFormType")]
    [PrimaryKey("ClaimFormTypeCode", AutoIncrement = false)]
    public class ClaimFormType
    {
        public string ClaimFormTypeCode { get; set; }
        public string ClaimFormTypeDesc { get; set; }
        public string Region { get; set; }
    }

    public class ClaimFormTypeController
    {
        //create
        public void CreateClaimFormType(ClaimFormType t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<ClaimFormType>();
                rep.Insert(t);
            }
        }
        //update
        public void UpdateClaimFormType(ClaimFormType t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<ClaimFormType>();
                rep.Update(t);
            }
        }
        //delete
        public void DeleteClaimFormType(string ID)
        {
            var t = GetClaimFormTypeBySql1(ID);
            DeleteClaimFormType(t.First());
        }
        public void DeleteClaimFormType(ClaimFormType t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<ClaimFormType>();
                //rep.Delete("where RefId = @0", refId);
                rep.Delete(t);
            }
        }
        //get
        public IEnumerable<ClaimFormType> GetClaimFormTypes()
        {
            IEnumerable<ClaimFormType> t;
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<ClaimFormType>();
                t = rep.Get();
            }
            return t;
        }
        //get by sql
        public IEnumerable<ClaimFormType> GetClaimFormTypeBySql1(string ID)
        {
            IEnumerable<ClaimFormType> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<ClaimFormType>();
                t = rep.Find("where ClaimFormTypeCode = @0", ID);
            }
            return t;
        }
        //get by sql
        public IEnumerable<ClaimFormType> GetClaimFormTypeByRegion(string Region)
        {
            IEnumerable<ClaimFormType> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<ClaimFormType>();
                t = rep.Find("where Region = @0", Region);
            }
            return t;
        }
        //get by sql
        public IEnumerable<ClaimFormType> GetClaimFormTypeBySql3(string ID)
        {
            IEnumerable<ClaimFormType> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<ClaimFormType>();
                t = rep.Find("where  = @0", ID);
            }
            return t;
        }
    }
}