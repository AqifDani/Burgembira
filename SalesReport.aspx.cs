using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace Burgembira
{
    public partial class SalesReport : System.Web.UI.Page
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
                LoadSalesReport();
            }
        }

        private void LoadSalesReport()
        {
            string connStr = ConfigurationManager.ConnectionStrings["BurgembiraDB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT 
                        o.OrderID AS OrderId,
                        ISNULL(u.Username, 'Unknown Customer') AS CustomerName,
                        o.OrderDate AS OrderDate,
                        o.PaymentMethod AS PaymentMethod,
                        o.DeliveryStatus AS DeliveryStatus,
                        o.TotalAmount AS TotalAmount
                    FROM Orders o
                    LEFT JOIN Users u ON o.UserId = u.UserId
                    ORDER BY o.OrderDate DESC";

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
                            GridViewSales.DataSource = dt;
                            GridViewSales.DataBind();

                            lblTotalOrders.Text = dt.Rows.Count.ToString();

                            decimal totalSales = 0;

                            foreach (DataRow row in dt.Rows)
                            {
                                if (row["TotalAmount"] != DBNull.Value)
                                {
                                    totalSales += Convert.ToDecimal(row["TotalAmount"]);
                                }
                            }

                            lblTotalSales.Text = totalSales.ToString("N2");
                            MessageLabel.Text = "";
                        }
                        else
                        {
                            GridViewSales.DataSource = null;
                            GridViewSales.DataBind();

                            lblTotalOrders.Text = "0";
                            lblTotalSales.Text = "0.00";
                            MessageLabel.Text = "No sales records found.";
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
}