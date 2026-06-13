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

        protected string GetImageUrl(object imageValue)
        {
            string image = imageValue == null ? "" : imageValue.ToString().Trim();

            if (string.IsNullOrWhiteSpace(image))
            {
                return ResolveUrl("~/images/no-image.png");
            }

            if (image.StartsWith("http://", StringComparison.OrdinalIgnoreCase) ||
                image.StartsWith("https://", StringComparison.OrdinalIgnoreCase))
            {
                return image;
            }

            if (image.StartsWith("~/", StringComparison.OrdinalIgnoreCase))
            {
                return ResolveUrl(image);
            }

            if (image.StartsWith("images/", StringComparison.OrdinalIgnoreCase) ||
                image.StartsWith("Images/", StringComparison.OrdinalIgnoreCase))
            {
                return ResolveUrl("~/" + image);
            }

            return ResolveUrl("~/images/" + image);
        }
    }
}