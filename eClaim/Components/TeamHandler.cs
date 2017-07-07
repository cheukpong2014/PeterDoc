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
    [TableName("eClaim_TeamHandler")]
    [PrimaryKey("ID", AutoIncrement = true)]
    public class TeamHandler
    {
        public int ID { get; set; }
        public string TeamName { get; set; }
        public int HandlerID { get; set; }
        public int DisplayOrder { get; set; }
    }
    public class TeamHandlerController
    {
        //create
        public void CreateTeamHandler(TeamHandler t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<TeamHandler>();
                rep.Insert(t);
            }
        }
        //update
        public void UpdateTeamHandler(TeamHandler t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<TeamHandler>();
                rep.Update(t);
            }
        }
        //delete
        public void DeleteTeamHandlerByPrimKey(string ID)
        {
            var t = GetTeamHandlersByPrimKey(ID);
            DeleteTeamHandler(t.First());
        }
        public void DeleteTeamHandler(TeamHandler t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<TeamHandler>();
                //rep.Delete("where RefId = @0", refId);
                rep.Delete(t);
            }
        }
        //get
        public IEnumerable<TeamHandler> GetTeamHandlers()
        {
            IEnumerable<TeamHandler> t;
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<TeamHandler>();
                t = rep.Get();
            }
            return t;
        }
        //get by sql
        public IEnumerable<TeamHandler> GetTeamHandlersByPrimKey(string ID)
        {
            IEnumerable<TeamHandler> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<TeamHandler>();
                t = rep.Find("where ID = @0", ID);
            }
            return t;
        }
        //get by sql
        public IEnumerable<TeamHandler> GetTeamNameByTeamHandler(string TeamHandlerID)
        {
            IEnumerable<TeamHandler> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<TeamHandler>();
                t = rep.Find("where HandlerID = @0", TeamHandlerID);
            }
            return t;
        }
    }
}