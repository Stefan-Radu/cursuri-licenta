using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;


namespace OurReddit.ActionFilters
{
    public class AlertFilter: ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            if (filterContext.Controller.TempData.ContainsKey("Alert"))
            {
                filterContext.Controller.ViewBag.alert = filterContext.Controller.TempData["Alert"].ToString();
                Console.WriteLine(filterContext.Controller.ViewBag.alert.ToString());
            }
        }
    }
}