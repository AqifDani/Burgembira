using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;

namespace Burgembira
{
    public partial class Checkout : System.Web.UI.Page
    {
        private int userId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            userId = Convert.ToInt32(Session["UserId"]);

            if (!IsPostBack)
            {
                LoadCartData();
            }
        }

        private void LoadCartData()
        {
            string connStr = ConfigurationManager.ConnectionStrings["BurgembiraDB"].ConnectionString;
            DataTable cartTable = new DataTable();
            decimal total = 0;

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("sp_Cart", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserId", userId);

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                adapter.Fill(cartTable);

                foreach (DataRow row in cartTable.Rows)
                {
                    if (row["TotalPrice"] != DBNull.Value)
                    {
                        total += Convert.ToDecimal(row["TotalPrice"]);
                    }
                }
            }

            Repeater1.DataSource = cartTable;
            Repeater1.DataBind();
            lblTotalAmount.Text = total.ToString("N2");
        }

        protected void btnConfirmCheckout_Click(object sender, EventArgs e)
        {
            string paymentMethod = rblPaymentMethod.SelectedValue;
            string connStr = ConfigurationManager.ConnectionStrings["BurgembiraDB"].ConnectionString;

            decimal total = 0;
            int orderId = 0;
            StringBuilder receipt = new StringBuilder();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                DataTable cartTable = new DataTable();

                using (SqlCommand cartCmd = new SqlCommand("sp_Cart", conn))
                {
                    cartCmd.CommandType = CommandType.StoredProcedure;
                    cartCmd.Parameters.AddWithValue("@UserId", userId);

                    SqlDataAdapter adapter = new SqlDataAdapter(cartCmd);
                    adapter.Fill(cartTable);
                }

                if (cartTable.Rows.Count == 0)
                {
                    ShowAlert("Your cart is empty.");
                    return;
                }

                foreach (DataRow row in cartTable.Rows)
                {
                    if (row["TotalPrice"] != DBNull.Value)
                    {
                        total += Convert.ToDecimal(row["TotalPrice"]);
                    }
                }

                SqlTransaction transaction = conn.BeginTransaction();

                try
                {
                    using (SqlCommand orderCmd = new SqlCommand(
                        @"INSERT INTO Orders 
                          (UserId, OrderDate, OrderStatus, TotalAmount, PaymentMethod, DeliveryStatus)
                          OUTPUT INSERTED.OrderId
                          VALUES 
                          (@UserId, @OrderDate, @OrderStatus, @TotalAmount, @PaymentMethod, @DeliveryStatus)", conn, transaction))
                    {
                        orderCmd.Parameters.AddWithValue("@UserId", userId);
                        orderCmd.Parameters.AddWithValue("@OrderDate", DateTime.Now);
                        orderCmd.Parameters.AddWithValue("@OrderStatus", "Pending");
                        orderCmd.Parameters.AddWithValue("@TotalAmount", total);
                        orderCmd.Parameters.AddWithValue("@PaymentMethod", paymentMethod);
                        orderCmd.Parameters.AddWithValue("@DeliveryStatus", "Pending");

                        orderId = Convert.ToInt32(orderCmd.ExecuteScalar());
                    }

                    using (SqlCommand detailCmd = new SqlCommand(
                        @"INSERT INTO OrderDetails 
                          (OrderId, ItemId, Quantity, ItemPrice)
                          SELECT 
                              @OrderId,
                              c.ItemId,
                              c.Quantity,
                              m.ItemPrice
                          FROM Cart c
                          INNER JOIN MenuItems m ON c.ItemId = m.ItemId
                          WHERE c.UserId = @UserId", conn, transaction))
                    {
                        detailCmd.Parameters.AddWithValue("@OrderId", orderId);
                        detailCmd.Parameters.AddWithValue("@UserId", userId);
                        detailCmd.ExecuteNonQuery();
                    }

                    using (SqlCommand clearCmd = new SqlCommand(
                        "DELETE FROM Cart WHERE UserId = @UserId", conn, transaction))
                    {
                        clearCmd.Parameters.AddWithValue("@UserId", userId);
                        clearCmd.ExecuteNonQuery();
                    }

                    transaction.Commit();
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    ShowAlert("Checkout failed: " + ex.Message.Replace("'", ""));
                    return;
                }

                receipt.Append("<div style='font-family:Poppins,sans-serif;'>");
                receipt.Append($"<p><strong>Order ID:</strong> {orderId}</p>");
                receipt.Append("<p><strong>Date:</strong> " + DateTime.Now.ToString("dd MMM yyyy hh:mm tt") + "</p>");
                receipt.Append($"<p><strong>Payment Method:</strong> {paymentMethod}</p>");
                receipt.Append("<table style='width:100%; border-collapse:collapse;'>");
                receipt.Append("<tr><th style='text-align:left;'>Item</th><th style='text-align:center;'>Qty</th><th style='text-align:left;'>Notes</th><th style='text-align:right;'>Total (RM)</th></tr>");

                foreach (DataRow row in cartTable.Rows)
                {
                    string itemName = row["ItemName"].ToString();
                    int qty = Convert.ToInt32(row["Quantity"]);
                    decimal price = Convert.ToDecimal(row["TotalPrice"]);
                    string notes = row["Customization"] != DBNull.Value ? row["Customization"].ToString() : "-";

                    receipt.Append($"<tr><td>{itemName}</td><td style='text-align:center;'>{qty}</td><td>{notes}</td><td style='text-align:right;'>{price:N2}</td></tr>");
                }

                receipt.Append("</table>");
                receipt.Append($"<p style='text-align:right; font-weight:bold; font-size:18px;'>Total Paid: RM {total:N2}</p>");
                receipt.Append("<p style='text-align:center; color:#D32F2F;'>🍔 THANK YOU FOR ORDERING WITH BURGEMBIRA!</p>");
                receipt.Append("</div>");

                litReceipt.Text = receipt.ToString();
                pnlReceipt.Visible = true;

                Repeater1.DataSource = null;
                Repeater1.DataBind();
                lblTotalAmount.Text = "0.00";
            }
        }

        private void ShowAlert(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alert", $"alert('{message}');", true);
        }
    }
}