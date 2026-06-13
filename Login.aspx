<%@ Page Title="Login" Language="C#" MasterPageFile="burgerMaster.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Burgembira.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <link href="Styles/SignupStyle.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
        function togglePasswordVisibility() {
            var pwdBox = document.getElementById('<%= Password.ClientID %>');
            var showPwdCheck = document.getElementById('<%= CheckBox1.ClientID %>');

            if (pwdBox && showPwdCheck) {
                pwdBox.type = showPwdCheck.checked ? 'text' : 'password';
            }
        }
    </script>

    <style>
        .auth-page-shell {
            min-height: calc(100vh - 190px);
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 50px 20px;
            background:
                radial-gradient(circle at top left, rgba(247, 127, 0, 0.16), transparent 26%),
                radial-gradient(circle at bottom right, rgba(214, 40, 40, 0.13), transparent 28%);
        }

        .auth-card-modern {
            width: min(460px, 100%);
            background: rgba(255, 255, 255, 0.96);
            border: 1px solid #f0d7c5;
            border-radius: 30px;
            box-shadow: 0 20px 45px rgba(0, 0, 0, 0.12);
            padding: 38px 38px 34px;
            position: relative;
            overflow: hidden;
        }

        .auth-card-modern::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            height: 8px;
            width: 100%;
            background: linear-gradient(90deg, #d62828, #f77f00, #fcbf49);
        }

        .auth-card-modern::after {
            content: "🍔";
            position: absolute;
            top: 18px;
            right: 24px;
            font-size: 54px;
            opacity: 0.12;
        }

        .auth-title {
            text-align: center;
            color: #d62828;
            font-size: 36px;
            font-weight: 900;
            margin: 10px 0 8px;
        }

        .auth-subtitle {
            text-align: center;
            color: #6b6b6b;
            font-size: 15px;
            margin-bottom: 28px;
        }

        .auth-field {
            margin-bottom: 18px;
        }

        .auth-field label {
            display: block;
            font-weight: 800;
            color: #252525;
            margin-bottom: 7px;
            font-size: 14px;
        }

        .auth-input {
            width: 100%;
            min-height: 46px;
            padding: 11px 14px;
            border: 1px solid #ecd2be;
            border-radius: 14px;
            background: #fffaf4;
            font-size: 15px;
            color: #252525;
            outline: none;
            transition: 0.22s ease;
        }

        .auth-input:focus {
            border-color: #d62828;
            background: #ffffff;
            box-shadow: 0 0 0 4px rgba(214, 40, 40, 0.12);
        }

        .auth-checkbox-row {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            margin: 8px 0 18px;
            color: #444444;
            font-size: 14px;
        }

        .auth-button {
            width: 100%;
            min-height: 48px;
            border: none;
            border-radius: 999px;
            background: linear-gradient(90deg, #f77f00, #d62828);
            color: #ffffff;
            font-size: 16px;
            font-weight: 900;
            cursor: pointer;
            transition: 0.22s ease;
            box-shadow: 0 12px 24px rgba(214, 40, 40, 0.22);
        }

        .auth-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 16px 28px rgba(214, 40, 40, 0.28);
        }

        .auth-link-box {
            text-align: center;
            margin-top: 20px;
            padding-top: 18px;
            border-top: 1px solid #f0d7c5;
            font-size: 14px;
            color: #6b6b6b;
        }

        .auth-link-box a {
            color: #d62828;
            font-weight: 900;
            text-decoration: none;
        }

        .auth-link-box a:hover {
            text-decoration: underline;
        }

        .error-message {
            display: block;
            color: #d62828;
            font-size: 13px;
            font-weight: 700;
            margin-top: 6px;
        }

        .auth-main-error {
            display: block;
            text-align: center;
            color: #d62828;
            font-weight: 800;
            margin-bottom: 16px;
        }

        @media (max-width: 600px) {
            .auth-card-modern {
                padding: 32px 24px;
            }

            .auth-title {
                font-size: 31px;
            }
        }
    </style>

    <div class="auth-page-shell">
        <div class="auth-card-modern">

            <h2 class="auth-title">🍔 Burgembira Login</h2>
            <div class="auth-subtitle">Welcome back! Log in to continue your order.</div>

            <asp:Label ID="ErrorMessage" runat="server" CssClass="auth-main-error" />

            <div class="auth-field">
                <label>Username</label>
                <asp:TextBox ID="Username" runat="server" CssClass="auth-input" />
                <asp:RequiredFieldValidator ID="UsernameValidator" runat="server"
                    ControlToValidate="Username"
                    ErrorMessage="Username is required."
                    CssClass="error-message"
                    Display="Dynamic" />
            </div>

            <div class="auth-field">
                <label>Password</label>
                <asp:TextBox ID="Password" runat="server" TextMode="Password" CssClass="auth-input" />
                <asp:RequiredFieldValidator ID="PasswordValidator" runat="server"
                    ControlToValidate="Password"
                    ErrorMessage="Password is required."
                    CssClass="error-message"
                    Display="Dynamic" />
            </div>

            <div class="auth-checkbox-row">
                <asp:CheckBox ID="CheckBox1" runat="server" onclick="togglePasswordVisibility()" />
                <span>Show Password</span>
            </div>

            <asp:Button ID="Button1" runat="server"
                Text="Log In"
                OnClick="Button1_Click"
                CssClass="auth-button" />

            <div class="auth-link-box">
                Don’t have an account?
                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/Signup.aspx">
                    Register here
                </asp:HyperLink>
            </div>

        </div>
    </div>

</asp:Content>