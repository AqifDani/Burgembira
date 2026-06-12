<%@ Page Title="Login" Language="C#" MasterPageFile="burgerMaster.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Burgembira.Login" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <link href="https://fonts.googleapis.com/css2?family=Chewy&display=swap" rel="stylesheet" />
    
    <script type="text/javascript">
        function togglePasswordVisibility() {
            var pwdBox = document.getElementById('<%= Password.ClientID %>');
            var showPwdCheck = document.getElementById('<%= CheckBox1.ClientID %>');
            pwdBox.type = showPwdCheck.checked ? 'text' : 'password';
        }
    </script>

    <div style="height: 100vh; display: flex; justify-content: center; align-items: center;
                font-family: 'Chewy', cursive;
                background: url('https://images.unsplash.com/photo-1606755962774-3b30f6ab1373?ixlib=rb-4.0.3&auto=format&fit=crop&w=1470&q=80') no-repeat center center fixed;
                background-size: cover;">
        
        <div style="width: 350px; background-color: rgba(255, 245, 224, 0.95); padding: 30px; border-radius: 15px;
                    box-shadow: 0 0 20px rgba(0,0,0,0.3); text-align: center;">
            
            <h2 style="color: #c0392b; font-size: 32px; margin-bottom: 15px;">🍔 Burgembira Login</h2>
            <p style="color: #6e2c00; font-size: 18px;">Welcome!</p>

            <asp:Label ID="ErrorMessage" runat="server" Style="color: #c0392b; font-size: 14px; display: block; margin-bottom: 10px;" />

            <!-- Username Field -->
            <label style="color: #6e2c00; font-size: 18px;">Username</label>
            <asp:TextBox ID="Username" runat="server" CssClass="input-box" />
            <asp:RequiredFieldValidator ID="UsernameValidator" runat="server" ControlToValidate="Username"
                ErrorMessage="Username is required." CssClass="error-message" />

            <!-- Password Field -->
            <label style="color: #6e2c00; font-size: 18px;">Password</label>
            <asp:TextBox ID="Password" runat="server" TextMode="Password" CssClass="input-box" />
            <asp:RequiredFieldValidator ID="PasswordValidator" runat="server" ControlToValidate="Password"
                ErrorMessage="Password is required." CssClass="error-message" />

            <!-- Show Password -->
            <p style="margin-top: 10px;">
                <asp:CheckBox ID="CheckBox1" runat="server" onclick="togglePasswordVisibility()" />
                <label for="CheckBox1" style="color: #6e2c00;">Show Password</label>
            </p>

            <!-- Login Button -->
            <asp:Button ID="Button1" runat="server" Text="Log In" OnClick="Button1_Click"
                Style="width: 100%; padding: 10px; background-color: #e67e22; border: none; border-radius: 5px;
                       color: white; font-size: 18px; cursor: pointer;"
                onmouseover="this.style.backgroundColor='#d35400';" 
                onmouseout="this.style.backgroundColor='#e67e22';" />

            <!-- Register Link -->
            <div style="margin-top: 15px;">
                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/Signup.aspx"
                    Style="color: #c0392b; text-decoration: none;"
                    onmouseover="this.style.textDecoration='underline';"
                    onmouseout="this.style.textDecoration='none';">
                    🍟 Don’t have an account? Register here.
                </asp:HyperLink>
            </div>
        </div>
    </div>

    <style>
        .input-box {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            margin-bottom: 15px;
            border: 2px solid #e67e22;
            border-radius: 5px;
            font-family: inherit;
        }

        .error-message {
            color: #c0392b;
            font-size: 14px;
            display: block;
            margin-bottom: 10px;
        }
    </style>
</asp:Content>
