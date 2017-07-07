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
    [TableName("eClaim_ClaimFormDetails")]
    [PrimaryKey("ClaimFormID", AutoIncrement = false, ColumnName = "SeqNo")]
    //need to primarykey
    //refId
    public class ClaimFormDetails
    {
        public int ClaimFormID { get; set; }
        public int SeqNo { get; set; }
        public int CostTypeID { get; set; }
        public DateTime? VoucDate { get; set; }
        public DateTime? PeriodFrom { get; set; }
        public DateTime? PeriodTo { get; set; }
        public string LocationFrom { get; set; }
        public string LocationTo { get; set; }
        public int TransportationTypeID { get; set; }
        public string Description { get; set; }
        public string AutoCal { get; set; }
        public string OriginalCurrencyCode { get; set; }
        public double OriginalAmount { get; set; }
        public double TaxAmount { get; set; }
        public int GSTCode { get; set; }
        public double AmountWithTax { get; set; }
        public string ClaimedCurrencyCode { get; set; }
        public double ExchangeRate { get; set; }
        public double TotalAmount { get; set; }
        public string IncludeRef { get; set; }
        public string Remarks { get; set; }
    }

    public class ClaimFormDetailsController
    {
        //create
        public void CreateClaimFormDetails(ClaimFormDetails t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<ClaimFormDetails>();
                rep.Insert(t);
            }
        }
        //update
        public void UpdateClaimFormDetails(ClaimFormDetails t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<ClaimFormDetails>();
                rep.Update(t);
            }
        }
        //delete
        public void Delete(string ClaimFormDetailsId)
        {
            var t = GetClaimFormDetailsBySql1(ClaimFormDetailsId);
            //DeleteClaimFormDetails(t.First());
        }
        public void DeleteClaimFormDetails(string ClaimFormDetailsId)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<ClaimFormDetails>();
                rep.Delete("where ClaimFormID = @0", ClaimFormDetailsId);
                //rep.Delete(t);
            }
        }
        //get
        public IEnumerable<ClaimFormDetails> GetClaimFormDetails()
        {
            IEnumerable<ClaimFormDetails> t;
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<ClaimFormDetails>();
                t = rep.Get();
            }
            return t;
        }
        //get by sql
        public IEnumerable<ClaimFormDetails> GetClaimFormDetailsBySql1(string ClaimFormDetailsId)
        {
            IEnumerable<ClaimFormDetails> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<ClaimFormDetails>();
                t = rep.Find("where ClaimFormID = @0", ClaimFormDetailsId);
            }
            return t;
        }
        //get by sql
        public IEnumerable<ClaimFormDetails> GetClaimFormDetailsByRecptDate(string ClaimFormDetailsId, string startdate, string enddate)
        {
            IEnumerable<ClaimFormDetails> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<ClaimFormDetails>();
                t = rep.Find("where ClaimFormID = @0 and VoucDate BETWEEN @1 AND @2", ClaimFormDetailsId, startdate, enddate);
                //t = rep.Find("where ClaimFormID = @0", ClaimFormDetailsId);
            }
            return t;
        }
        //get by sql
        public IEnumerable<ClaimFormDetails> GetClaimFormDetailsBySql3(string ClaimFormDetailsId)
        {
            IEnumerable<ClaimFormDetails> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<ClaimFormDetails>();
                t = rep.Find("where  = @0", ClaimFormDetailsId);
            }
            return t;
        }
    }
}