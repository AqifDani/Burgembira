<%@ Page Title="Order History" Language="C#" MasterPageFile="~/burgerMaster.Master" AutoEventWireup="true" CodeBehind="OrderHistory.aspx.cs" Inherits="Burgembira.OrderHistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="delivery-wrapper">
        <h2 class="delivery-title">📦 My Order History</h2>

        <asp:Label ID="MessageLabel" runat="server" CssClass="status-message" />

        <asp:GridView ID="GridViewOrderHistory" runat="server"
            AutoGenerateColumns="False"
            CssClass="gridview-style"
            GridLines="None"
            OnRowCommand="GridViewOrderHistory_RowCommand">

            <Columns>
                <asp:BoundField DataField="OrderId" HeaderText="Order ID" />

                <asp:BoundField DataField="OrderDate" HeaderText="Order Date"
                    DataFormatString="{0:dd MMM yyyy hh:mm tt}" />

                <asp:BoundField DataField="Items" HeaderText="Items" />

                <asp:BoundField DataField="PaymentMethod" HeaderText="Payment Method" />

                <asp:BoundField DataField="DeliveryStatus" HeaderText="Delivery Status" />

                <asp:BoundField DataField="TotalAmount" HeaderText="Total (RM)"
                    DataFormatString="{0:N2}" />

                <asp:TemplateField HeaderText="Action">
                    <ItemTemplate>
                        <asp:Button ID="btnCancelOrder" runat="server"
                            Text="Cancel"
                            CssClass="remove-btn"
                            CommandName="CancelOrder"
                            CommandArgument='<%# Eval("OrderId") %>'
                            OnClientClick="return confirm('Are you sure you want to cancel this order?');"
                            Enabled='<%# Eval("DeliveryStatus").ToString() != "Delivered" && Eval("DeliveryStatus").ToString() != "Cancelled" %>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

</asp:Content>