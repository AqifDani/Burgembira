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
            if (Session["isAdmin"] == null || !(bool)Session["isAdmin"])
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadAllDeliveryStatus();
            }
        }

        private void LoadAllDeliveryStatus()
        {
            string connStr = ConfigurationManager.ConnectionStrings["BurgembiraDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT 
                        OrderID AS OrderId,
                        OrderDate AS OrderDate,
                        PaymentMethod AS PaymentMethod,
                        TotalAmount AS TotalAmount,
                        DeliveryStatus AS DeliveryStatus
                    FROM Orders
                    ORDER BY OrderDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
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
                            MessageLabel.Text = "No delivery status found.";
                        }
                    }
                    catch (Exception ex)
                    {
                        MessageLabel.Text = "Error: " + ex.Message;
                    }
                }
            }
        }

        protected void GridViewDelivery_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "UpdateStatus")
            {
                int orderId = Convert.ToInt32(e.CommandArgument);

                System.Web.UI.WebControls.Button btn = (System.Web.UI.WebControls.Button)e.CommandSource;
                System.Web.UI.WebControls.GridViewRow row = (System.Web.UI.WebControls.GridViewRow)btn.NamingContainer;

                System.Web.UI.WebControls.DropDownList ddlStatus =
                    (System.Web.UI.WebControls.DropDownList)row.FindControl("ddlDeliveryStatus");

                string newStatus = ddlStatus.SelectedValue;

                string connStr = ConfigurationManager.ConnectionStrings["BurgembiraDB"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string updateQuery = @"
                UPDATE Orders
                SET DeliveryStatus = @DeliveryStatus
                WHERE OrderID = @OrderId";

                    using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@DeliveryStatus", newStatus);
                        cmd.Parameters.AddWithValue("@OrderId", orderId);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                MessageLabel.Text = "Delivery status updated successfully.";
                LoadAllDeliveryStatus();
            }
        }
    }
}