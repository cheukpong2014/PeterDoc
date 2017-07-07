using DotNetNuke.Entities.Users;
using Milton.Modules.eClaim.Components;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;
using DotNetNuke.Services.Localization;
using DotNetNuke.Services.Exceptions;
using System.Text;
using DotNetNuke.UI.Skins;
using DotNetNuke.UI.Skins.Controls;
using DotNetNuke.Common;
using System.Web;
using System.IO;
using System.Web.Script.Serialization;
using System.Runtime.Serialization.Json;
using Newtonsoft.Json;
using iTextSharp.text;
using iTextSharp.text.pdf;
using System.Collections;
using DotNetNuke.Security;
using DotNetNuke.Entities.Modules;
using DotNetNuke.Entities.Modules.Actions;
using DotNetNuke.UI.Utilities;

namespace Milton.Modules.eClaim
{
    public class newList
    {
        public string ID { get; set; }
        public string Region { get; set; }
        public DateTime? SubmissionDate { get; set; }
        public string BusinessUnit { get; set; }
        public string ClaimFormType { get; set; }
        public string JobNo { get; set; }
        public string ProjectName { get; set; }
        public string CreatedBy { get; set; }
        public string AccountNo { get; set; }
        public string EmployeeCode { get; set; }
    }
    public partial class exportExcel : eClaimModuleBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try {
                if (!Page.IsPostBack)
                {
                    var usr = UserController.Instance.GetUsersBasicSearch(PortalId, 0, 100, "UserID", false, "UserID", UserId.ToString()).Where(u => u.UserID == Convert.ToInt32(UserId)).First();
                    var loginID = usr.UserID.ToString();
                    var loginName = usr.DisplayName;
                    var loginRegion = usr.Profile.GetPropertyValue("RegionCode");
                    var loginDept = usr.Profile.GetPropertyValue("Department");


                    var getBU = new BusinessUnitController().GetBusinessUnit();
                    var getFormType = new ClaimFormTypeController().GetClaimFormTypes();
                    var getCostTypes = new CostTypeController().GetCostTypes();
                    var getCurrencys = new CurrencyController().GetCurrencys();
                    var getGSTCodes = new GSTCodeController().GetGSTCodes();
                    var getTransportationTypes = new TransportationTypeController().GetTransportationTypes();

                    JavaScriptSerializer Serializer = new JavaScriptSerializer();

                    hfBU.Value = Serializer.Serialize(getBU);
                    hfFormType.Value = Serializer.Serialize(getFormType);
                    hfCostType.Value = Serializer.Serialize(getCostTypes);
                    hfCurrency.Value = Serializer.Serialize(getCurrencys);
                    hfGSTCode.Value = Serializer.Serialize(getGSTCodes);
                    hfTransportationType.Value = Serializer.Serialize(getTransportationTypes);

                    //SUPER
                    //var getSuper = new SuperUsersController().GetSuperUsersByStaffID(usr.UserID);
                    //if (getSuper.Count() > 0)
                    var getPosition = new PositionController().GetPositionByStaffID(usr.UserID);
                    if(getPosition.Count()>0)
                    {
                        string region = getPosition.First().Region;
                        var regionTemp = "";
                        regionTemp = addQuote(region);
                        var tempList = new newList();
                        var allForms = new ClaimFormController().GetClaimFormByRegionAndStatus(regionTemp).Select(az => new newList
                        {
                            ID = az.ID.ToString(),
                            Region = az.Region,
                            SubmissionDate = az.SubmissionDate,
                            BusinessUnit = az.BusinessUnit,
                            ClaimFormType = az.ClaimFormType,
                            JobNo = az.JobNo,
                            ProjectName = az.ProjectName,
                            CreatedBy = UserController.Instance.GetUserById(PortalId, az.CreatedBy).DisplayName,
                            AccountNo = UserController.Instance.GetUserById(PortalId, az.CreatedBy).Profile.GetPropertyValue("eClaimAccountNo"),
                            EmployeeCode = UserController.Instance.GetUserById(PortalId, az.CreatedBy).Profile.GetPropertyValue("eClaimEmployeeCode")
                        }).OrderByDescending(qwe=>qwe.SubmissionDate);
                        
                        JavaScriptSerializer Serializer2 = new JavaScriptSerializer();
                        hfSubmitedForm.Value = Serializer2.Serialize(allForms);
                        //hfSubmitedFormDetails.Value = Serializer.Serialize(allFormsDetails);
                    }

                }
            }
            catch (Exception exc) //Module failed to load
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }
    }
}