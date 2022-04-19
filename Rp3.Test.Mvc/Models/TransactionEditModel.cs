using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Rp3.Test.Mvc.Models
{
    public class TransactionEditModel
    {
        public int TransactionId { get; set; }
        public short TransactionTypeId { get; set; }
        public int CategoryId { get; set; }
        public DateTime RegisterDate { get; set; }
        public string ShortDescription { get; set; }
        public string Notes { get; set; }

        public SelectList CategorySelectList { get; set; }
        public SelectList TransactionTypeSelectList { get; set; }
    }
}