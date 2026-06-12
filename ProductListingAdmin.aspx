<%@ Page Title="" Language="C#" MasterPageFile="~/burgerMaster.Master" AutoEventWireup="true" CodeBehind="ProductListingAdmin.aspx.cs" Inherits="Burgembira.ProductListingAdmin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div style="padding: 20px;">
        <h2 style="margin-bottom: 20px;">🍔 Admin Panel – Manage Menu Items</h2>

        <asp:SqlDataSource ID="SqlDataSource1" runat="server"
            ConnectionString="<%$ ConnectionStrings:BurgembiraDB %>"
            DeleteCommand="DELETE FROM [MenuItems] WHERE [ItemId] = @ItemId"
            InsertCommand="INSERT INTO [MenuItems] ([ItemName], [CategoryId], [ItemPrice], [ItemImage]) VALUES (@ItemName, @CategoryId, @ItemPrice, @ItemImage)"
            SelectCommand="SELECT * FROM [MenuItems]"
            UpdateCommand="UPDATE [MenuItems] SET [ItemName] = @ItemName, [CategoryId] = @CategoryId, [ItemPrice] = @ItemPrice, [ItemImage] = @ItemImage WHERE [ItemId] = @ItemId">

            <DeleteParameters>
                <asp:Parameter Name="ItemId" Type="Int32" />
            </DeleteParameters>
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
        </asp:SqlDataSource>

        <asp:GridView ID="GridView1" runat="server"
            AllowSorting="True"
            AutoGenerateColumns="False"
            DataKeyNames="ItemId"
            CssClass="admin-grid"
            GridLines="None"
            HeaderStyle-BackColor="#343a40"
            HeaderStyle-ForeColor="White"
            RowStyle-BackColor="#f9f9f9"
            AlternatingRowStyle-BackColor="#f1f1f1"
            BorderStyle="Solid" BorderWidth="1px" BorderColor="#000DDD" DataSourceID="SqlDataSource1">

            <Columns>
                <asp:BoundField DataField="ItemId" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="ItemId" />
                <asp:BoundField DataField="ItemName" HeaderText="Item Name" SortExpression="ItemName" />
                <asp:BoundField DataField="CategoryId" HeaderText="Category ID" SortExpression="CategoryId" />
                <asp:BoundField DataField="ItemPrice" HeaderText="Price (RM)" SortExpression="ItemPrice" DataFormatString="{0:N2}" />

                <asp:TemplateField HeaderText="Image">
                    <ItemTemplate>
                        <asp:Image ID="imgItem" runat="server"
                            ImageUrl='<%# ResolveUrl("~/Images/" + Eval("ItemImage")) %>'
                            Width="80" Height="80" />
                    </ItemTemplate>

                    <EditItemTemplate>
                        <asp:TextBox ID="txtImage" runat="server"
                            Text='<%# Bind("ItemImage") %>' Width="200px" />
                        <br />
                        <asp:Image ID="imgEditPreview" runat="server"
                            ImageUrl='<%# ResolveUrl("~/Images/" + Eval("ItemImage")) %>'
                            Width="80" Height="80" />
                    </EditItemTemplate>
                </asp:TemplateField>


                <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
            </Columns>

            <HeaderStyle BackColor="#343A40" ForeColor="White"></HeaderStyle>
            <RowStyle BackColor="#F9F9F9"></RowStyle>
        </asp:GridView>
    </div>

</asp:Content>
