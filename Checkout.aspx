<%@ Page Title="" Language="C#" MasterPageFile="~/burgerMaster.Master" AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="Burgembira.Checkout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="checkout-wrapper">
        <h2>🧾 Order Summary</h2>

        <asp:Repeater ID="Repeater1" runat="server">
            <ItemTemplate>
                <div class="checkout-item">
                    <p><strong><%# Eval("ItemName") %></strong></p>
                    <p>Quantity: <%# Eval("Quantity") %></p>
                    <p>Price (RM): <%# Eval("ItemPrice", "{0:N2}") %></p>
                    <p>Total (RM): <%# Eval("TotalPrice", "{0:N2}") %></p>
                    <p>
                        <strong>Notes:</strong>
                        <%# string.IsNullOrWhiteSpace(Eval("Customization")?.ToString()) ? "-" : Eval("Customization") %>
                    </p>
                    <hr />
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <div class="checkout-total">
            <strong>Total Amount (RM):</strong>
            <asp:Label ID="lblTotalAmount" runat="server" Text="0.00" />
        </div>

        <asp:Button ID="btnConfirmCheckout" runat="server" Text="Confirm Checkout"
            CssClass="checkout-btn" OnClick="btnConfirmCheckout_Click" />

        <asp:Panel ID="pnlReceipt" runat="server" Visible="false" CssClass="receipt-panel">
            <asp:Literal ID="litReceipt" runat="server" />
        </asp:Panel>
    </div>
</asp:Content>
