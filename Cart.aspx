<%@ Page Title="" Language="C#" MasterPageFile="~/burgerMaster.Master" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="Burgembira.Cart" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

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

    <div class="cart-wrapper">
        <asp:DataList ID="DataList1" runat="server" DataSourceID="SqlDataSource1" OnItemCommand="DataList1_ItemCommand"
            RepeatDirection="Horizontal" RepeatColumns="3">
            <ItemTemplate>
                <div class="cart-item">
                    <label><strong>Item:</strong> <%# Eval("ItemName") %></label>
                    <asp:Image ID="ItemImage" runat="server" ImageUrl='<%# Eval("ItemImage") %>' AlternateText="Item Image" />

                    <label><strong>Quantity:</strong></label>
                    <asp:TextBox ID="txtQuantity" runat="server" Text='<%# Eval("Quantity") %>' Width="40" MaxLength="2" />

                    <label><strong>Notes:</strong></label>
                    <asp:TextBox ID="txtNotes" runat="server" Text='<%# Eval("Customization") %>' Width="150"
                        MaxLength="255" Placeholder="e.g., No mayo, extra cheese" />

                    <label><strong>Price (RM):</strong> <%# Eval("ItemPrice", "{0:N2}") %></label>
                    <label><strong>Total (RM):</strong> <%# Eval("TotalPrice", "{0:N2}") %></label>

                    <asp:Button ID="btnUpdate" runat="server"
                        CommandArgument='<%# Eval("ItemName") %>'
                        CommandName="Update"
                        Text="Update" CssClass="update-btn" />

                    <asp:Button ID="btnRemove" runat="server"
                        CommandArgument='<%# Eval("ItemName") %>'
                        CommandName="Remove"
                        Text="Remove from Cart"
                        CssClass="remove-btn" />
                </div>
            </ItemTemplate>
        </asp:DataList>
    </div>

    <asp:Panel ID="PanelTotal" runat="server" Visible="false" CssClass="cart-total-panel">
        <strong>Total Amount (RM):</strong>
        <asp:Label ID="lblTotal" runat="server" Text="0.00" />
    </asp:Panel>

    <asp:Panel ID="PanelCheckout" runat="server" Visible="false" CssClass="checkout-panel">
        <asp:Button ID="BtnCheckout" runat="server" Text="Proceed to Checkout"
            CssClass="checkout-btn" OnClick="BtnCheckout_Click" />
    </asp:Panel>

</asp:Content>

