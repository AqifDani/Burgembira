using System;

namespace Burgembira
{
    public partial class ProductListingAdmin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["isAdmin"] == null || !(bool)Session["isAdmin"])
            {
                Response.Redirect("Login.aspx");
                return;
            }
        }
    }
}