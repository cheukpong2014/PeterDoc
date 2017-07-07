using DotNetNuke.Web.Api;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Milton.Modules.eClaim.Components
{
    public class RouteMapper : IServiceRouteMapper
    {
        public void RegisterRoutes(IMapRoute mapRouteManager)
        {
            mapRouteManager.MapHttpRoute("eClaim", "default", "{controller}/{action}", new[] { "Milton.Modules.eClaim.Components" });
        }
    }
}