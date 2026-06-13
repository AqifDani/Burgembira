<%@ Page Title="Delivery Status" Language="C#" MasterPageFile="~/burgerMaster.Master" AutoEventWireup="true" CodeBehind="DeliveryStatus.aspx.cs" Inherits="Burgembira.DeliveryStatus" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="delivery-wrapper">
        <h2 class="delivery-title">Delivery Status</h2>

        <asp:Label ID="MessageLabel" runat="server" CssClass="status-message" />

        <asp:GridView ID="GridViewDelivery" runat="server" AutoGenerateColumns="False"
    GridLines="None" CellPadding="10"
    CssClass="gridview-style"
    BorderStyle="None"
    OnRowCommand="GridViewDelivery_RowCommand">

    <Columns>
        <asp:BoundField DataField="OrderId" HeaderText="Order ID" />
        <asp:BoundField DataField="OrderDate" HeaderText="Order Date" DataFormatString="{0:dd MMM yyyy hh:mm tt}" />
        <asp:BoundField DataField="PaymentMethod" HeaderText="Payment Method" />
        <asp:BoundField DataField="TotalAmount" HeaderText="Total (RM)" DataFormatString="{0:N2}" />
        <asp:BoundField DataField="DeliveryStatus" HeaderText="Current Delivery Status" />

        <asp:TemplateField HeaderText="Update Status">
            <ItemTemplate>
                <asp:DropDownList ID="ddlDeliveryStatus" runat="server">
                    <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                    <asp:ListItem Text="Preparing" Value="Preparing"></asp:ListItem>
                    <asp:ListItem Text="Out for Delivery" Value="Out for Delivery"></asp:ListItem>
                    <asp:ListItem Text="Delivered" Value="Delivered"></asp:ListItem>
                    <asp:ListItem Text="Cancelled" Value="Cancelled"></asp:ListItem>
                </asp:DropDownList>

                <asp:Button ID="btnUpdateStatus" runat="server"
                    Text="Update"
                    CssClass="grid-button"
                    CommandName="UpdateStatus"
                    CommandArgument='<%# Eval("OrderId") %>' />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>
    </div>
</asp:Content>