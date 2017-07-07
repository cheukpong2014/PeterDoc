using System;
using System.Linq;
using System.Web.UI.WebControls;
using Milton.Modules.eClaim.Components;
using DotNetNuke.Security;
using DotNetNuke.Services.Exceptions;
using DotNetNuke.Entities.Modules;
using DotNetNuke.Entities.Modules.Actions;
using DotNetNuke.Services.Localization;
using DotNetNuke.UI.Utilities;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using DotNetNuke.Entities.Users;
using DotNetNuke.UI.Skins;
using DotNetNuke.UI.Skins.Controls;

namespace Milton.Modules.eClaim
{
    public partial class View : eClaimModuleBase, IActionable
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                JavaScriptSerializer Serializer = new JavaScriptSerializer();
                var usr = UserController.Instance.GetUsersBasicSearch(PortalId, 0, 100, "UserID", false, "UserID", UserId.ToString()).Where(u => u.UserID == Convert.ToInt32(UserId)).First();
                var userRegion = usr.Profile.GetPropertyValue("RegionCode");

                if (string.IsNullOrWhiteSpace(userRegion))
                {
                    //user does not have region
                    Skin.AddModuleMessage(this, "Cannot find your region data, please connect to IT department.", ModuleMessage.ModuleMessageType.RedError);
                    btnViewClaimForm.Visible = false;
                    btnExport.Visible = false;
                    return;
                }
                
                var checkRegion = new ClaimFormTypeController().GetClaimFormTypeByRegion(userRegion);
                if (checkRegion.Count() == 0)
                {
                    //wrong region code
                    Skin.AddModuleMessage(this, "Your region code is set incorrectly or the eClaim is not ready for your region, please connect to IT department.", ModuleMessage.ModuleMessageType.RedError);
                    btnViewClaimForm.Visible = false;
                    btnExport.Visible = false;
                    return;
                }

                var userID = usr.UserID.ToString();
                Components.ClaimForm cf = new Components.ClaimForm();
                ClaimFormController cfctl = new ClaimFormController();
                btnExport.Visible = false;
                spanCreateForOthers.Visible = false;
                //SUPER
                var getPosition = new PositionController().GetPositionByStaffID(usr.UserID);
                List<Components.ClaimForm> allForms;
                if (getPosition.Count() > 0)
                {
                    var StaffPosition = getPosition.First().StaffPosition;
                    var region = getPosition.First().Region;
                    var regionTemp = "";
                    regionTemp = addQuote(region);
                    if (StaffPosition == "SuperUser")
                    {
                        btnExport.Visible = true;
                        spanCreateForOthers.Visible = true;
                        btnExportByReceiptDate.Visible = true;
                        allForms = cfctl.GetClaimFormBySuperUserRegions(regionTemp).ToList();
                    }
                    else if(StaffPosition == "Admin")
                    {
                        string teamStaff = getTeamMembersByAdmin(userID);
                        teamStaff = teamStaff + ",'" + userID + "'";//if don't add this line, admin cannot see her form in the table
                        spanCreateForOthers.Visible = true;
                        btnExportByReceiptDate.Visible = false;
                        allForms = cfctl.GetClaimFormByTeamMemberID(teamStaff).ToList();
                    }
                    else if(StaffPosition == "Acc")
                    {
                        btnExport.Visible = true;
                        btnExportByReceiptDate.Visible = false;
                        allForms = cfctl.GetClaimFormBySuperUserRegions(regionTemp).ToList();
                    }
                    else if(StaffPosition == "AdminAcc")
                    {
                        string teamStaff = getTeamMembersByAdmin(userID);
                        teamStaff = teamStaff + ",'" + userID + "'";//if don't add this line, admin cannot see her form in the table
                        btnExport.Visible = true;
                        spanCreateForOthers.Visible = true;
                        btnExportByReceiptDate.Visible = false;
                        var adminRegion = region.Split('/')[0];
                        var accRegion = region.Split('/')[1];
                        regionTemp = addQuote(accRegion);
                        allForms = cfctl.GetClaimFormByRegionOrTeamMemberID(regionTemp, teamStaff).ToList();
                    }
                    else
                    {
                        allForms = cfctl.GetClaimFormByUserID(userID).ToList();
                    }
                    //string regions = "";
                    //foreach (var _data in getSuper)
                    //{
                    //    regions += "'";
                    //    regions += _data.Region;
                    //    regions += "',";
                    //}
                    //regions = regions.Substring(0, regions.Length - 1);
                    //allForms = cfctl.GetClaimFormBySuperUserRegions(regions).ToList();
                    //btnExport.Visible = true;
                    //spanCreateForOthers.Visible = true;
                }
                else
                {
                    allForms = cfctl.GetClaimFormByUserID(userID).ToList();
                }

                List<Components.ClaimForm> filter = allForms;
                var result = filter.Select(form => new FormTable
                {
                    ID = form.ID.ToString(),
                    RefNo = form.RefNo.ToString(),
                    SubmissionDate = (form.SubmissionDate.HasValue) ? form.SubmissionDate.Value.ToString("yyyy-MM-dd") : "",
                    BU = form.BusinessUnit,
                    CreatedBy = UserController.Instance.GetUserById(PortalId, form.CreatedBy).DisplayName,
                    ClaimFormType = displayFormType(form),
                    StatusID = new ClaimFormStatusController().GetClaimFormStatusBySql1(form.StatusID).First().StatusDesc

                }).ToList();

                if (result.Count() > 0)
                {
                    gvTable.DataSource = result;
                    gvTable.DataBind();

                    gvTable.HeaderRow.TableSection = TableRowSection.TableHeader;
                    gvTable.FooterRow.TableSection = TableRowSection.TableFooter;
                }

            }
            catch (Exception exc) //Module failed to load
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }
        protected void btnCreate_Click(object sender, EventArgs e)
        {
            try
            {
                Response.Redirect(DotNetNuke.Common.Globals.NavigateURL("ClaimForm", "mid=" + ModuleId)+"/id/0");
            }
            catch (Exception exc) //Module failed to load
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }
        protected void btnCreateForOthers_Click(object sender, EventArgs e)
        {
            try
            {
                //hfCreateForOthers.Value = "611";
                string otherID = hfCreateForOthers.Value;
                var usr = UserController.Instance.GetUsersBasicSearch(PortalId, 0, 100, "UserID", false, "UserID", otherID.ToString()).Where(u => u.UserID == Convert.ToInt32(otherID)).First();
                Components.ClaimForm cf = new Components.ClaimForm();
                ClaimFormController cfCtl = new ClaimFormController();
                cf.RefNo = "ECF-" + DateTime.Now.ToString("yyMMdd") + "-" + DateTime.Now.ToString("HHmmss") + UserId;
                cf.Region = usr.Profile.GetPropertyValue("RegionCode");
                cf.BusinessUnit = "CPU";
                cf.ClaimFormType = "G";
                cf.JobNo = "";
                cf.ProjectName = "";
                cf.LastUpdatedBy = usr.UserID;
                cf.LastUpdateDate = DateTime.Now;
                cf.StatusID = 1;
                cf.CreatedBy = usr.UserID;
                cf.CreateDate = DateTime.Now;
                var FormObjForID = cfCtl.CreateClaimForm(cf);
                Response.Redirect(DotNetNuke.Common.Globals.NavigateURL("ClaimForm", "mid=" + ModuleId) + "/id/"+FormObjForID.ID.ToString());
            }
            catch (Exception exc) //Module failed to load
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }
        public ModuleActionCollection ModuleActions
        {
            get
            {
                var actions = new ModuleActionCollection
                    {
                        {
                            GetNextActionID(), Localization.GetString("EditModule", LocalResourceFile), "", "", "",
                            EditUrl(), false, SecurityAccessLevel.Edit, true, false
                        }
                    };
                return actions;
            }
        }

        protected void gvTable_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            //e.Row.Cells[0].CssClass = "hiddenColumn";

            //if (!isSuperUser(UserId)) { 
            //    e.Row.Cells[3].CssClass = "hiddenColumn";
            //}

            string documentReady = "";
            documentReady += "$(document).queue(function(){" +
                        "$('#" + gvTable.ClientID + "').dataTable().fnSetColumnVis(0, false);"
                    + "$(this).dequeue(); });";
            //SUPER
            if (!hasPosition(UserId))
            {
                documentReady += "$(document).queue(function(){" +
                        "$('#"+gvTable.ClientID+"').dataTable().fnSetColumnVis(4, false);"
                    + "$(this).dequeue(); });";
            }

            Page.ClientScript.RegisterStartupScript(this.GetType(), "PageLoadDocumentReady", "$(document).ready(function(){" +
                        documentReady +
                     "});", true);

            if (e.Row.RowType == DataControlRowType.Header)
            {
                e.Row.Cells[1].Text = Localization.GetString("RefNo", LocalResourceFile);
                e.Row.Cells[2].Text = Localization.GetString("SubmissionDate", LocalResourceFile);
                //e.Row.Cells[3].Text = Localization.GetString("BU", LocalResourceFile);
                e.Row.Cells[4].Text = Localization.GetString("CreatedBy", LocalResourceFile);
                e.Row.Cells[5].Text = Localization.GetString("ClaimFormType", LocalResourceFile);
                e.Row.Cells[6].Text = Localization.GetString("StatusID", LocalResourceFile);
            }
        }
    }
    public class FormTable//affect order
    {

        public string ID { get; set; }
        public string RefNo { get; set; }
        //public string Region { get; set; }
        public string SubmissionDate { get; set; }
        public string BU { get; set; }
        public string CreatedBy { get; set; }
        public string ClaimFormType { get; set; }
        //public string JobNo { get; set; }
        //public string ProjectName { get; set; }
        //public DateTime CreateDate { get; set; }
        //public int LastUpdatedBy { get; set; }
        //public string LastUpdateDate { get; set; }
        public string StatusID { get; set; }
        //public string NAV { get; set; }
    }
}