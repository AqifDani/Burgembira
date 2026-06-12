using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;

namespace Burgembira
{
    public partial class Homepage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Page load logic (if needed in future)
        }

        protected void AddToCart_Click(object sender, EventArgs e)
        {
            // Get the burger name from the clicked ImageButton
            var button = sender as ImageButton;
            string burgerName = button?.CommandArgument;

            // Retrieve or initialize the cart from session
            List<string> cart = Session["Cart"] as List<string> ?? new List<string>();
            cart.Add(burgerName);

            // Save updated cart back to session
            Session["Cart"] = cart;

            // Redirect to the product listing page
            Response.Redirect("~/ProductListing.aspx");
        }
    }
}
