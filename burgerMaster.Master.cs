using System;

namespace ByNao
{
    public partial class Site1 : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Hide all placeholders by default
                phGuest.Visible = false;
                phCustomer.Visible = false;
                phAdmin.Visible = false;
                phCommonLoggedIn.Visible = false;

                // Check if the user is logged in
                if (Session["username"] == null)
                {
                    // User not logged in
                    phGuest.Visible = true;
                }
                else
                {
                    // User is logged in
                    string username = Session["username"].ToString();
                    lblWelcome.Text = $" Welcome, {username}!";

                    phCommonLoggedIn.Visible = true;

                    // Check if isAdmin is set and true
                    bool isAdmin = Session["isAdmin"] != null && (bool)Session["isAdmin"];

                    if (isAdmin)
                    {
                        phAdmin.Visible = true;
                    }
                    else
                    {
                        phCustomer.Visible = true;
                    }
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // Clear all session variables
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}
