<%@ Page Title="" Language="C#" MasterPageFile="~/burgerMaster.Master" AutoEventWireup="true" CodeBehind="Homepage.aspx.cs" Inherits="Burgembira.Homepage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- =================== Hero Banner =================== -->
    <div class="hero-banner"></div>

<!-- =================== Burger Section =================== -->
<h2 class="section-title">Our Burgers</h2>

<div class="burger-container">
    <!-- Column 1 -->
    <div class="burger-column">
        <div class="burger-card">
            <asp:ImageButton ID="imgClassic" runat="server" ImageUrl="~/images/Classic.jpg" AlternateText="Classic"
                CssClass="burger-img" OnClick="AddToCart_Click" CommandArgument="Classic" />
            <div class="burger-name">Classic</div>
        </div>
        <div class="burger-card">
            <asp:ImageButton ID="imgCheeseleh" runat="server" ImageUrl="~/images/CheesyLeh.jpg" AlternateText="Cheeseleh"
                CssClass="burger-img" OnClick="AddToCart_Click" CommandArgument="Cheeseleh" />
            <div class="burger-name">Cheeseleh</div>
        </div>
        <div class="burger-card">
            <asp:ImageButton ID="imgDoublela" runat="server" ImageUrl="~/images/doublela.jpg" AlternateText="Doublela"
                CssClass="burger-img" OnClick="AddToCart_Click" CommandArgument="Doublela" />
            <div class="burger-name">Doublela</div>
        </div>
    </div>

    <!-- Column 2 -->
    <div class="burger-column">
        <div class="burger-card">
            <asp:ImageButton ID="imgTriplela" runat="server" ImageUrl="~/images/triplela.jpg" AlternateText="Triplela"
                CssClass="burger-img" OnClick="AddToCart_Click" CommandArgument="Triplela" />
            <div class="burger-name">Triplela</div>
        </div>
        <div class="burger-card">
            <asp:ImageButton ID="imgLalaSpecial" runat="server" ImageUrl="~/images/LaLaBurger.jpg" AlternateText="Lala Special"
                CssClass="burger-img" OnClick="AddToCart_Click" CommandArgument="Lala Special" />
            <div class="burger-name">Lala Special</div>
        </div>
        <div class="burger-card">
            <asp:ImageButton ID="imgCrispyLala" runat="server" ImageUrl="~/images/crispylala.jpg" AlternateText="Crispy Lala"
                CssClass="burger-img" OnClick="AddToCart_Click" CommandArgument="Crispy Lala" />
            <div class="burger-name">Crispy Lala</div>
        </div>
    </div>
</div>



    <!-- =================== Mission & Vision =================== -->
    <div class="mission-section">
        <h2>Our Mission & Vision</h2>
        <p>
            At Burgembira, our mission is to bring joy with every burger we serve.
            We aim to combine delicious flavors, fast service, and a retro experience
            that makes every meal memorable. Our vision is to become the top go-to burger
            brand for burger lovers all across Malaysia.
        </p>
    </div>

    <!-- =================== Customer Testimonials =================== -->
    <h2 class="section-title">What Our Customers Say</h2>
    <div class="testimonial-section">
        <div class="testimonial-box">
            <p>"The Lala Special blew my mind! So juicy and flavorful." – Aina</p>
        </div>
        <div class="testimonial-box">
            <p>"Burgembira's burgers taste like childhood nostalgia with a modern twist." – Hafiz</p>
        </div>
        <div class="testimonial-box">
            <p>"Fast service, crispy patties, and that Cheeseleh... chef's kiss!" – Syamimi</p>
        </div>
    </div>

</asp:Content>
