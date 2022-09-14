using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Owin;
using OurReddit.Models;
using Owin;

[assembly: OwinStartupAttribute(typeof(OurReddit.Startup))]
namespace OurReddit
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
            CreateRoles();
        }

        private void CreateRoles()
        {
            ApplicationDbContext context = new ApplicationDbContext();

            var roleManager = new RoleManager<IdentityRole>(new RoleStore<IdentityRole>(context));

            var UserManager = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(context));

            // adaug roluri
            if (!roleManager.RoleExists("Admin"))
            {
                //adaug rol admin
                var role = new IdentityRole();
                role.Name = "Admin";
                roleManager.Create(role);

                //adaug user admin
                var user = new ApplicationUser();
                user.UserName = "admin@gmail.com";
                user.Email = "admin@gmail.com";

                var adminCreated = UserManager.Create(user, "Beluga1!"); // :)

                if (adminCreated.Succeeded)
                {
                    UserManager.AddToRole(user.Id, "Admin");
                }
            }
            // adaug rol user
            if (!roleManager.RoleExists("User"))
            {
                var role = new IdentityRole();
                role.Name = "User";
                roleManager.Create(role);
            }

            if (!roleManager.RoleExists("Moderator"))
            {
                //adaug rol admin
                var role = new IdentityRole();
                role.Name = "Moderator";
                roleManager.Create(role);

                //adaug user admin
                var user = new ApplicationUser();
                user.UserName = "moderator@gmail.com";
                user.Email = "moderator@gmail.com";

                var adminCreated = UserManager.Create(user, "Beluga1!"); // :)

                if (adminCreated.Succeeded)
                {
                    UserManager.AddToRole(user.Id, "Moderator");
                }
            }

            //TODO: Adauga rol Moderator, Guest
            /***** Ce fac rolurile ******/
            /*
             * Admin: da altora drepturi de mod
             *        poate edita orice
             *        poate adauga, sterge useri
             * Moderator: Poate modifica, sterge orice mesaj
             * User: Poate posta, edita, sterge ce posteaza
             *       Isi poate vedea si edita profilul
             * Guest: Poate vedea toate mesajele, in rest nimic
             */

        }
    }
}
