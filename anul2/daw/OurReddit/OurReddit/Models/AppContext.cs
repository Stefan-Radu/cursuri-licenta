using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

/*
 *     Instructiuni
 *     
 *     dupa dai enable-migrations -EnableAutomaticMigrations:$true -- defapt nu stiu daca mai tre sa faci tu asta
 *     -- nu mai stiu daca a trebuit
 *     Add-Migration Initial
 *     Update-Database
 *     REFRESH la db explorer
 *     DACA L AI OMORAT https://weblog.west-wind.com/posts/2016/jan/13/resetting-entity-framework-migrations-to-a-clean-slate
 */


namespace OurReddit.Models
{
    // Add new models here to make sure they auto-update :D
  /*  public class AppContext : DbContext
    {
        public AppContext(): base("DBConnectionString") {
            Database.SetInitializer(new MigrateDatabaseToLatestVersion<AppContext,
                OurReddit.Migrations.Configuration>("DBConnectionString"));
        }
        public DbSet<Category> Categories { get; set; }
        public DbSet<Subject> Subjects { get; set; }
        public DbSet<Message> Messages { get; set; }
      //  public DbSet<User> Users { get; set; }
    }*/
}