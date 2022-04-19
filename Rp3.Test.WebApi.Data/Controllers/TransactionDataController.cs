using Rp3.Test.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Rp3.Test.WebApi.Data.Controllers
{
    public class TransactionDataController : ApiController
    {

        [HttpGet]

        public IHttpActionResult Get(int userId)
        {
            List<Rp3.Test.Common.Models.TransactionView> commonModel = new List<Common.Models.TransactionView>();

            using (DataService service = new DataService())
            {
                var query = service.Transactions.GetQueryable();

               
                    query = query.Where(p => p.UserId == userId);

                commonModel = query.Select(p => new Common.Models.TransactionView()
                {
                    CategoryId = p.CategoryId,
                    CategoryName = p.Category.Name,
                    Notes = p.Notes,
                    Amount = p.Amount,
                    RegisterDate = p.RegisterDate,
                    ShortDescription = p.ShortDescription,
                    TransactionId = p.TransactionId,
                    TransactionType = p.TransactionType.Name,
                    TransactionTypeId = p.TransactionTypeId,
                    UserId = p.UserId


                }).ToList();
            }

            return Ok(commonModel);
        }
      
        [HttpGet]
        public IHttpActionResult Get()
        {
        
          List<Rp3.Test.Common.Models.TransactionView> commonModel = new List<Common.Models.TransactionView>();

            using (DataService service = new DataService())
            {
                IEnumerable<Rp3.Test.Data.Models.Transaction> 
                    dataModel = service.Transactions.Get(                   
                    includeProperties: "Category,TransactionType", 
                    orderBy: p=> p.OrderByDescending(o=>o.RegisterDate));

                //Para incluir una condición, puede usar el primer parametro de Get
                /*
                 * Ejemplo
                 IEnumerable<Rp3.Test.Data.Models.Transaction>
                    dataModel = service.Transactions.Get(p=> p.TransactionId > 0
                    includeProperties: "Category,TransactionType",
                    orderBy: p => p.OrderByDescending(o => o.RegisterDate));

                 */

                commonModel = dataModel.Select(p => new Common.Models.TransactionView()
                {
                    CategoryId = p.CategoryId,
                    CategoryName = p.Category.Name,
                    Notes = p.Notes,
                    Amount = p.Amount,
                    RegisterDate = p.RegisterDate,
                    ShortDescription = p.ShortDescription,
                    TransactionId = p.TransactionId,
                    TransactionType = p.TransactionType.Name,
                    TransactionTypeId = p.TransactionTypeId,
                    UserId=p.UserId
                }).ToList();
            }

            return Ok(commonModel);
        }

        public IHttpActionResult Insert(Rp3.Test.Common.Models.Transaction transaction)
        {
            //Complete the code
            using (DataService service = new DataService())
            {
                Rp3.Test.Data.Models.Transaction model = new Test.Data.Models.Transaction();
                model.TransactionId = service.Transactions.GetMaxValue<int>(p => p.TransactionId, 0) + 1;

               
                model.TransactionTypeId = transaction.TransactionTypeId;
                model.CategoryId= transaction.CategoryId;

                model.RegisterDate = transaction.RegisterDate;
                model.ShortDescription = transaction.ShortDescription;
                model.Amount = transaction.Amount;
                model.Notes = transaction.Notes;
                model.UserId = transaction.UserId;


                service.Transactions.Insert(model);
                service.SaveChanges();
            }

            return Ok();
        }

        public IHttpActionResult Update(Rp3.Test.Common.Models.Transaction transaction)
        {
            //Complete the code
            using (DataService service = new DataService())
            {
                Rp3.Test.Data.Models.Transaction model = service.Transactions.GetByID(transaction.TransactionId);

              
                model.TransactionTypeId = transaction.TransactionTypeId;
                model.CategoryId = transaction.CategoryId;

                model.RegisterDate = transaction.RegisterDate;
                model.ShortDescription = transaction.ShortDescription;
                model.Amount = transaction.Amount;
                model.Notes = transaction.Notes;

                
                service.Transactions.Update(model);
                service.SaveChanges();
            }

            return Ok();
        }
    }
}
