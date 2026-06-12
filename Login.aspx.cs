using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;

namespace Burgembira
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            string username = Username.Text.Trim();
            string password = Password.Text.Trim();

            if (IsValidUser(username, password))
            {
                int userId = GetUserID(username, password);
                bool isAdmin = IsAdminUser(username, password);

                Session["Username"] = username;
                Session["UserID"] = userId;
                Session["isAdmin"] = isAdmin;

                HttpCookie userCookie = new HttpCookie("Username", username)
                {
                    Expires = DateTime.Now.AddDays(30)
                };
                Response.Cookies.Add(userCookie);

                // Redirect based on role
                if (isAdmin)
                {
                    Response.Redirect("Homepage.aspx"); // change if needed
                }
                else
                {
                    Response.Redirect("Homepage.aspx");
                }
            }
            else
            {
                ErrorMessage.Text = "Invalid username or password.";
            }
        }

        private bool IsValidUser(string username, string password)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["BurgembiraDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM Users WHERE Username = @Username AND Password = @Password";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Username", username);
                cmd.Parameters.AddWithValue("@Password", password);

                conn.Open();
                int count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }

        private int GetUserID(string username, string password)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["BurgembiraDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT UserID FROM Users WHERE Username = @Username AND Password = @Password";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Username", username);
                cmd.Parameters.AddWithValue("@Password", password);

                conn.Open();
                object result = cmd.ExecuteScalar();
                return result != null ? Convert.ToInt32(result) : -1;
            }
        }

        private bool IsAdminUser(string username, string password)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["BurgembiraDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                string query = "SELECT IsAdmin FROM Users WHERE Username = @Username AND Password = @Password";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Username", username);
                cmd.Parameters.AddWithValue("@Password", password);

                conn.Open();
                object result = cmd.ExecuteScalar();
                return result != null && Convert.ToBoolean(result);
            }
        }
    }
}
