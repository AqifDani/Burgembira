using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace Burgembira
{
    public partial class OrderHistory : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadOrderHistory();
            }
        }

        private void LoadOrderHistory()
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            string connStr = ConfigurationManager.ConnectionStrings["BurgembiraDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT 
                        o.OrderID AS OrderId,
                        o.OrderDate AS OrderDate,
                        o.PaymentMethod AS PaymentMethod,
                        o.DeliveryStatus AS DeliveryStatus,
                        o.TotalAmount AS TotalAmount,
                        STUFF((
                            SELECT ', ' + mi.ItemName + ' x' + CAST(od.Quantity AS VARCHAR(10))
                            FROM OrderDetails od
                            INNER JOIN MenuItems mi ON od.ItemId = mi.ItemId
                            WHERE od.OrderID = o.OrderID
                            FOR XML PATH(''), TYPE
                        ).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS Items
                    FROM Orders o
                    WHERE o.UserId = @UserId
                    ORDER BY o.OrderDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
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

        protected void GridViewOrderHistory_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "CancelOrder")
            {
                int orderId = Convert.ToInt32(e.CommandArgument);
                int userId = Convert.ToInt32(Session["UserId"]);
                string connStr = ConfigurationManager.ConnectionStrings["BurgembiraDB"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"
                        UPDATE Orders
                        SET DeliveryStatus = 'Cancelled',
                            OrderStatus = 'Cancelled'
                        WHERE OrderID = @OrderId
                        AND UserId = @UserId
                        AND DeliveryStatus NOT IN ('Delivered', 'Cancelled')";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@OrderId", orderId);
                        cmd.Parameters.AddWithValue("@UserId", userId);

                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            MessageLabel.Text = "Order cancelled successfully.";
                        }
                        else
                        {
                            MessageLabel.Text = "This order cannot be cancelled.";
                        }
                    }
                }

                LoadOrderHistory();
            }
        }
    }
}