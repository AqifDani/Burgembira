using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Burgembira
{
    public partial class DeliveryStatus : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                LoadAllDeliveryStatus(); // Load all orders (no filtering by user)
            }
        }

        private void LoadAllDeliveryStatus()
        {
            string connStr = ConfigurationManager.ConnectionStrings["BurgembiraDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT DeliveryID, DeliveryDate, Status 
                                 FROM Delivery"; // Removed WHERE UserId = @UserId

                SqlCommand cmd = new SqlCommand(query, conn);

                try
                {
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        GridViewDelivery.DataSource = dt;
                        GridViewDelivery.DataBind();
                        MessageLabel.Text = "";
                    }
                    else
                    {
                        GridViewDelivery.DataSource = null;
                        GridViewDelivery.DataBind();
                        MessageLabel.Text = "No delivery records found.";
                    }
                }
                catch (Exception ex)
                {
                    MessageLabel.Text = "Error: " + ex.Message;
                }
            }
        }

        protected void GridViewDelivery_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "MarkDelivered")
            {
                int deliveryId = Convert.ToInt32(e.CommandArgument);
                string connStr = ConfigurationManager.ConnectionStrings["BurgembiraDB"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string updateQuery = @"UPDATE Delivery 
                                           SET Status = 'Delivered', DeliveryDate = GETDATE() 
                                           WHERE DeliveryID = @DeliveryID";

                    SqlCommand cmd = new SqlCommand(updateQuery, conn);
                    cmd.Parameters.AddWithValue("@DeliveryID", deliveryId);

                    try
                    {
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        MessageLabel.Text = "Order marked as delivered.";
                        LoadAllDeliveryStatus(); // Refresh the list
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
