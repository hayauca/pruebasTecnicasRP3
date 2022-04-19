﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace Rp3.Test.Mvc
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}",
               // defaults: new { controller = "Home", action = "Index", id = UrlParameter.Optional }
                defaults: new { controller = "Login", action = "Login2", id = UrlParameter.Optional }
            );
        }
    }
}