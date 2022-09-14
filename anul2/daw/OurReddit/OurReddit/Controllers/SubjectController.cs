using Microsoft.AspNet.Identity;
using OurReddit.ActionFilters;
using OurReddit.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace OurReddit.Controllers
{
    public class SubjectController : Controller
    {
        private Models.ApplicationDbContext db = new Models.ApplicationDbContext();

        private static List<SelectListItem> SortingMethods = new List<SelectListItem>
        {
            new SelectListItem { Text = "Cele mai recente primele", Value = "1"},
            new SelectListItem { Text = "Cele mai vechi primele", Value = "2"},
        };

        [HttpGet]
        [AlertFilter]
        // oricine poate vedea subiectele
        public ActionResult Show(int id)
        {
            SetAccessRights();
            Subject subject = db.Subjects.Find(id);

            // sortare
            int sort = 0;
            if (Request.Params.Get("sort") != null && Request.Params.Get("sort") != "")
            {
                sort = Convert.ToInt32(Request.Params.Get("sort"));
            }
            
            if (sort == 1)
            {
                subject.Messages = subject.Messages.OrderByDescending(m => m.DateCreated).ToList();
            }
            else if (sort == 2)
            {
                subject.Messages = subject.Messages.OrderBy(c => c.DateCreated).ToList();
            }

            ViewBag.subject = subject;
            ViewBag.total = subject.Messages.Count();
            ViewBag.SortingMethods = SortingMethods;
            ViewBag.isModerator = User.IsInRole("Moderator");
            ViewBag.isAdmin = User.IsInRole("Admin");

            return View();
        }

        [HttpGet]
        //Doar daca esti inregistrat poti crea subiect nou
        [Authorize(Roles = "User,Moderator,Admin")]
        public ActionResult New(int id)
        {
            SetAccessRights();
            Subject subject = new Subject();
            subject.UserId = User.Identity.GetUserId();
            ViewBag.CategoryId = id;
            return View();
        }

        [HttpPost]
        //Doar daca esti inregistrat poti crea subiect nou
        [Authorize(Roles = "User,Moderator,Admin")]
        public ActionResult New(Subject subject)
        {
            try
            {
                subject.UserId = User.Identity.GetUserId();
                db.Subjects.Add(subject);
                db.SaveChanges();
                TempData["Alert"] = "Ai creat un nou subiect: " + subject.Title.ToString();
                return Redirect("/Category/Show/" + subject.CategoryId);
            }
            catch (Exception e)
            {
                TempData["Alert"] = "Eroare la creare subiectului";
                return View(subject);
            }
        }

        [HttpGet]
        [AlertFilter]
        //Doar daca esti inregistrat poti edita subiect
        [Authorize(Roles = "User,Moderator,Admin")]
        public ActionResult Edit(int id)
        {
            SetAccessRights();
            Subject subject = db.Subjects.Find(id);
            subject.AllCategories = GetAllCategories();
            ViewBag.subjectCategory = subject.CategoryId;
            if (subject.UserId == User.Identity.GetUserId() || User.IsInRole("Admin") || User.IsInRole("Moderator"))
            {
                ViewBag.Subject = subject;
                return View(subject);
            }
            else
            {
                TempData["Alert"] = "Nu ai drepturi suficiente";
                return Redirect("/Category/Show/" + subject.CategoryId);
            }
        }

        [HttpPut]
        //Doar daca esti inregistrat poti edita subiect
        [Authorize(Roles = "User,Moderator,Admin")]
        public ActionResult Edit(int id, Subject requestSubject)
        {
            Subject subject = db.Subjects.Find(id);
            subject.AllCategories = GetAllCategories();
            ViewBag.subjectCategory = subject.CategoryId;
            
            ViewBag.isModerator = User.IsInRole("Moderator");
            ViewBag.isAdmin = User.IsInRole("Admin");

            try
            {
                if (subject.UserId == User.Identity.GetUserId() || User.IsInRole("Admin") || User.IsInRole("Moderator"))
                {
                    if (TryUpdateModel(subject))
                    {
                        subject.Title = requestSubject.Title;
                        subject.Description = requestSubject.Description;
                        System.Diagnostics.Debug.WriteLine(HttpContext.Request.Params.Get("newCategory"));
                        var newCategoryId = HttpContext.Request.Params.Get("newCategory");
                        System.Diagnostics.Debug.WriteLine(newCategoryId);

                        if(newCategoryId != null)
                            subject.CategoryId = Int32.Parse(newCategoryId);
                        db.SaveChanges();
                        TempData["Alert"] = "Subiectul a fost editat: " + subject.Title.ToString();
                    }
                    else
                    {
                        TempData["Alert"] = "Eroare la editarea subiectului";
                        return View(subject);
                    }
                    return Redirect("/Category/Show/" + subject.CategoryId);
                }
                else
                {
                    TempData["Alert"] = "nu ai suficiente drepturi";
                    return Redirect("Category/Show/" + subject.CategoryId);
                }
            }
            catch (Exception e)
            {
                TempData["Alert"] = "Eroare la editarea subiectului";
                return View(subject);
            }
        }

        [NonAction]
        public IEnumerable<SelectListItem> GetAllCategories()
        {
            var selectList = new List<SelectListItem>();
            var categories = from category in db.Categories select category;
            foreach (var category in categories)
            {
                selectList.Add(new SelectListItem
                {
                    Value = category.Id.ToString(),
                    Text = category.Name.ToString()
                });
            }
            return selectList;
        }
        [HttpDelete]
        //Doar daca esti inregistrat poti edita subiect nou
        [Authorize(Roles = "User,Moderator,Admin")]
        public ActionResult Delete(int id)
        {
            Subject subject = db.Subjects.Find(id);

            if (subject.UserId == User.Identity.GetUserId() || User.IsInRole("Admin") || User.IsInRole("Moderator"))
            {
                db.Subjects.Remove(subject);
                db.SaveChanges();
                TempData["Alert"] = "Subiectul a fost sters: " + subject.Title.ToString();
                return Redirect("/Category/Show/" + subject.CategoryId);
            }
            else
            {
                TempData["Alert"] = "nu ai suficiente drepturi";
                return Redirect("/Category/Show/" + subject.CategoryId);
            }
        }

        [NonAction]
        private void SetAccessRights()
        {
            ViewBag.isAdmin = User.IsInRole("Admin");
            ViewBag.isModerator = User.IsInRole("Moderator");
            ViewBag.currentUserId = User.Identity.GetUserId();
        }
    }
}