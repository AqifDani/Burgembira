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
    HeaderStyle-BackColor="#e67e22"
    HeaderStyle-ForeColor="White"
    RowStyle-BackColor="#fff2e6"
    AlternatingRowStyle-BackColor="#fff7e6"
    BorderStyle="None"
    OnRowCommand="GridViewDelivery_RowCommand">

    <Columns>
        <asp:BoundField DataField="DeliveryID" HeaderText="Delivery ID" />
        <asp:BoundField DataField="DeliveryDate" HeaderText="Delivery Date" DataFormatString="{0:dd MMM yyyy hh:mm tt}" />
        <asp:BoundField DataField="Status" HeaderText="Status" />

        <asp:TemplateField HeaderText="Action">
            <ItemTemplate>
                <asp:Button ID="btnMarkDelivered" runat="server"
                    CommandName="MarkDelivered"
                    CommandArgument='<%# Eval("DeliveryID") %>'
                    Text="Mark as Delivered"
                    CssClass="grid-button"
                    Visible='<%# Eval("Status").ToString() != "Delivered" %>' />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>

    </div>
</asp:Content>
