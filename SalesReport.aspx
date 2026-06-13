<%@ Page Title="Sales Report" Language="C#" MasterPageFile="~/burgerMaster.Master" AutoEventWireup="true" CodeBehind="SalesReport.aspx.cs" Inherits="Burgembira.SalesReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="delivery-wrapper">
        <h2 class="delivery-title">Sales Report</h2>

        <asp:Label ID="MessageLabel" runat="server" CssClass="status-message" />

        <div style="text-align:center; margin-bottom:20px;">
            <p><strong>Total Orders:</strong> <asp:Label ID="lblTotalOrders" runat="server" Text="0" /></p>
            <p><strong>Total Sales:</strong> RM <asp:Label ID="lblTotalSales" runat="server" Text="0.00" /></p>
        </div>

        <asp:GridView ID="GridViewSales" runat="server" AutoGenerateColumns="False"
            CssClass="gridview-style" GridLines="None">

            <Columns>
                <asp:BoundField DataField="OrderId" HeaderText="Order ID" />
                <asp:BoundField DataField="CustomerName" HeaderText="Customer" />
                <asp:BoundField DataField="OrderDate" HeaderText="Order Date" DataFormatString="{0:dd MMM yyyy hh:mm tt}" />
                <asp:BoundField DataField="PaymentMethod" HeaderText="Payment Method" />
                <asp:BoundField DataField="DeliveryStatus" HeaderText="Delivery Status" />
                <asp:BoundField DataField="TotalAmount" HeaderText="Total (RM)" DataFormatString="{0:N2}" />
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>