using System;
using System.Web.Caching;
using DotNetNuke.Common.Utilities;
using DotNetNuke.ComponentModel.DataAnnotations;
using DotNetNuke.Entities.Content;
using DotNetNuke.Data;
using System.Collections.Generic;
using System.Linq;

namespace Milton.Modules.eClaim.Components
{
    [TableName("eClaim_Attachment")]
    [PrimaryKey("ID", AutoIncrement = true)]
    public class Attachment
    {
        public int ID { get; set; }
        public string refID { get; set; }
        public string AttachmentPath { get; set; }
    }
    public class AttachmentController
    {
        public void CreateActual(Attachment t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<Attachment>();
                rep.Insert(t);
            }
        }

        public void DeleteActual(string FormID, string path)
        {
            var t = GetActual(FormID, path);
            DeleteActual(t);
        }

        public void DeleteActual(Attachment t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<Attachment>();
                rep.Delete("where refID = @0 and AttachmentPath = @1", new string[] { t.refID, t.AttachmentPath });
            }
        }

        public IEnumerable<Attachment> GetActuals()
        {
            IEnumerable<Attachment> t;
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<Attachment>();
                t = rep.Get();
            }
            return t;
        }

        public Attachment GetActual(string FormID, string path)
        {
            IEnumerable<Attachment> t;
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<Attachment>();
                t = rep.Find("where refID = @0 and AttachmentPath = @1", new string[] { FormID, path });
            }
            return t.First();
        }

        public IEnumerable<Attachment> GetActuals(string FormID)
        {
            IEnumerable<Attachment> t;
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<Attachment>();
                t = rep.Find("where refID = @0", FormID);
            }
            return t;
        }

        public void UpdateActual(Attachment t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<Attachment>();
                rep.Update("where refID = @0 and AttachmentPath = @1", new string[] { t.refID, t.AttachmentPath });
            }
        }
    }
}