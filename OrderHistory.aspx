<%@ Page Title="Order History" Language="C#" MasterPageFile="~/burgerMaster.Master" AutoEventWireup="true" CodeBehind="OrderHistory.aspx.cs" Inherits="Burgembira.OrderHistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .order-wrapper {
            max-width: 900px;
            margin: 30px auto;
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            font-family: 'Segoe UI', sans-serif;
        }

        .order-title {
            text-align: center;
            color: #d32f2f;
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .status-message {
            text-align: center;
            margin-bottom: 15px;
            font-size: 16px;
            color: #777;
        }

        .gridview-style {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        .gridview-style th, .gridview-style td {
            padding: 12px;
            text-align: left;
        }

        .gridview-style th {
            background-color: #d32f2f;
            color: white;
        }

        .gridview-style tr:nth-child(even) {
            background-color: #f9f9f9;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="order-wrapper">
        <h2 class="order-title">My Order History</h2>

        <asp:Label ID="MessageLabel" runat="server" CssClass="status-message" />

        <asp:GridView ID="GridViewOrderHistory" runat="server" AutoGenerateColumns="False"
            CssClass="gridview-style" GridLines="None">
            <Columns>
                <asp:BoundField DataField="DeliveryID" HeaderText="Order ID" />
                <asp:BoundField DataField="DeliveryDate" HeaderText="Order Date" DataFormatString="{0:dd MMM yyyy hh:mm tt}" />
                <asp:BoundField DataField="Status" HeaderText="Status" />
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
