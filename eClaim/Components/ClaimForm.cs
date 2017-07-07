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
    [TableName("eClaim_ClaimForm")]
    [PrimaryKey("ID", AutoIncrement = true)]
    public class ClaimForm
    {
        public int ID { get; set; }
        public string RefNo { get; set; }
        public string Region { get; set; }
        public DateTime? SubmissionDate { get; set; }
        public string BusinessUnit { get; set; }
        public string ClaimFormType { get; set; }
        public string JobNo { get; set; }
        public string ProjectName { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreateDate { get; set; }
        public int LastUpdatedBy { get; set; }
        public DateTime LastUpdateDate { get; set; }
        public int StatusID { get; set; }
        public int? ConfirmedBy { get; set; }
        public DateTime? ConfirmDate { get; set; }
    }
    public class ClaimFormController
    {
        //create
        public ClaimForm CreateClaimForm(ClaimForm t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<ClaimForm>();
                rep.Insert(t);
            }
            return t;
        }
        //update
        public ClaimForm UpdateClaimForm(ClaimForm t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<ClaimForm>();
                rep.Update(t);
            }
            return t;
        }
        //delete
        public void DeleteClaimForm(string ClaimFormId)
        {
            var t = GetClaimFormBySql1(ClaimFormId);
            DeleteClaimForm(t.First());
        }
        public void DeleteClaimForm(ClaimForm t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<ClaimForm>();
                //rep.Delete("where RefId = @0", refId);
                rep.Delete(t);
            }
        }
        //get
        public IEnumerable<ClaimForm> GetClaimForms()
        {
            IEnumerable<ClaimForm> t;
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<ClaimForm>();
                t = rep.Get();
            }
            return t;
        }
        //get by sql
        public IEnumerable<ClaimForm> GetClaimFormBySql1(string ClaimFormId)
        {
            IEnumerable<ClaimForm> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<ClaimForm>();
                t = rep.Find("where ID = @0", ClaimFormId);
            }
            return t;
        }
        //get by sql
        public IEnumerable<ClaimForm> GetClaimFormByRegion(string Region)
        {
            IEnumerable<ClaimForm> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<ClaimForm>();
                t = rep.Find("where Region = @0", Region);
            }
            return t;
        }
        //get by sql
        public IEnumerable<ClaimForm> GetClaimFormByPermission(string ClaimFormId, string createby)
        {
            IEnumerable<ClaimForm> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<ClaimForm>();
                t = rep.Find("where ID = @0 and CreatedBy = @1", ClaimFormId, createby);
            }
            return t;
        }
        //get by sql
        public IEnumerable<ClaimForm> GetClaimFormByUserID(string createby)
        {
            IEnumerable<ClaimForm> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<ClaimForm>();
                t = rep.Find("where CreatedBy = @0 and StatusID != 3", createby);
            }
            return t;
        }
        //get by sql
        public IEnumerable<ClaimForm> GetClaimFormBySuperUserRegions(string regions)
        {
            IEnumerable<ClaimForm> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<ClaimForm>();
                t = rep.Find("where Region in (" + regions+ ") and StatusID != 3");
            }
            return t;
        }
        //get by sql
        public IEnumerable<ClaimForm> GetClaimFormByRegionAndStatus(string regions)
        {
            IEnumerable<ClaimForm> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<ClaimForm>();
                t = rep.Find("where Region in (" + regions + ") and StatusID = 2");
            }
            return t;
        }
        //get by sql
        public IEnumerable<ClaimForm> GetClaimFormByTeamMemberID(string TeamMembers)
        {
            IEnumerable<ClaimForm> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<ClaimForm>();
                t = rep.Find("where CreatedBy in (" + TeamMembers + ") and StatusID != 3");
            }
            return t;
        }
        //get by sql
        public IEnumerable<ClaimForm> GetClaimFormByRegionOrTeamMemberID(string regions, string TeamMembers)
        {
            IEnumerable<ClaimForm> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<ClaimForm>();
                t = rep.Find("where (Region in (" + regions + ") or CreatedBy in (" + TeamMembers + ")) and StatusID != 3");
            }
            return t;
        }
    }
}