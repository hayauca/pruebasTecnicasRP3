using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using Rp3.Test.Data;

namespace Rp3.Test.Mvc.Controllers
{
    public class TransactionController : Controller
    {     
        public ActionResult Index()
        {         
            int userId = Convert.ToInt32(this.Session["UserId"]);


            Rp3.Test.Proxies.Proxy proxy = new Proxies.Proxy();

            List<Rp3.Test.Mvc.Models.TransactionViewModel> transactions = proxy.GetTransactions2(userId).
                Select(p => new Models.TransactionViewModel()
                {
                
                    Amount = p.Amount,
                    CategoryId = p.CategoryId,
                    CategoryName = p.CategoryName,
                    Notes = p.Notes,
                    RegisterDate = p.RegisterDate,
                    ShortDescription = p.ShortDescription,
                    TransactionId = p.TransactionId,
                    TransactionType = p.TransactionType,
                    TransactionTypeId = p.TransactionTypeId,
                    UserId=p.UserId


                }).ToList();

            ViewBag.Categories = proxy.GetCategories();

            ViewBag.TransactionTypes = proxy.GetTransactionTypes();

            return View(transactions);
        
        }

        public ActionResult Balance()
        {
            int userId = Convert.ToInt32(this.Session["UserId"]);
            List<Rp3.Test.Mvc.Models.Balance> listBalnce = new List<Models.Balance>();

            using (var context = new Context())
            {
                listBalnce = context.Database.SqlQuery<Rp3.Test.Mvc.Models.Balance>("EXEC dbo.GetBalance @userId={0}", userId).ToList();

            }
             
            return View(listBalnce);
        }

 
        [HttpPost()]      
        public JsonResult Grabar(Rp3.Test.Common.Models.Transaction  modelTransaction)
        {
            string Mensaje = string.Empty;

            try
            {
                int userId = Convert.ToInt32(this.Session["UserId"]);
                Proxies.Proxy proxy = new Proxies.Proxy();

              //modelTransaction.RegisterDate = DateTime.Now;
                modelTransaction.UserId = userId;
        
                if (modelTransaction.TransactionId==0)
                {
                    var data = proxy.InsertTransaction(modelTransaction);

                    Mensaje = "Proceso grabado con exito";
                }
                else
                {
                    var data = proxy.UpdateTransaction(modelTransaction);

                    Mensaje = "Proceso actualizado con exito";
                }             
            }
            catch (Exception ex)
            {

                return Json(new
                {
                    resultado = new
                    {
                        error = ex.ToString(),
                        mensaje = ex.Message
                    }
                });
            }

            return Json(new
            {
                mensaje = Mensaje,
                datos = modelTransaction
             
            });
        }

        public ActionResult SaveTransaction()
        {

            Proxies.Proxy proxy = new Proxies.Proxy();

            Rp3.Test.Common.Models.Transaction info = new Common.Models.Transaction();

            var data = proxy.InsertTransaction(info);

            return View();
        }

        public ActionResult UpdateTransaction()
        {

            Proxies.Proxy proxy = new Proxies.Proxy();

            Rp3.Test.Common.Models.Transaction info = new Common.Models.Transaction();

            var data = proxy.UpdateTransaction(info);

            return View();
        }

    }
}
