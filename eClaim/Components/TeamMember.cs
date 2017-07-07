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
    [TableName("eClaim_TeamMember")]
    [PrimaryKey("StaffID", AutoIncrement = true)]
    public class TeamMember
    {
        public int StaffID { get; set; }
        public string TeamName { get; set; }
        public string DepartmentName { get; set; }
    }
    public class TeamMemberController
    {
        //create
        public void CreateTeamMember(TeamMember t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<TeamMember>();
                rep.Insert(t);
            }
        }
        //update
        public void UpdateTeamMember(TeamMember t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<TeamMember>();
                rep.Update(t);
            }
        }
        //delete
        public void DeleteTeamMemberByPrimKey(string ID)
        {
            var t = GetTeamMembersByPrimKey(ID);
            DeleteTeamMember(t.First());
        }
        public void DeleteTeamMember(TeamMember t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<TeamMember>();
                //rep.Delete("where RefId = @0", refId);
                rep.Delete(t);
            }
        }
        //get
        public IEnumerable<TeamMember> GetTeamMembers()
        {
            IEnumerable<TeamMember> t;
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<TeamMember>();
                t = rep.Get();
            }
            return t;
        }
        //get by sql
        public IEnumerable<TeamMember> GetTeamMembersByPrimKey(string ID)
        {
            IEnumerable<TeamMember> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<TeamMember>();
                t = rep.Find("where  = @0", ID);
            }
            return t;
        }
        //get by sql
        public IEnumerable<TeamMember> GetStaffIDByTeamName(string Team)
        {
            IEnumerable<TeamMember> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<TeamMember>();
                t = rep.Find("where TeamName in (" + Team + ")");
            }
            return t;
        }
    }
}