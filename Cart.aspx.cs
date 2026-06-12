using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace Burgembira
{
    public partial class Cart : System.Web.UI.Page
    {
        int userId;

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
                SqlDataSource1.SelectParameters["UserId"].DefaultValue = userId.ToString();
                DataList1.DataBind();
            }
        }

        protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            decimal total = 0;
            string connStr = ConfigurationManager.ConnectionStrings["BurgembiraDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("sp_Cart", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@UserId", userId);

                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        if (reader["TotalPrice"] != DBNull.Value)
                        {
                            total += Convert.ToDecimal(reader["TotalPrice"]);
                        }
                    }
                }
            }

            lblTotal.Text = total.ToString("N2");
            PanelTotal.Visible = total > 0;
            litEmptyCart.Visible = total == 0;
            PanelCheckout.Visible = total > 0;
        }

        protected void DataList1_ItemCommand(object source, DataListCommandEventArgs e)
        {
            string itemName = e.CommandArgument.ToString();

            if (e.CommandName == "Remove")
            {
                string connStr = ConfigurationManager.ConnectionStrings["BurgembiraDB"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string selectQuery = "SELECT Quantity FROM Cart WHERE UserId = @UserId AND ItemName = @ItemName";
                    using (SqlCommand selectCmd = new SqlCommand(selectQuery, conn))
                    {
                        selectCmd.Parameters.AddWithValue("@UserId", userId);
                        selectCmd.Parameters.AddWithValue("@ItemName", itemName);
                        object result = selectCmd.ExecuteScalar();

                        if (result != null)
                        {
                            int quantity = Convert.ToInt32(result);
                            if (quantity > 1)
                            {
                                string updateQuery = "UPDATE Cart SET Quantity = Quantity - 1 WHERE UserId = @UserId AND ItemName = @ItemName";
                                using (SqlCommand updateCmd = new SqlCommand(updateQuery, conn))
                                {
                                    updateCmd.Parameters.AddWithValue("@UserId", userId);
                                    updateCmd.Parameters.AddWithValue("@ItemName", itemName);
                                    updateCmd.ExecuteNonQuery();
                                }
                            }
                            else
                            {
                                string deleteQuery = "DELETE FROM Cart WHERE UserId = @UserId AND ItemName = @ItemName";
                                using (SqlCommand deleteCmd = new SqlCommand(deleteQuery, conn))
                                {
                                    deleteCmd.Parameters.AddWithValue("@UserId", userId);
                                    deleteCmd.Parameters.AddWithValue("@ItemName", itemName);
                                    deleteCmd.ExecuteNonQuery();
                                }
                            }
                        }
                    }
                }

                RefreshCart();
            }

            else if (e.CommandName == "Update")
            {
                TextBox txtQuantity = (TextBox)e.Item.FindControl("txtQuantity");
                TextBox txtNotes = (TextBox)e.Item.FindControl("txtNotes");

                int newQty = int.TryParse(txtQuantity.Text, out int q) ? q : 1;
                newQty = Math.Max(1, Math.Min(newQty, 10)); // Clamp 1–10

                string notes = txtNotes.Text.Trim();
                if (notes.Length > 255) notes = notes.Substring(0, 255);

                UpdateCartItem(itemName, newQty, notes);
                RefreshCart();
            }
        }

        private void RefreshCart()
        {
            SqlDataSource1.SelectParameters["UserId"].DefaultValue = userId.ToString();
            DataList1.DataBind();
            SqlDataSource1_Selected(null, null);
        }

        private void UpdateCartItem(string itemName, int quantity, string customization)
        {
            string connStr = ConfigurationManager.ConnectionStrings["BurgembiraDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string updateQuery = "UPDATE Cart SET Quantity = @Quantity, Customization = @Customization WHERE UserId = @UserId AND ItemName = @ItemName";

                using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@Quantity", quantity);
                    cmd.Parameters.AddWithValue("@Customization", customization);
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@ItemName", itemName);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        protected void BtnCheckout_Click(object sender, EventArgs e)
        {
            Response.Redirect("Checkout.aspx");
        }
    }
}
