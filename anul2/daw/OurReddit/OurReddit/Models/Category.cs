using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace OurReddit.Models
{
    public class Category
    {
        [Key]
        public int Id{ get; set; }
        [MinLength(4, ErrorMessage = "Numele Categoriei este prea scurt")]
        [MaxLength(27, ErrorMessage = "Numele Categoriei este prea lung")]
        [Required(ErrorMessage = "Campul este obligatoriu")]
        public string Name { get; set; }
        [Required]
        public DateTime DateCreated { get; set; }

        // o categorie are mai multe subiecte
        public virtual ICollection<Subject> Subjects { get; set; } 
    }
}