using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace OurReddit.Models
{
    public class Subject
    {
        [Key]
        public int Id { get; set; }
        [StringLength(27, MinimumLength = 4, ErrorMessage = "Titlul trebuie sa aiba intre 4 si 27 de caractere")]
        [Required(ErrorMessage = "Campul este obligatoriu")]
        public string Title { get; set; }
        [StringLength(300, MinimumLength = 5, ErrorMessage = "Descrierea trebuie sa aiba intre 5 si 300 de caractere")]
        [Required(ErrorMessage = "Campul este obligatoriu")]
        public string Description { get; set; }
        [Required]
        public DateTime DateCreated { get; set; }
        [Required(ErrorMessage = "Campul este obligatoriu")]
        public int CategoryId { get; set; }
        
        //un subiect apartine unei categorii 
        public virtual Category Category { get; set; }
        //o categorie are mai multe mesaje
        public virtual ICollection<Message> Messages { get; set; } //un subiect are mai multe mesaje

        public IEnumerable<SelectListItem> AllCategories { get; set; }
        public string UserId { get; set; } // cine a creat subiectul

        public virtual ApplicationUser User { get; set; }
    }
}