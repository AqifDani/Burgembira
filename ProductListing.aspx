<%@ Page Title="" Language="C#" MasterPageFile="~/burgerMaster.Master" AutoEventWireup="true"
    CodeBehind="ProductListing.aspx.cs" Inherits="Burgembira.ProductListing" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />

    <!-- Link to External CSS -->
    <link href="~/Styles/ProductListing.css" rel="stylesheet" type="text/css" />

    <!-- Category Label + Search Bar -->
    <div class="top-bar-row">
        <label class="category-label">Browse</label>
        <input type="text" id="searchInput" placeholder="Search burgers..." class="search-bar" />
    </div>

    <!-- Category Dropdown -->
    <asp:DropDownList ID="DropDownList1" runat="server"
        AutoPostBack="True"
        OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged"
        AppendDataBoundItems="True"
        DataSourceID="SqlDataSource1"
        DataTextField="CategoryName"
        DataValueField="CategoryId"
        CssClass="category-dropdown">
        <asp:ListItem Text="All" Value="0" />
    </asp:DropDownList>

    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
        ConnectionString="<%$ ConnectionStrings:BurgembiraDB %>"
        SelectCommand="SELECT * FROM [Categories]" />

    <asp:SqlDataSource ID="SqlDataSource2" runat="server"
        ConnectionString="<%$ ConnectionStrings:BurgembiraDB %>" />

    <!-- Product List -->
    <div class="product-list-wrapper">
        <asp:DataList ID="DataList1" runat="server"
            DataSourceID="SqlDataSource2"
            OnItemCommand="DataList1_ItemCommand"
            RepeatDirection="Horizontal"
            RepeatColumns="4"
            CellPadding="10"
            CellSpacing="10">
            <ItemTemplate>
                <div class="product-card">
                    <asp:Image ID="ItemImage" runat="server"
                        CssClass="product-image"
                        ImageUrl='<%# ResolveUrl("~/Images/" + Eval("ItemImage")) %>'
                        AlternateText='<%# Eval("ItemName") %>' />

                    <asp:Label ID="ItemNameLabel" runat="server"
                        Text='<%# Eval("ItemName") %>'
                        CssClass="product-name" />

                    <div class="product-price">
                        RM <asp:Label ID="ItemPriceLabel" runat="server"
                            Text='<%# Eval("ItemPrice", "{0:N2}") %>' />
                    </div>

                    <asp:Button ID="btnAddToCart" runat="server"
                        CommandArgument='<%# Eval("ItemId") %>'
                        CommandName="AddToCart"
                        Text="Add to Cart"
                        CssClass="add-to-cart-btn" />
                </div>
            </ItemTemplate>
        </asp:DataList>
    </div>

    <!-- Toast Message -->
    <div id="toast" class="toast">Added to cart!</div>

    <script type="text/javascript">
        // Search filter
        function filterProducts() {
            var input = document.getElementById("searchInput");
            var filter = input.value.toLowerCase();
            var cards = document.getElementsByClassName("product-card");
            Array.prototype.forEach.call(cards, function (card) {
                var name = card.querySelector(".product-name").textContent.toLowerCase();
                card.style.display = name.indexOf(filter) > -1 ? "block" : "none";
            });
        }

        document.getElementById("searchInput").addEventListener("keyup", filterProducts);

        // Toast notification
        function showToast() {
            var toast = document.getElementById("toast");
            toast.classList.add("show");
            setTimeout(function () {
                toast.classList.remove("show");
            }, 2000);
        }
    </script>
</asp:Content>
