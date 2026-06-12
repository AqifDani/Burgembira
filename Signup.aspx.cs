using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace Burgembira
{
    public partial class Signup : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void RegisterBtn_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string name = TextBoxName.Text.Trim();
                string username = TextBoxUsername.Text.Trim();
                string email = TextBoxEmail.Text.Trim();
                string password = TextBoxPassword.Text.Trim();
                string phone = TextBoxPhone.Text.Trim();
                string address = TextBoxAddress.Text.Trim();

                string connectionString = ConfigurationManager.ConnectionStrings["BurgembiraDB"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    string query = @"INSERT INTO Users 
                    (Name, Username, Email, Password, PhoneNumber, Address)
                    VALUES (@Name, @Username, @Email, @Password, @Phone, @Address)";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Name", name);
                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", password);
                    cmd.Parameters.AddWithValue("@Phone", phone);
                    cmd.Parameters.AddWithValue("@Address", address);

                    try
                    {
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        MessageLabel.ForeColor = System.Drawing.Color.Green;
                        MessageLabel.Text = "Registration successful. You may now log in.";
                        Response.Redirect("Login.aspx");
                    }
                    catch (Exception ex)
                    {
                        MessageLabel.Text = "Error: " + ex.Message;
                    }
                }
            }
        }
    }
}