using Microsoft.AspNet.Identity;
using OurReddit.ActionFilters;
using OurReddit.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Linq.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Razor.Generator;

namespace OurReddit.Controllers
{
    public class CategoryController : Controller
    {
        private readonly Models.ApplicationDbContext db = new Models.ApplicationDbContext();

        private static int PER_PAGE = 5;
        
        private static List<SelectListItem> SortingMethods = new List<SelectListItem> 
        {
            new SelectListItem { Text = "Alfabetic crescator", Value = "1"},
            new SelectListItem { Text = "Alfabetic descrescator", Value = "2"},
            new SelectListItem { Text = "Cele mai recente primele", Value = "3"},
            new SelectListItem { Text = "Cele mai vechi primele", Value = "4"},
        };
            
        [HttpGet]
        [AlertFilter]
        //oricine poate vedea categoriile
        public ActionResult Index()
        {
            SetAccessRights();
            
            // cautare
            string search = "";
            if (Request.Params.Get("search") != null)
            {
                search = Request.Params.Get("search").Trim();
            }

            var categories = from category in db.Categories
                             where category.Name.Contains(search)
                             orderby category.Name
                             select category;

            int currentPage = Convert.ToInt32(Request.Params.Get("pageNumber"));
            int offset = currentPage * PER_PAGE;
            int totalCategories = categories.Count();

            // sortare
            int sort = 0;
            if (Request.Params.Get("sort") != null && Request.Params.Get("sort") != "")
            {
                sort = Convert.ToInt32(Request.Params.Get("sort"));
            }

            if (sort == 1)
            {
                categories = categories.OrderBy(c => c.Name);
            } 
            else if (sort == 2)
            {
                categories = categories.OrderByDescending(c => c.Name);
            }
            else if (sort == 3)
            {
                categories = categories.OrderByDescending(c => c.DateCreated);
            }
            else if (sort == 4)
            {
                categories = categories.OrderBy(c => c.DateCreated);
            }

            categories = (IOrderedQueryable<Category>)categories.Skip(offset).Take(PER_PAGE);

            ViewBag.Categories = categories;
            ViewBag.perPage = PER_PAGE;
            ViewBag.total = totalCategories;
            ViewBag.currentPage = currentPage;
            ViewBag.lastPage = totalCategories / PER_PAGE + (totalCategories % PER_PAGE != 0 ? 1 : 0);
            ViewBag.SearchString = search;
            ViewBag.SortingMethods = SortingMethods;
            ViewBag.SortId = sort;

            return View();
        }

        [HttpGet]
        [AlertFilter]
        public ActionResult Show(int id)
        {
            SetAccessRights();

            string search = "";
            if (Request.Params.Get("search") != null)
            {
                search = Request.Params.Get("search").Trim();
            }

            Category category = db.Categories.Find(id);

            List<int> subjectIds = db.Subjects
                .Where(s => s.Title.Contains(search) || s.Description.Contains(search))
                .Select(s => s.Id).ToList();

            List<int> messageIds = db.Messages
                .Where(m => m.Content.Contains(search))
                .Select(m => m.SubjectId).ToList();

            List<int> mergedIds = subjectIds.Union(messageIds).ToList();

            int currentPage = Convert.ToInt32(Request.Params.Get("pageNumber"));
            int offset = currentPage * PER_PAGE;
            category.Subjects = category.Subjects.Where(s => mergedIds.Contains(s.Id)).ToList();
            int totalSubjects = category.Subjects.Count();

            // sortare
            int sort = 0;
            if (Request.Params.Get("sort") != null && Request.Params.Get("sort") != "")
            {
                sort = Convert.ToInt32(Request.Params.Get("sort"));
            }

            if (sort == 1)
            {
                category.Subjects = category.Subjects.OrderBy(s => s.Title).ToList();
            }
            else if (sort == 2)
            {
                category.Subjects = category.Subjects.OrderByDescending(s => s.Title).ToList();
            }
            else if (sort == 3)
            {
                category.Subjects = category.Subjects.OrderByDescending(s => s.DateCreated).ToList();
            }
            else if (sort == 4)
            {
                category.Subjects = category.Subjects.OrderBy(s => s.DateCreated).ToList();
            }

            category.Subjects = category.Subjects.Skip(offset).Take(PER_PAGE).ToList();

            ViewBag.Category = category;
            ViewBag.perPage = PER_PAGE;
            ViewBag.total = totalSubjects;
            ViewBag.currentPage = currentPage;
            ViewBag.lastPage = totalSubjects / PER_PAGE + (totalSubjects % PER_PAGE != 0 ? 1 : 0);
            ViewBag.SearchString = search;
            ViewBag.SortingMethods = SortingMethods;
            ViewBag.SortId = sort;

            return View();
        }
        
        [HttpGet]
        [AlertFilter]
        [Authorize(Roles = "Admin")]
        public ActionResult New()
        {
            SetAccessRights();
            return View();
        }

        [HttpPost]
        // doar admin poate crea categorie noua
        [Authorize(Roles="Admin")]
        public ActionResult New(Category category)
        {
            try
            {
                db.Categories.Add(category);
                db.SaveChanges();
                TempData["Alert"] = "Ai creat o categorie noua: " + category.Name.ToString();
                return RedirectToAction("Index");
            }
            catch (Exception e)
            {
                TempData["Alert"] = "Eroare la crearea categoriei";
                return View();
            }
        }
        
        [HttpGet]
        [AlertFilter]
        // doar admin poate modifica categoriile
        [Authorize(Roles = "Admin")]
        public ActionResult Edit(int id)
        {
            SetAccessRights();
            Category category = db.Categories.Find(id);
            ViewBag.Category = category;
            return View(category);
        }

        [HttpPut]
        [Authorize(Roles = "Admin")]
        // doar admin poate modifica categoriile
        public ActionResult Edit(int id, Category requestCategory)
        {
            try
            {
                Category category = db.Categories.Find(id);
                if (TryUpdateModel(category))
                {
                    category.Name = requestCategory.Name;
                    db.SaveChanges();
                    TempData["Alert"] = "Ai editat categoria: " + category.Name.ToString();
                }
                else
                {
                    TempData["Alert"] = "Eroare la editarea categoriei";
                    return View(category);
                }
                return RedirectToAction("Index");
            } 
            catch (Exception e)
            {
                TempData["Alert"] = "Eroare la editarea categoriei";
                return View();
            }
        }

        [HttpDelete]
        // doar admin poate sterge categoriile
        [Authorize(Roles = "Admin")]
        public ActionResult Delete(int id)
        {
            Category category = db.Categories.Find(id);
            db.Categories.Remove(category);
            db.SaveChanges();
            TempData["Alert"] = "Ai sters categoria: " + category.Name.ToString();
            return RedirectToAction("Index");
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