<%@ Page Title="Review" Language="C#" MasterPageFile="~/burgerMaster.Master" AutoEventWireup="true" CodeBehind="Review.aspx.cs" Inherits="Burgembira.Review" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="delivery-wrapper">
        <h2 class="delivery-title">Customer Reviews</h2>

        <asp:Label ID="MessageLabel" runat="server" CssClass="status-message" />

        <div style="max-width: 600px; margin: 0 auto 30px auto; padding: 20px; border: 1px solid #ddd; border-radius: 10px;">
            <h3>Submit Your Review</h3>

            <p>
                <strong>Select Order:</strong><br />
                <asp:DropDownList ID="ddlOrders" runat="server" Width="100%" />
            </p>

            <p>
                <strong>Rating:</strong><br />
                <asp:DropDownList ID="ddlRating" runat="server" Width="100%">
                    <asp:ListItem Text="5 - Excellent" Value="5"></asp:ListItem>
                    <asp:ListItem Text="4 - Good" Value="4"></asp:ListItem>
                    <asp:ListItem Text="3 - Average" Value="3"></asp:ListItem>
                    <asp:ListItem Text="2 - Poor" Value="2"></asp:ListItem>
                    <asp:ListItem Text="1 - Very Poor" Value="1"></asp:ListItem>
                </asp:DropDownList>
            </p>

            <p>
                <strong>Comment:</strong><br />
                <asp:TextBox ID="txtComment" runat="server"
                    TextMode="MultiLine"
                    Rows="5"
                    Width="100%"
                    MaxLength="500"
                    placeholder="Write your review here..." />
            </p>

            <asp:Button ID="btnSubmitReview" runat="server"
                Text="Submit Review"
                CssClass="grid-button"
                OnClick="btnSubmitReview_Click" />
        </div>

        <h3 style="text-align:center;">All Customer Reviews</h3>

        <asp:GridView ID="GridViewReviews" runat="server"
            AutoGenerateColumns="False"
            CssClass="gridview-style"
            GridLines="None">

            <Columns>
                <asp:BoundField DataField="ReviewId" HeaderText="Review ID" />
                <asp:BoundField DataField="CustomerName" HeaderText="Customer" />
                <asp:BoundField DataField="OrderId" HeaderText="Order ID" />
                <asp:BoundField DataField="Rating" HeaderText="Rating" />
                <asp:BoundField DataField="Comment" HeaderText="Comment" />
                <asp:BoundField DataField="ReviewDate" HeaderText="Date" DataFormatString="{0:dd MMM yyyy hh:mm tt}" />
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>