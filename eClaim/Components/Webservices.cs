using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using DotNetNuke.Common.Utilities;
using DotNetNuke.Entities.Users;
using DotNetNuke.Web.Api;
using System.Text.RegularExpressions;
using System.IO;
using DotNetNuke.Entities.Portals;
using DotNetNuke.Services.Search.Entities;
using System.Web.Routing;

namespace Milton.Modules.eClaim.Components
{
    public class FileInfo
    {
        public string fileId;
        public string FileName;
        public string AccessPath;
        public FileInfo(string fileId, string FileName, string AccessPath)
        {
            this.fileId = fileId;
            this.FileName = FileName;
            this.AccessPath = AccessPath;
        }
    }
    public class SearchResult
    {
        // ReSharper disable InconsistentNaming
        // ReSharper disable NotAccessedField.Local
        public string region;
        public int id;
        public string name;
        public string email;
        public string dept;
        public string team;
        // ReSharper restore NotAccessedField.Local
        // ReSharper restore InconsistentNaming
    }
    public class WebservicesController : DnnApiController
    {
        [AllowAnonymous]
        [HttpPost]
        public HttpResponseMessage HelloWorld()
        {
            try
            {
                //var tasks = new ClaimFormDetailsController().GetClaimFormDetailsBySql1(formID);
                //return Request.CreateResponse(HttpStatusCode.OK, tasks);
                return Request.CreateResponse(HttpStatusCode.OK, "Hello World!");
            }
            catch (Exception exc)
            {
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, exc);
            }
        }
        [AllowAnonymous]
        [HttpGet]
        public HttpResponseMessage GetFormDetails(string formID)
        {
            try
            {
                var tasks = new ClaimFormDetailsController().GetClaimFormDetailsBySql1(formID);
                return Request.CreateResponse(HttpStatusCode.OK, tasks);
            }
            catch (Exception exc)
            {
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, exc);
            }
        }
        [AllowAnonymous]
        [HttpGet]
        public HttpResponseMessage GetFormDetailsByRecptDate(string formID, string startdate, string enddate)
        {
            try
            {
                //formID = "3";
                //startdate = "2017-04-01 00:00:00";
                //enddate = "2017-04-30 23:59:59";
                var tasks = new ClaimFormDetailsController().GetClaimFormDetailsByRecptDate(formID, startdate, enddate);
                return Request.CreateResponse(HttpStatusCode.OK, tasks);
            }
            catch (Exception exc)
            {
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, exc);
            }
        }

        [DnnAuthorize]
        [HttpPost]
        public HttpResponseMessage UploadActual(string appID)
        {
            try
            {
                var httpRequest = HttpContext.Current.Request;
                if (httpRequest.Files.Count > 0)
                {
                    Regex reg_exp_file_name = new Regex(@"^[\w,\s-]+\.[A-Za-z]{3,4}");
                    var uploadedfiles = new List<FileInfo>();
                    var folderPathMap = ActualFolderMap() + appID + "\\";
                    var folderPath = ActualFolder() + appID + "/";
                    if (!Directory.Exists(folderPathMap))
                        Directory.CreateDirectory(folderPathMap);
                    foreach (string file in httpRequest.Files)
                    {
                        var postedFile = httpRequest.Files[file];
                        if (reg_exp_file_name.IsMatch(postedFile.FileName))
                        {
                            if (!File.Exists(folderPathMap + postedFile.FileName))
                            {
                                var ActualController = new AttachmentController();
                                var _Actual = new Attachment();
                                _Actual.refID = appID;
                                _Actual.AttachmentPath = folderPath + postedFile.FileName;
                                ActualController.CreateActual(_Actual);
                                FileInfo uploadedFile = new FileInfo(_Actual.ID.ToString(), postedFile.FileName, folderPath + postedFile.FileName);
                                uploadedfiles.Add(uploadedFile);
                            }
                            postedFile.SaveAs(folderPathMap + postedFile.FileName);
                        }
                        else
                        {
                            uploadedfiles.Add(null);
                        }
                    }
                    return Request.CreateResponse(HttpStatusCode.Created, uploadedfiles);
                }
                else
                    return Request.CreateResponse(HttpStatusCode.BadRequest, "upload failed");

            }
            catch (Exception exc)
            {
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, exc);
            }
        }

        [DnnAuthorize]
        [HttpPost]
        public HttpResponseMessage DeleteActual(string appID)
        {
            try
            {
                var deleteFileName = HttpContext.Current.Request.Form[0];
                var folderPathMap = ActualFolderMap() + appID + "\\";
                var folderPath = ActualFolder() + appID + "/";
                if (File.Exists(folderPathMap + deleteFileName))
                {
                    File.Delete(folderPathMap + deleteFileName);
                    var ActualController = new AttachmentController();
                    ActualController.DeleteActual(appID, folderPath + deleteFileName);

                    return Request.CreateResponse(HttpStatusCode.OK, "success delete");
                }
                else
                    return Request.CreateResponse(HttpStatusCode.BadRequest,"fail delete");
            }
            catch (Exception exc)
            {
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, exc);
            }
        }

        [DnnAuthorize]
        [HttpGet]
        public HttpResponseMessage SearchUser(string userid, string q)
        {
            try
            {
                var usrDept = "";
                var usrTeam = "";
                var portalId = PortalController.GetEffectivePortalId(PortalSettings.PortalId);
                const int numResults = 15;
                q = q.Replace(",", "").Replace("'", "");
                if (q.Length == 0) return Request.CreateResponse<SearchResult>(HttpStatusCode.OK, null);

                var resultsList = UserController.Instance.GetUsersBasicSearch(portalId, 0, numResults, "DisplayName", true, "DisplayName", q);
                var outcomes = new List<SearchResult>();

                //eClaimModuleBase: getTeamMembersByAdmin
                var teamHandler = new TeamHandlerController().GetTeamNameByTeamHandler(userid);
                string teamString = "";
                foreach (var zxc in teamHandler)
                {
                    teamString = teamString + "'" + zxc.TeamName + "',";
                }
                teamString = teamString != "" ? teamString.Substring(0, teamString.Length - 1) : "''";
                var teamMembers = new TeamMemberController().GetStaffIDByTeamName(teamString);
                foreach (var rr in resultsList)
                {
                    var userRegion = rr.Profile.GetPropertyValue("RegionCode");
                    SearchResult sResult = new SearchResult();
                    sResult.region = userRegion;
                    sResult.id = rr.UserID;
                    sResult.name = rr.DisplayName;
                    sResult.email = rr.Email;
                    sResult.dept = usrDept;
                    sResult.team = usrTeam;
                    //check if the user has region code
                    var checkRegion = new ClaimFormTypeController().GetClaimFormTypeByRegion(userRegion);
                    if (checkRegion.Count() > 0)
                    {
                        //1. get all user that admin can add
                        //2. if the user == result got from query from token input
                        //3. show it
                        foreach (var tm in teamMembers)
                        {
                            if (tm.StaffID == rr.UserID)
                            {
                                outcomes.Add(sResult);
                                break;
                            }
                        }
                    }

                }
                return Request.CreateResponse(HttpStatusCode.OK, outcomes.OrderBy(sr => sr.name));
            }
            catch (Exception exc)
            {
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, exc);
            }
        }
        public string ActualFolderMap()
        {
            return String.Format("{0}eClaim\\upload\\", DotNetNuke.Entities.Portals.PortalSettings.Current.HomeDirectoryMapPath);
        }

        public string ActualFolder()
        {
            return String.Format("{0}eClaim/upload/", DotNetNuke.Entities.Portals.PortalSettings.Current.HomeDirectory);
        }
    }
}