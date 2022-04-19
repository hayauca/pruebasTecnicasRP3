using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Rp3.Test.Mvc.Models
{
    public class User
    {
        public int UserId { get; set; }

        public string UserName { get; set; }

        public string Name { get; set; }

        public string Password { get; set; }

        public bool Active { get; set; }
    }
}