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
    [TableName("eClaim_ClaimFormStatus")]
    [PrimaryKey("ID", AutoIncrement = true)]
    public class ClaimFormStatus
    {
        public int ID { get; set; }
        public string StatusDesc { get; set; }
    }

    public class ClaimFormStatusController
    {
        //create
        public void CreateClaimFormStatus(ClaimFormStatus t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<ClaimFormStatus>();
                rep.Insert(t);
            }
        }
        //update
        public void UpdateClaimFormStatus(ClaimFormStatus t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<ClaimFormStatus>();
                rep.Update(t);
            }
        }
        //delete
        public void DeleteClaimFormStatus(int ID)
        {
            var t = GetClaimFormStatusBySql1(ID);
            DeleteClaimFormStatus(t.First());
        }
        public void DeleteClaimFormStatus(ClaimFormStatus t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<ClaimFormStatus>();
                //rep.Delete("where RefId = @0", refId);
                rep.Delete(t);
            }
        }
        //get
        public IEnumerable<ClaimFormStatus> GetClaimFormStatuss()
        {
            IEnumerable<ClaimFormStatus> t;
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<ClaimFormStatus>();
                t = rep.Get();
            }
            return t;
        }
        //get by sql
        public IEnumerable<ClaimFormStatus> GetClaimFormStatusBySql1(int ID)
        {
            IEnumerable<ClaimFormStatus> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<ClaimFormStatus>();
                t = rep.Find("where ID = @0", ID);
            }
            return t;
        }
        //get by sql
        public IEnumerable<ClaimFormStatus> GetClaimFormStatusBySql2(int ID)
        {
            IEnumerable<ClaimFormStatus> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<ClaimFormStatus>();
                t = rep.Find("where  = @0", ID);
            }
            return t;
        }
        //get by sql
        public IEnumerable<ClaimFormStatus> GetClaimFormStatusBySql3(int ID)
        {
            IEnumerable<ClaimFormStatus> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<ClaimFormStatus>();
                t = rep.Find("where  = @0", ID);
            }
            return t;
        }
    }
}