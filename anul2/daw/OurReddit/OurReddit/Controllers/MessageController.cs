using System;
using System.Collections.Generic;
using System.Data.Entity.Validation;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using OurReddit.ActionFilters;
using OurReddit.Models;

namespace OurReddit.Controllers
{
    public class MessageController : Controller
    {
        private readonly Models.ApplicationDbContext db = new Models.ApplicationDbContext();
     
        [HttpPost]
        //Doar daca esti inregistrat poti posta
        [Authorize(Roles = "User,Moderator,Admin")]
        public ActionResult New(Message message)
        {
            try
            {
                message.UserId = User.Identity.GetUserId();
                db.Messages.Add(message);
                db.SaveChanges();
                TempData["Alert"] = "Ai adaugat un nou mesaj";
                return Redirect("/Subject/Show/" + message.SubjectId);
            }
            catch (Exception e)
            {
                TempData["Alert"] = "Nu poti adauga un mesaj gol";
                return Redirect("/Subject/Show/" + message.SubjectId); ;
            }
        }

        [HttpGet]
        [AlertFilter]
        //Doar daca esti inregistrat poti edita
        [Authorize(Roles = "User,Moderator,Admin")]
        public ActionResult Edit(int id)
        {
            Message message = db.Messages.Find(id);
            if (message.UserId == User.Identity.GetUserId() || User.IsInRole("Admin") || User.IsInRole("Moderator"))
            {
                ViewBag.Subject = message;
                return View(message);
            }
            else
            {
                TempData["Alert"] = "nu ai suficiente drepturi";
                return Redirect("/Subject/Show/" + message.SubjectId);
            }
        }

        [HttpPut]
        //Doar daca esti inregistrat poti edita
        [Authorize(Roles = "User,Moderator,Admin")]
        public ActionResult Edit(int id, Message requestMessage)
        {
            try
            {
                Message message = db.Messages.Find(id);
                if (message.UserId == User.Identity.GetUserId() || User.IsInRole("Admin") || User.IsInRole("Moderator"))
                {
                    message.Content = requestMessage.Content;
                    message.Edited = true;
                    db.SaveChanges();

                    TempData["Alert"] = "Mesajul a fost editat";
                    return Redirect("/Subject/Show/" + message.SubjectId);
                }
                else
                {
                    TempData["Alert"] = "nu ai suficiente drepturi";
                    return Redirect("/Subject/Show/" + message.SubjectId);
                }
            }
            catch (Exception e)
            {
                System.Diagnostics.Debug.WriteLine("exception");
                TempData["Alert"] = "Eroare la editarea mesajului";
                return View();
            }
        }

        [HttpDelete]
        //Doar daca esti inregistrat poti sterge un mesaj
        [Authorize(Roles = "User,Moderator,Admin")]

        public ActionResult Delete(int id)
        {
            Message message = db.Messages.Find(id);
            if (message.UserId == User.Identity.GetUserId() || User.IsInRole("Admin") || User.IsInRole("Moderator"))
            {
                db.Messages.Remove(message);
                db.SaveChanges();
                TempData["Alert"] = "Mesajul a fost sters";
                return Redirect("/Subject/Show/" + message.SubjectId);
            }
            else
            {
                TempData["Alert"] = "nu ai suficiente drepturi";
                return Redirect("/Subject/Show/" + message.SubjectId);
            }
        }
    }
}