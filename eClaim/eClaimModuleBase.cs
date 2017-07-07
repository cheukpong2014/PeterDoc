/*
' Copyright (c) 2017  milton-cn.com
'  All rights reserved.
' 
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
' TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
' THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
' CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
' DEALINGS IN THE SOFTWARE.
' 
*/

using System;
using DotNetNuke.Entities.Modules;
using Milton.Modules.eClaim.Components;
using System.Threading;
using DotNetNuke.Entities.Users;
using System.Linq;
using System.Collections.Generic;
using DotNetNuke.UI.Skins;
using DotNetNuke.Services.Localization;
using DotNetNuke.UI.Skins.Controls;
using System.Web.UI.WebControls;
using System.IO;
using System.Security.Cryptography;
using System.Text;
using DotNetNuke.Services.Mail;
using System.Web;
using System.Globalization;

namespace Milton.Modules.eClaim
{
    public class eClaimModuleBase : PortalModuleBase
    {
        public string getTeamMembersByAdmin(string adminID)
        {
            var teamHandler = new TeamHandlerController().GetTeamNameByTeamHandler(adminID);
            string teamString = "";
            foreach (var zxc in teamHandler)
            {
                teamString = teamString + "'" + zxc.TeamName + "',";
            }
            teamString = teamString != "" ? teamString.Substring(0, teamString.Length - 1) : "''";
            var teamMembers = new TeamMemberController().GetStaffIDByTeamName(teamString);
            string teamStaff = "";
            foreach (var tm in teamMembers)
            {
                teamStaff = teamStaff + "'" + tm.StaffID + "',";
            }
            teamStaff = teamStaff != "" ? teamStaff.Substring(0, teamStaff.Length - 1) : "''";

            return teamStaff;
        }
        public string addQuote(string regionArr)
        {
            string regionTemp = "";
            foreach (var str in regionArr.Split(','))
            {
                regionTemp = regionTemp + "'" + str + "',";
            }
            regionTemp = regionTemp != "" ? regionTemp.Substring(0, regionTemp.Length - 1) : "''";

            return regionTemp;
        }
        public int ItemId
        {
            get
            {
                var qs = Request.QueryString["tid"];
                if (qs != null)
                    return Convert.ToInt32(qs);
                return -1;
            }

        }
        //SUPER
        public bool hasPosition(int userID) {

            bool result = false;

            PositionController _PositionCtl = new PositionController();
            IEnumerable<Position> position = _PositionCtl.GetPositionByStaffID(userID);
            if (position.Count() > 0)
            {
                result = true;
            }
            return result;
        }

        public string displayFormType(Components.ClaimForm form)
        {
            if (form.ClaimFormType == "P")
            {
                string str = form.ProjectName + " (" + form.JobNo + ")";
                return str;
            }
            else
            {
                return new ClaimFormTypeController().GetClaimFormTypeBySql1(form.ClaimFormType).First().ClaimFormTypeDesc;
            }
        }
    }
}