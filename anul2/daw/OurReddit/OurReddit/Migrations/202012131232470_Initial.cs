namespace OurReddit.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Initial : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Subjects", "UserId", c => c.String(maxLength: 128));
            CreateIndex("dbo.Subjects", "UserId");
            AddForeignKey("dbo.Subjects", "UserId", "dbo.AspNetUsers", "Id");
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.Subjects", "UserId", "dbo.AspNetUsers");
            DropIndex("dbo.Subjects", new[] { "UserId" });
            DropColumn("dbo.Subjects", "UserId");
        }
    }
}
