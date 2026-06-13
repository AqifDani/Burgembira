<%@ Page Title="Register" Language="C#" MasterPageFile="~/burgerMaster.Master" AutoEventWireup="true" CodeBehind="Signup.aspx.cs" Inherits="Burgembira.Signup" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <link href="Styles/SignupStyle.css" rel="stylesheet" type="text/css" />

    <script type="text/javascript">
        function togglePasswordVisibility() {
            var pwdBox = document.getElementById('<%= TextBoxPassword.ClientID %>');
            var showPwdCheck = document.getElementById('<%= CheckBoxShowPassword.ClientID %>');

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

        .register-card-modern {
            width: min(620px, 100%);
            background: rgba(255, 255, 255, 0.96);
            border: 1px solid #f0d7c5;
            border-radius: 30px;
            box-shadow: 0 20px 45px rgba(0, 0, 0, 0.12);
            padding: 38px 42px 34px;
            position: relative;
            overflow: hidden;
        }

        .register-card-modern::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            height: 8px;
            width: 100%;
            background: linear-gradient(90deg, #d62828, #f77f00, #fcbf49);
        }

        .register-card-modern::after {
            content: "🍟";
            position: absolute;
            top: 18px;
            right: 24px;
            font-size: 56px;
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

        .register-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px 20px;
        }

        .register-field {
            display: flex;
            flex-direction: column;
        }

        .register-field.full {
            grid-column: 1 / -1;
        }

        .register-field label {
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

        textarea.auth-input {
            min-height: 90px;
            resize: vertical;
        }

        .auth-checkbox-row {
            grid-column: 1 / -1;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            color: #444444;
            font-size: 14px;
            margin-top: 2px;
        }

        .auth-button-row {
            grid-column: 1 / -1;
            text-align: center;
            margin-top: 10px;
        }

        .auth-button {
            width: min(280px, 100%);
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

        .validation-error {
            display: block;
            color: #d62828;
            font-size: 12.5px;
            font-weight: 700;
            margin-top: 6px;
            line-height: 1.35;
        }

        .auth-main-error {
            display: block;
            text-align: center;
            color: #d62828;
            font-weight: 800;
            margin-bottom: 16px;
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

        @media (max-width: 700px) {
            .register-card-modern {
                padding: 32px 24px;
            }

            .register-grid {
                grid-template-columns: 1fr;
            }

            .auth-title {
                font-size: 31px;
            }
        }
    </style>

    <div class="auth-page-shell">
        <div class="register-card-modern">

            <h2 class="auth-title">Create an Account</h2>
            <div class="auth-subtitle">Join Burgembira and start ordering your favourite burgers.</div>

            <asp:Label ID="MessageLabel" runat="server" CssClass="auth-main-error" />

            <div class="register-grid">

                <div class="register-field">
                    <label>Name</label>
                    <asp:TextBox ID="TextBoxName" runat="server" CssClass="auth-input" />
                    <asp:RequiredFieldValidator ID="NameValidator" runat="server"
                        ControlToValidate="TextBoxName"
                        ErrorMessage="Name is required"
                        CssClass="validation-error"
                        Display="Dynamic" />
                </div>

                <div class="register-field">
                    <label>Username</label>
                    <asp:TextBox ID="TextBoxUsername" runat="server" CssClass="auth-input" />
                    <asp:RequiredFieldValidator ID="UsernameValidator" runat="server"
                        ControlToValidate="TextBoxUsername"
                        ErrorMessage="Username is required"
                        CssClass="validation-error"
                        Display="Dynamic" />
                </div>

                <div class="register-field">
                    <label>Email</label>
                    <asp:TextBox ID="TextBoxEmail" runat="server" TextMode="Email" CssClass="auth-input" />
                    <asp:RequiredFieldValidator ID="EmailValidator" runat="server"
                        ControlToValidate="TextBoxEmail"
                        ErrorMessage="Email is required"
                        CssClass="validation-error"
                        Display="Dynamic" />
                    <asp:RegularExpressionValidator ID="RegexEmail" runat="server"
                        ControlToValidate="TextBoxEmail"
                        ErrorMessage="Invalid Email"
                        ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                        CssClass="validation-error"
                        Display="Dynamic" />
                </div>

                <div class="register-field">
                    <label>Phone</label>
                    <asp:TextBox ID="TextBoxPhone" runat="server" TextMode="Phone" CssClass="auth-input" />
                    <asp:RequiredFieldValidator ID="PhoneValidator" runat="server"
                        ControlToValidate="TextBoxPhone"
                        ErrorMessage="Phone number is required"
                        CssClass="validation-error"
                        Display="Dynamic" />
                    <asp:RegularExpressionValidator ID="RegexPhone" runat="server"
                        ControlToValidate="TextBoxPhone"
                        ErrorMessage="Invalid phone number"
                        ValidationExpression="^01\d{8,9}$"
                        CssClass="validation-error"
                        Display="Dynamic" />
                </div>

                <div class="register-field full">
                    <label>Password</label>
                    <asp:TextBox ID="TextBoxPassword" runat="server" TextMode="Password" CssClass="auth-input" />
                    <asp:RequiredFieldValidator ID="PasswordValidator" runat="server"
                        ControlToValidate="TextBoxPassword"
                        ErrorMessage="Password is required"
                        CssClass="validation-error"
                        Display="Dynamic" />
                    <asp:RegularExpressionValidator ID="RegexPwd" runat="server"
                        ControlToValidate="TextBoxPassword"
                        ErrorMessage="Password must be 8–16 characters and include uppercase, lowercase, number and symbol"
                        ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$!%*?&]).{8,16}$"
                        CssClass="validation-error"
                        Display="Dynamic" />
                </div>

                <div class="auth-checkbox-row">
                    <asp:CheckBox ID="CheckBoxShowPassword" runat="server" onclick="togglePasswordVisibility()" />
                    <span>Show Password</span>
                </div>

                <div class="register-field full">
                    <label>Address</label>
                    <asp:TextBox ID="TextBoxAddress" runat="server"
                        TextMode="MultiLine"
                        Rows="3"
                        CssClass="auth-input" />
                    <asp:RequiredFieldValidator ID="AddressValidator" runat="server"
                        ControlToValidate="TextBoxAddress"
                        ErrorMessage="Address is required"
                        CssClass="validation-error"
                        Display="Dynamic" />
                </div>

                <div class="auth-button-row">
                    <asp:Button ID="RegisterBtn" runat="server"
                        Text="Register"
                        OnClick="RegisterBtn_Click"
                        CssClass="auth-button" />
                </div>

            </div>

            <div class="auth-link-box">
                Already have an account?
                <a href="Login.aspx">Login here</a>
            </div>

        </div>
    </div>

</asp:Content>