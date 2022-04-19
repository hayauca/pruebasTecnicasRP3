using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using Rp3.Test.Data;

namespace Rp3.Test.Mvc.Controllers
{
    public class LoginController : Controller
    {
        // GET: Login
        public ActionResult Index()
        {
            return View();
        }
    
        public ActionResult Login2()
        {
            return View();
        }

        [HttpPost()]
        public ActionResult VerificaUsuarios(Rp3.Test.Mvc.Models.User user)
        {
            try
            {
                string Mensaje = "";
                using (var context = new Context())
                {
                    var consulta = context.Users.FirstOrDefault(q => q.UserName == user.UserName && q.Password == user.Password );
                
                if (consulta != null)
                {
                    this.Session["UserId"] = consulta.UserId;
                    this.Session["UserName"] =  consulta.UserName;
                    this.Session["Name"] = consulta.Name;
                    this.Session["Password"] = consulta.Password;

                    var redirectUrl = new UrlHelper(Request.RequestContext).Action("Index", "Home", new { });
                    return Json(new { Url = redirectUrl,mensaje="" });
                }
                else
                {
                        Mensaje="Usuario Invalido";
                        return Json(new
                        {
                            mensaje = Mensaje

                        });

                    }

                }

                

            }
            catch (Exception ex)
            {
                throw;
            }

        }
    }
}