using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace Burgembira
{
    public partial class Review : System.Web.UI.Page
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
                LoadUserOrders();
                LoadReviews();
            }
        }

        private void LoadUserOrders()
        {
            ddlOrders.Items.Clear();
            ddlOrders.Items.Add(new ListItem("General Review", "0"));

            string connStr = ConfigurationManager.ConnectionStrings["BurgembiraDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT OrderID, OrderDate, TotalAmount
                    FROM Orders
                    WHERE UserId = @UserId
                    ORDER BY OrderDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string orderId = reader["OrderID"].ToString();
                            DateTime orderDate = Convert.ToDateTime(reader["OrderDate"]);
                            decimal totalAmount = Convert.ToDecimal(reader["TotalAmount"]);

                            string text = "Order #" + orderId + " - " +
                                          orderDate.ToString("dd MMM yyyy") +
                                          " - RM " + totalAmount.ToString("N2");

                            ddlOrders.Items.Add(new ListItem(text, orderId));
                        }
                    }
                }
            }
        }

        protected void btnSubmitReview_Click(object sender, EventArgs e)
        {
            string comment = txtComment.Text.Trim();

            if (string.IsNullOrWhiteSpace(comment))
            {
                MessageLabel.Text = "Please write a review comment.";
                return;
            }

            int rating = Convert.ToInt32(ddlRating.SelectedValue);
            int selectedOrderId = Convert.ToInt32(ddlOrders.SelectedValue);

            string connStr = ConfigurationManager.ConnectionStrings["BurgembiraDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                if (selectedOrderId != 0)
                {
                    string checkOrderQuery = @"
                        SELECT COUNT(*)
                        FROM Orders
                        WHERE OrderID = @OrderId
                        AND UserId = @UserId";

                    using (SqlCommand checkOrderCmd = new SqlCommand(checkOrderQuery, conn))
                    {
                        checkOrderCmd.Parameters.AddWithValue("@OrderId", selectedOrderId);
                        checkOrderCmd.Parameters.AddWithValue("@UserId", userId);

                        int orderCount = Convert.ToInt32(checkOrderCmd.ExecuteScalar());

                        if (orderCount == 0)
                        {
                            MessageLabel.Text = "Invalid order selected.";
                            return;
                        }
                    }
                }

                string insertQuery = @"
                    INSERT INTO Reviews (UserId, OrderId, Rating, Comment, ReviewDate)
                    VALUES (@UserId, @OrderId, @Rating, @Comment, @ReviewDate)";

                using (SqlCommand cmd = new SqlCommand(insertQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    if (selectedOrderId == 0)
                    {
                        cmd.Parameters.AddWithValue("@OrderId", DBNull.Value);
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@OrderId", selectedOrderId);
                    }

                    cmd.Parameters.AddWithValue("@Rating", rating);
                    cmd.Parameters.AddWithValue("@Comment", comment);
                    cmd.Parameters.AddWithValue("@ReviewDate", DateTime.Now);

                    cmd.ExecuteNonQuery();
                }
            }

            txtComment.Text = "";
            ddlRating.SelectedValue = "5";
            ddlOrders.SelectedValue = "0";

            MessageLabel.Text = "Review submitted successfully.";

            LoadReviews();
        }

        private void LoadReviews()
        {
            string connStr = ConfigurationManager.ConnectionStrings["BurgembiraDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT 
                        r.ReviewId,
                        ISNULL(u.Username, 'Unknown Customer') AS CustomerName,
                        ISNULL(CAST(r.OrderId AS VARCHAR(20)), '-') AS OrderId,
                        r.Rating,
                        r.Comment,
                        r.ReviewDate
                    FROM Reviews r
                    LEFT JOIN Users u ON r.UserId = u.UserId
                    ORDER BY r.ReviewDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    GridViewReviews.DataSource = dt;
                    GridViewReviews.DataBind();
                }
            }
        }
    }
}