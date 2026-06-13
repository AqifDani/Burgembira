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
                SqlDataSource2.SelectCommand = @"
                    SELECT ItemId, ItemName, ItemImage, ItemPrice, StockQuantity
                    FROM MenuItems";

                SqlDataSource2.SelectParameters.Clear();
            }
            else
            {
                SqlDataSource2.SelectCommand = @"
                    SELECT ItemId, ItemName, ItemImage, ItemPrice, StockQuantity
                    FROM MenuItems
                    WHERE CategoryId = @CategoryId";

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

                    string connectionString = ConfigurationManager.ConnectionStrings["BurgembiraDB"].ConnectionString;

                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        conn.Open();

                        string itemName = "";
                        string itemImage = "";
                        int stockQuantity = 0;

                        string itemQuery = @"
                            SELECT ItemName, ItemImage, StockQuantity
                            FROM MenuItems
                            WHERE ItemId = @ItemId";

                        using (SqlCommand itemCmd = new SqlCommand(itemQuery, conn))
                        {
                            itemCmd.Parameters.AddWithValue("@ItemId", itemId);

                            using (SqlDataReader reader = itemCmd.ExecuteReader())
                            {
                                if (reader.Read())
                                {
                                    itemName = reader["ItemName"].ToString();
                                    itemImage = reader["ItemImage"].ToString();
                                    stockQuantity = Convert.ToInt32(reader["StockQuantity"]);
                                }
                                else
                                {
                                    ClientScript.RegisterStartupScript(this.GetType(), "ItemError",
                                        "alert('Item not found.');", true);
                                    return;
                                }
                            }
                        }

                        if (stockQuantity <= 0)
                        {
                            ClientScript.RegisterStartupScript(this.GetType(), "OutOfStock",
                                "alert('This item is out of stock.');", true);
                            return;
                        }

                        int existingQty = 0;

                        string checkQuery = @"
                            SELECT Quantity
                            FROM Cart
                            WHERE UserId = @UserId
                            AND ItemId = @ItemId";

                        using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                        {
                            checkCmd.Parameters.AddWithValue("@UserId", userId);
                            checkCmd.Parameters.AddWithValue("@ItemId", itemId);

                            object result = checkCmd.ExecuteScalar();

                            if (result != null)
                            {
                                existingQty = Convert.ToInt32(result);
                            }
                        }

                        int newQty = existingQty + quantityToAdd;

                        if (newQty > stockQuantity)
                        {
                            ClientScript.RegisterStartupScript(this.GetType(), "StockLimit",
                                $"alert('You cannot add more than the available stock. Available stock: {stockQuantity}');", true);
                            return;
                        }

                        if (existingQty > 0)
                        {
                            string updateQuery = @"
                                UPDATE Cart
                                SET Quantity = @Quantity
                                WHERE UserId = @UserId
                                AND ItemId = @ItemId";

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

                    ClientScript.RegisterStartupScript(this.GetType(), "ToastScript", "showToast();", true);
                }
                catch (Exception ex)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "ErrorScript",
                        $"alert('Error: {ex.Message.Replace("'", "")}');", true);
                }
            }
        }

        protected string GetImageUrl(object imageValue)
        {
            string image = imageValue == null ? "" : imageValue.ToString().Trim();

            if (string.IsNullOrWhiteSpace(image))
            {
                return ResolveUrl("~/Images/no-image.png");
            }

            if (image.StartsWith("http://", StringComparison.OrdinalIgnoreCase) ||
                image.StartsWith("https://", StringComparison.OrdinalIgnoreCase))
            {
                return image;
            }

            if (image.StartsWith("~/", StringComparison.OrdinalIgnoreCase))
            {
                return ResolveUrl(image);
            }

            if (image.StartsWith("Images/", StringComparison.OrdinalIgnoreCase) ||
                image.StartsWith("images/", StringComparison.OrdinalIgnoreCase))
            {
                return ResolveUrl("~/" + image);
            }

            return ResolveUrl("~/Images/" + image);
        }
    }
}