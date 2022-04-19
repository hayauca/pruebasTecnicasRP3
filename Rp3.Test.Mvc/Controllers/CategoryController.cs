using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Rp3.Test.Mvc.Controllers
{
    public class CategoryController : Controller
    {
        [HttpGet]
        public ActionResult Index()
        {
            Rp3.Test.Proxies.Proxy proxy = new Proxies.Proxy();

            List<Rp3.Test.Mvc.Models.CategoryViewModel> categories = proxy.GetCategories().
                Select(p=> new Models.CategoryViewModel()
                {
                    Active = p.Active,
                    CategoryId = p.CategoryId,
                    Name = p.Name
                }).ToList();

            return View(categories);
        }



        public ActionResult Edit(int categoryId)
        {
            Rp3.Test.Proxies.Proxy proxy = new Proxies.Proxy();

            Rp3.Test.Mvc.Models.CategoryEditModel editModel = new Models.CategoryEditModel();

            var commonModel = proxy.GetCategory(categoryId);

            editModel.Active = commonModel.Active;
            editModel.CategoryId = commonModel.CategoryId;
            editModel.Name = commonModel.Name;

            return View(editModel);
        }

        [HttpPost]
        public ActionResult Edit(Rp3.Test.Mvc.Models.CategoryEditModel editModel)
        {
            Rp3.Test.Proxies.Proxy proxy = new Proxies.Proxy();

            Rp3.Test.Common.Models.Category commonModel = new Common.Models.Category();
            
            commonModel.Active = editModel.Active;
            commonModel.CategoryId = editModel.CategoryId;
            commonModel.Name = editModel.Name;

            bool respondeOk = proxy.UpdateCategory(commonModel);

            if (respondeOk)
                return RedirectToAction("Index");
            else
                return View(editModel);
        }
    }
}
