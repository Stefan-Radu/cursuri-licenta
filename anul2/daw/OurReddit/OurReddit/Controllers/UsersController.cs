using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using OurReddit.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace OurReddit.Controllers
{
    public class UsersController : Controller
    {
        private readonly Models.ApplicationDbContext db = new Models.ApplicationDbContext();

        // GET: Users
        [Authorize(Roles = "Admin")]
        public ActionResult Index()
        {
            var users = from user in db.Users
                        orderby user.UserName
                        select user;

            string userId = User.Identity.GetUserId();
            ViewBag.UsersList = users.Where(u => u.Id != userId).ToList();
            return View();
        }

        [Authorize(Roles = "User,Moderator,Admin")]
        public ActionResult Show(string id)
        {
            ApplicationUser user = db.Users.Find(id);
            ViewBag.CurrentUser = User.Identity.GetUserId();
            string currentRole = user.Roles.FirstOrDefault().RoleId;

            var userRoleName = (from role in db.Roles where role.Id == currentRole select role.Name).First();
            ViewBag.roleName = userRoleName;

            return View(user);
        }

        [Authorize(Roles = "User,Moderator,Admin")]
        public ActionResult Edit(string id)
        {
            ApplicationUser user = db.Users.Find(id);
            if (user == null)
            {
                return Redirect("/Category/Index");
            }
            user.AllRoles = GetAllRoles();
            var userRole = user.Roles.FirstOrDefault();
            ViewBag.userRole = userRole.RoleId;
            return View(user);
        }

        [Authorize(Roles = "User,Moderator,Admin")]
        [HttpPut]
        public ActionResult Edit(string id, ApplicationUser newData)
        {
            ApplicationUser user = db.Users.Find(id);
            user.AllRoles = GetAllRoles();
            var userRole = user.Roles.FirstOrDefault();
            ViewBag.userRole = userRole.RoleId;

            try
            {
                ApplicationDbContext context = new ApplicationDbContext();
                var roleManager = new RoleManager<IdentityRole>(new RoleStore<IdentityRole>(context));
                var UserManager = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(context));

                if (TryUpdateModel(user))
                {
                    user.UserName = newData.UserName;
                    user.Email = newData.Email;
                    user.PhoneNumber = newData.PhoneNumber;

                    var selectedRole = db.Roles.Find(HttpContext.Request.Params.Get("newRole"));
                    if (selectedRole != null)
                    {
                        var roles = from role in db.Roles select role;

                        foreach (var role in roles)
                        {
                            UserManager.RemoveFromRole(id, role.Name);
                        }

                        UserManager.AddToRole(id, selectedRole.Name);
                    }
                  
                    db.SaveChanges();
                }
                return RedirectToAction("Show/" + user.Id);
            }
            catch (Exception e)
            {
                Response.Write(e.Message);
                newData.Id = id;
                return View(newData);
            }
        }

        [Authorize(Roles = "Admin")]
        [HttpDelete]
        public ActionResult Delete(string id)
        {
            ApplicationDbContext context = new ApplicationDbContext();

            var UserManager = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(context));

            var user = UserManager.Users.FirstOrDefault(u => u.Id == id);

            var subjects = db.Subjects.Where(a => a.UserId == id);
            foreach (var subject in subjects)
            {
                db.Subjects.Remove(subject);

            }

            var messages = db.Messages.Where(comm => comm.UserId == id);
            foreach (var message in messages)
            {
                db.Messages.Remove(message);
            }

            db.SaveChanges();
            UserManager.Delete(user);
            return RedirectToAction("Index");
        }

        [NonAction]
        public IEnumerable<SelectListItem> GetAllRoles()
        {
            var selectList = new List<SelectListItem>();

            var roles = from role in db.Roles select role;
            foreach (var role in roles)
            {
                selectList.Add(new SelectListItem
                {
                    Value = role.Id.ToString(),
                    Text = role.Name.ToString()
                });
            }
            return selectList;
        }
    }
}