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

                if (Session["CheckoutComplete"] != null && (bool)Session["CheckoutComplete"])
                {
                    ShowAlert("You have already checked out!");
                }
                else
                {
                    Session["CheckoutComplete"] = false;
                }
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
                        total += Convert.ToDecimal(row["TotalPrice"]);
                }
            }

            Repeater1.DataSource = cartTable;
            Repeater1.DataBind();
            lblTotalAmount.Text = total.ToString("N2");
        }

        protected void btnConfirmCheckout_Click(object sender, EventArgs e)
        {
            if (Session["CheckoutComplete"] != null && (bool)Session["CheckoutComplete"])
            {
                ShowAlert("You have already checked out!");
                return;
            }

            string paymentMethod = rblPaymentMethod.SelectedValue;

            Session["CheckoutComplete"] = true;

            string connStr = ConfigurationManager.ConnectionStrings["BurgembiraDB"].ConnectionString;
            decimal total = 0;
            StringBuilder receipt = new StringBuilder();

            receipt.Append("<div style='font-family:Poppins,sans-serif;'>");
            receipt.Append("<p><strong>Date:</strong> " + DateTime.Now.ToString("dd MMM yyyy hh:mm tt") + "</p>");
            receipt.Append($"<p><strong>Payment Method:</strong> {paymentMethod}</p>");
            receipt.Append("<table style='width:100%; border-collapse:collapse;'>");
            receipt.Append("<tr><th style='text-align:left;'>Item</th><th style='text-align:center;'>Qty</th><th style='text-align:left;'>Notes</th><th style='text-align:right;'>Total (RM)</th></tr>");

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                using (SqlCommand cmd = new SqlCommand("sp_Cart", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string itemName = reader["ItemName"].ToString();
                            int qty = Convert.ToInt32(reader["Quantity"]);
                            decimal price = Convert.ToDecimal(reader["TotalPrice"]);
                            string notes = reader["Customization"] != DBNull.Value ? reader["Customization"].ToString() : "-";

                            total += price;
                            receipt.Append($"<tr><td>{itemName}</td><td style='text-align:center;'>{qty}</td><td>{notes}</td><td style='text-align:right;'>{price:N2}</td></tr>");
                        }
                    }
                }

                using (SqlCommand insertCmd = new SqlCommand(
                    "INSERT INTO Delivery (UserId, DeliveryDate) VALUES (@UserId, @DeliveryDate)", conn))
                {
                    insertCmd.Parameters.AddWithValue("@UserId", userId);
                    insertCmd.Parameters.AddWithValue("@DeliveryDate", DateTime.Now);
                    insertCmd.ExecuteNonQuery();
                }

                using (SqlCommand clearCmd = new SqlCommand(
                    "DELETE FROM Cart WHERE UserId = @UserId", conn))
                {
                    clearCmd.Parameters.AddWithValue("@UserId", userId);
                    clearCmd.ExecuteNonQuery();
                }

                conn.Close();
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

        private void ShowAlert(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alert", $"alert('{message}');", true);
        }
    }
}

