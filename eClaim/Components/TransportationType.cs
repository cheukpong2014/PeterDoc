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
    [TableName("eClaim_TransportationType")]
    [PrimaryKey("ID", AutoIncrement = true)]
    public class TransportationType
    {
        public int ID { get; set; }
        public string TransportationTypeDesc { get; set; }
        public string Region { get; set; }
    }

    public class TransportationTypeController
    {
        //create
        public void CreateTransportationType(TransportationType t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<TransportationType>();
                rep.Insert(t);
            }
        }
        //update
        public void UpdateTransportationType(TransportationType t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<TransportationType>();
                rep.Update(t);
            }
        }
        //delete
        public void DeleteTransportationType(int ID)
        {
            var t = GetTransportationTypeBySql1(ID);
            DeleteTransportationType(t.First());
        }
        public void DeleteTransportationType(TransportationType t)
        {
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<TransportationType>();
                //rep.Delete("where RefId = @0", refId);
                rep.Delete(t);
            }
        }
        //get
        public IEnumerable<TransportationType> GetTransportationTypes()
        {
            IEnumerable<TransportationType> t;
            using (IDataContext ctx = DataContext.Instance())
            {
                var rep = ctx.GetRepository<TransportationType>();
                t = rep.Get();
            }
            return t;
        }
        //get by sql
        public IEnumerable<TransportationType> GetTransportationTypeBySql1(int ID)
        {
            IEnumerable<TransportationType> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<TransportationType>();
                t = rep.Find("where ID = @0", ID);
            }
            return t;
        }
        //get by sql
        public IEnumerable<TransportationType> GetTransportationTypeByRegion(string Region)
        {
            IEnumerable<TransportationType> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<TransportationType>();
                t = rep.Find("where Region = @0", Region);
            }
            return t;
        }
        //get by sql
        public IEnumerable<TransportationType> GetTransportationTypeBySql3(int ID)
        {
            IEnumerable<TransportationType> t;
            using (IDataContext context = DataContext.Instance())
            {
                var rep = context.GetRepository<TransportationType>();
                t = rep.Find("where  = @0", ID);
            }
            return t;
        }
    }
}