<%@ Page Title="" Language="C#" MasterPageFile="~/burgerMaster.Master" AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="Burgembira.Checkout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Panel ID="pnlCheckoutForm" runat="server">
        <div class="checkout-wrapper">

            <h2>🧾 Order Summary</h2>

            <asp:Repeater ID="Repeater1" runat="server">
                <ItemTemplate>
                    <div class="checkout-item">

                        <div style="display:flex; justify-content:space-between; gap:16px; flex-wrap:wrap;">
                            <div>
                                <p style="font-size:18px; color:#d62828;">
                                    <strong><%# Eval("ItemName") %></strong>
                                </p>

                                <p>
                                    <strong>Quantity:</strong>
                                    <%# Eval("Quantity") %>
                                </p>

                                <p>
                                    <strong>Price:</strong>
                                    RM <%# Eval("ItemPrice", "{0:N2}") %>
                                </p>
                            </div>

                            <div style="text-align:right;">
                                <p style="font-size:18px;">
                                    <strong>Total:</strong>
                                </p>

                                <p style="font-size:20px; color:#d62828; font-weight:800;">
                                    RM <%# Eval("TotalPrice", "{0:N2}") %>
                                </p>
                            </div>
                        </div>

                        <div style="margin-top:12px; background:#fff3e3; padding:12px 14px; border-radius:12px;">
                            <strong>Notes:</strong>
                            <%# string.IsNullOrWhiteSpace(Eval("Customization")?.ToString()) ? "-" : Eval("Customization") %>
                        </div>

                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <div class="checkout-total">
                <strong>Total Amount:</strong>
                RM <asp:Label ID="lblTotalAmount" runat="server" Text="0.00" />
            </div>

            <div class="payment-method-box">
                <h3>💳 Select Payment Method</h3>

                <asp:RadioButtonList
                    ID="rblPaymentMethod"
                    runat="server"
                    RepeatDirection="Vertical">
                    <asp:ListItem Text="Cash on Delivery" Value="Cash on Delivery" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="Online Banking" Value="Online Banking"></asp:ListItem>
                    <asp:ListItem Text="E-Wallet" Value="E-Wallet"></asp:ListItem>
                </asp:RadioButtonList>
            </div>

            <div style="text-align:center; margin-top:25px;">
                <asp:Button ID="btnConfirmCheckout" runat="server"
                    Text="Confirm Checkout"
                    CssClass="checkout-btn"
                    OnClick="btnConfirmCheckout_Click" />
            </div>

        </div>
    </asp:Panel>

    <asp:Panel ID="pnlReceipt" runat="server" Visible="false" CssClass="receipt-panel">
        <h2 style="text-align:center; color:#d62828; margin-top:0;">✅ Order Confirmed</h2>

        <asp:Literal ID="litReceipt" runat="server" />

        <div style="text-align:center; margin-top:25px;">
            <a href="OrderHistory.aspx" class="checkout-btn" style="text-decoration:none; margin-right:10px;">
                View Order History
            </a>

            <a href="ProductListing.aspx" class="checkout-btn" style="text-decoration:none;">
                Back to Menu
            </a>
        </div>
    </asp:Panel>

</asp:Content>