using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Burgembira
{
    public partial class OrderHistory : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserId"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                LoadOrderHistory();
            }
        }

        private void LoadOrderHistory()
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            string connStr = ConfigurationManager.ConnectionStrings["BurgembiraDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT DeliveryID, DeliveryDate, Status 
                                 FROM Delivery 
                                 WHERE UserId = @UserId 
                                 ORDER BY DeliveryDate DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserId", userId);

                try
                {
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        GridViewOrderHistory.DataSource = dt;
                        GridViewOrderHistory.DataBind();
                        MessageLabel.Text = "";
                    }
                    else
                    {
                        GridViewOrderHistory.DataSource = null;
                        GridViewOrderHistory.DataBind();
                        MessageLabel.Text = "You have no previous orders.";
                    }
                }
                catch (Exception ex)
                {
                    MessageLabel.Text = "Error: " + ex.Message;
                }
            }
        }
    }
}
