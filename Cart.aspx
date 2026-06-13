<%@ Page Title="" Language="C#" MasterPageFile="~/burgerMaster.Master" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="Burgembira.Cart" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2 class="page-title">🛒 Your Cart</h2>

    <asp:Literal ID="litEmptyCart" runat="server" Visible="false"
        Text="<div class='cart-empty'>🛒 Your cart is empty.</div>" />

    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
        ConnectionString="<%$ ConnectionStrings:BurgembiraDB %>"
        SelectCommand="sp_Cart"
        SelectCommandType="StoredProcedure"
        OnSelected="SqlDataSource1_Selected">
        <SelectParameters>
            <asp:Parameter Name="UserId" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <div class="cart-page-layout">

        <div class="cart-list-section">
            <asp:DataList ID="DataList1" runat="server"
                DataSourceID="SqlDataSource1"
                OnItemCommand="DataList1_ItemCommand"
                RepeatDirection="Horizontal"
                RepeatColumns="2"
                CellPadding="0"
                CellSpacing="0"
                CssClass="cart-datalist">

                <ItemTemplate>
                    <div class="cart-item">

                        <div class="cart-item-header">
                            <h3><%# Eval("ItemName") %></h3>
                        </div>

                        <asp:Image ID="ItemImage" runat="server"
                            ImageUrl='<%# GetImageUrl(Eval("ItemImage")) %>'
                            AlternateText="Item Image"
                            CssClass="cart-product-image" />

                        <div class="cart-price-row">
                            <span>Price</span>
                            <strong>RM <%# Eval("ItemPrice", "{0:N2}") %></strong>
                        </div>

                        <div class="cart-price-row">
                            <span>Total</span>
                            <strong>RM <%# Eval("TotalPrice", "{0:N2}") %></strong>
                        </div>

                        <div class="cart-form-group">
                            <label>Quantity</label>
                            <asp:TextBox ID="txtQuantity" runat="server"
                                Text='<%# Eval("Quantity") %>'
                                MaxLength="2"
                                CssClass="cart-qty-input" />
                        </div>

                        <div class="cart-form-group">
                            <label>Notes / Customization</label>
                            <asp:TextBox ID="txtNotes" runat="server"
                                Text='<%# Eval("Customization") %>'
                                MaxLength="255"
                                Placeholder="e.g., No mayo, extra cheese"
                                CssClass="cart-notes-input" />
                        </div>

                        <div class="cart-action-row">
                            <asp:Button ID="btnUpdate" runat="server"
                                CommandArgument='<%# Eval("ItemName") %>'
                                CommandName="Update"
                                Text="Update Cart"
                                CssClass="grid-button" />

                            <asp:Button ID="btnRemove" runat="server"
                                CommandArgument='<%# Eval("ItemName") %>'
                                CommandName="Remove"
                                Text="Remove"
                                CssClass="remove-btn"
                                OnClientClick="return confirm('Remove this item from cart?');" />
                        </div>

                    </div>
                </ItemTemplate>
            </asp:DataList>
        </div>

        <div class="cart-summary-section">
            <asp:Panel ID="PanelTotal" runat="server" Visible="false" CssClass="cart-total-panel">
                <h3>Cart Summary</h3>

                <div class="summary-line">
                    <span>Total Amount</span>
                    <strong>RM <asp:Label ID="lblTotal" runat="server" Text="0.00" /></strong>
                </div>
            </asp:Panel>

            <asp:Panel ID="PanelCheckout" runat="server" Visible="false" CssClass="checkout-panel">
                <asp:Button ID="BtnCheckout" runat="server"
                    Text="Proceed to Checkout"
                    CssClass="checkout-btn"
                    OnClick="BtnCheckout_Click" />
            </asp:Panel>
        </div>

    </div>

</asp:Content>