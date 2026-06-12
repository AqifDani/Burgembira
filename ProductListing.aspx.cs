using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace Burgembira
{
    public partial class ProductListing : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadProducts();
            }
        }

        protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadProducts();
        }

        private void LoadProducts()
        {
            string selectedValue = DropDownList1.SelectedValue;

            if (selectedValue == "0")
            {
                SqlDataSource2.SelectCommand = "SELECT ItemId, ItemName, ItemImage, ItemPrice FROM MenuItems";
                SqlDataSource2.SelectParameters.Clear();
            }
            else
            {
                SqlDataSource2.SelectCommand = "SELECT ItemId, ItemName, ItemImage, ItemPrice FROM MenuItems WHERE CategoryId = @CategoryId";
                SqlDataSource2.SelectParameters.Clear();
                SqlDataSource2.SelectParameters.Add("CategoryId", TypeCode.Int32, selectedValue);
            }

            DataList1.DataBind();
        }

        protected void DataList1_ItemCommand(object source, DataListCommandEventArgs e)
        {
            if (e.CommandName == "AddToCart")
            {
                if (Session["UserId"] == null)
                {
                    string script = @"
                alert('You have not logged in. Please log in first.');
                window.location.href = 'Login.aspx';";
                    ClientScript.RegisterStartupScript(this.GetType(), "LoginAlert", script, true);
                    return;
                }

                try
                {
                    int userId = Convert.ToInt32(Session["UserId"]);
                    int itemId = Convert.ToInt32(e.CommandArgument);
                    int quantityToAdd = 1;

                    Label lblName = (Label)e.Item.FindControl("ItemNameLabel");
                    Image img = (Image)e.Item.FindControl("ItemImage");

                    string itemName = lblName.Text;
                    string itemImage = img.ImageUrl;

                    string connectionString = ConfigurationManager.ConnectionStrings["BurgembiraDB"].ConnectionString;
                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        conn.Open();

                        string checkQuery = "SELECT Quantity FROM Cart WHERE UserId = @UserId AND ItemId = @ItemId";
                        using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                        {
                            checkCmd.Parameters.AddWithValue("@UserId", userId);
                            checkCmd.Parameters.AddWithValue("@ItemId", itemId);

                            object result = checkCmd.ExecuteScalar();

                            if (result != null)
                            {
                                int existingQty = Convert.ToInt32(result);
                                int newQty = existingQty + quantityToAdd;

                                string updateQuery = "UPDATE Cart SET Quantity = @Quantity WHERE UserId = @UserId AND ItemId = @ItemId";
                                using (SqlCommand updateCmd = new SqlCommand(updateQuery, conn))
                                {
                                    updateCmd.Parameters.AddWithValue("@Quantity", newQty);
                                    updateCmd.Parameters.AddWithValue("@UserId", userId);
                                    updateCmd.Parameters.AddWithValue("@ItemId", itemId);
                                    updateCmd.ExecuteNonQuery();
                                }
                            }
                            else
                            {
                                string insertQuery = @"
                            INSERT INTO Cart (UserId, ItemId, ItemName, ItemImage, Quantity)
                            VALUES (@UserId, @ItemId, @ItemName, @ItemImage, @Quantity)";
                                using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                                {
                                    insertCmd.Parameters.AddWithValue("@UserId", userId);
                                    insertCmd.Parameters.AddWithValue("@ItemId", itemId);
                                    insertCmd.Parameters.AddWithValue("@ItemName", itemName);
                                    insertCmd.Parameters.AddWithValue("@ItemImage", itemImage);
                                    insertCmd.Parameters.AddWithValue("@Quantity", quantityToAdd);
                                    insertCmd.ExecuteNonQuery();
                                }
                            }
                        }

                        conn.Close();
                    }

                    // ✅ Trigger toast after successful add
                    ClientScript.RegisterStartupScript(this.GetType(), "ToastScript", "showToast();", true);
                }
                catch (Exception ex)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "ErrorScript", $"alert('Error: {ex.Message}');", true);
                }
            }
        }

    }
}
