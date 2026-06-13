<%@ Page Title="Admin Panel" Language="C#" MasterPageFile="~/burgerMaster.Master" AutoEventWireup="true" CodeBehind="ProductListingAdmin.aspx.cs" Inherits="Burgembira.ProductListingAdmin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div style="padding: 20px;">
        <h2 style="margin-bottom: 20px;">🍔 Admin Panel – Manage Menu Items</h2>

        <asp:Label ID="lblNote" runat="server"
            Text="For local images, enter only the file name, e.g. classicburger.png. For web images, enter the full URL starting with https://"
            ForeColor="#D32F2F"
            Font-Bold="true" />

        <br /><br />

        <asp:SqlDataSource ID="SqlDataSource1" runat="server"
            ConnectionString="<%$ ConnectionStrings:BurgembiraDB %>"
            SelectCommand="SELECT * FROM [MenuItems]"
            InsertCommand="INSERT INTO [MenuItems] ([ItemName], [CategoryId], [ItemPrice], [ItemImage]) VALUES (@ItemName, @CategoryId, @ItemPrice, @ItemImage)"
            UpdateCommand="UPDATE [MenuItems] SET [ItemName] = @ItemName, [CategoryId] = @CategoryId, [ItemPrice] = @ItemPrice, [ItemImage] = @ItemImage WHERE [ItemId] = @ItemId"
            DeleteCommand="DELETE FROM [MenuItems] WHERE [ItemId] = @ItemId">

            <InsertParameters>
                <asp:Parameter Name="ItemName" Type="String" />
                <asp:Parameter Name="CategoryId" Type="Int32" />
                <asp:Parameter Name="ItemPrice" Type="Decimal" />
                <asp:Parameter Name="ItemImage" Type="String" />
            </InsertParameters>

            <UpdateParameters>
                <asp:Parameter Name="ItemName" Type="String" />
                <asp:Parameter Name="CategoryId" Type="Int32" />
                <asp:Parameter Name="ItemPrice" Type="Decimal" />
                <asp:Parameter Name="ItemImage" Type="String" />
                <asp:Parameter Name="ItemId" Type="Int32" />
            </UpdateParameters>

            <DeleteParameters>
                <asp:Parameter Name="ItemId" Type="Int32" />
            </DeleteParameters>
        </asp:SqlDataSource>

        <h3 style="margin-top: 30px;">Add New Burger Item</h3>

        <asp:DetailsView ID="DetailsViewAddItem" runat="server"
            DataSourceID="SqlDataSource1"
            DefaultMode="Insert"
            AutoGenerateRows="False"
            CssClass="admin-grid"
            GridLines="None">

            <Fields>
                <asp:BoundField DataField="ItemName" HeaderText="Item Name" />
                <asp:BoundField DataField="CategoryId" HeaderText="Category ID" />
                <asp:BoundField DataField="ItemPrice" HeaderText="Price (RM)" />
                <asp:BoundField DataField="ItemImage" HeaderText="Image File Name / Image URL" />
                <asp:CommandField ShowInsertButton="True" InsertText="Add Item" />
            </Fields>
        </asp:DetailsView>

        <br /><br />

        <h3>Menu Item List</h3>

        <asp:GridView ID="GridView1" runat="server"
            AllowSorting="True"
            AutoGenerateColumns="False"
            DataKeyNames="ItemId"
            DataSourceID="SqlDataSource1"
            CssClass="admin-grid"
            GridLines="None">

            <Columns>
                <asp:BoundField DataField="ItemId" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="ItemId" />

                <asp:BoundField DataField="ItemName" HeaderText="Item Name" SortExpression="ItemName" />

                <asp:BoundField DataField="CategoryId" HeaderText="Category ID" SortExpression="CategoryId" />

                <asp:BoundField DataField="ItemPrice" HeaderText="Price (RM)" SortExpression="ItemPrice" DataFormatString="{0:N2}" />

                <asp:TemplateField HeaderText="Image">
                    <ItemTemplate>
                        <asp:Image ID="imgItem" runat="server"
                            ImageUrl='<%# GetImageUrl(Eval("ItemImage")) %>'
                            Width="80"
                            Height="80" />
                    </ItemTemplate>

                    <EditItemTemplate>
                        <asp:TextBox ID="txtImage" runat="server"
                            Text='<%# Bind("ItemImage") %>'
                            Width="280px" />

                        <br /><br />

                        <asp:Image ID="imgEditPreview" runat="server"
                            ImageUrl='<%# GetImageUrl(Eval("ItemImage")) %>'
                            Width="80"
                            Height="80" />
                    </EditItemTemplate>
                </asp:TemplateField>

                <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" />
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>