using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

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
                LoadYearDropdown();
                LoadSalesReport();
            }
        }

        private void LoadYearDropdown()
        {
            ddlYear.Items.Clear();
            ddlYear.Items.Add(new ListItem("All Years", "0"));

            int currentYear = DateTime.Now.Year;

            for (int year = currentYear; year >= currentYear - 5; year--)
            {
                ddlYear.Items.Add(new ListItem(year.ToString(), year.ToString()));
            }
        }

        protected void btnGenerate_Click(object sender, EventArgs e)
        {
            LoadSalesReport();
        }

        private void LoadSalesReport()
        {
            string connStr = ConfigurationManager.ConnectionStrings["BurgembiraDB"].ConnectionString;

            int selectedMonth = Convert.ToInt32(ddlMonth.SelectedValue);
            int selectedYear = Convert.ToInt32(ddlYear.SelectedValue);

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
                    WHERE 
                        (@Month = 0 OR MONTH(o.OrderDate) = @Month)
                        AND (@Year = 0 OR YEAR(o.OrderDate) = @Year)
                    ORDER BY o.OrderDate DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Month", selectedMonth);
                    cmd.Parameters.AddWithValue("@Year", selectedYear);

                    try
                    {
                        conn.Open();

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

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

                        MessageLabel.Text = dt.Rows.Count > 0 ? "" : "No sales records found for the selected period.";
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