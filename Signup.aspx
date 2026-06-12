<%@ Page Title="" Language="C#" MasterPageFile="~/burgerMaster.Master" AutoEventWireup="true" CodeBehind="Signup.aspx.cs" Inherits="Burgembira.Signup" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <link href="Styles/SignupStyle.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        function togglePasswordVisibility() {
            var pwdBox = document.getElementById('<%= TextBoxPassword.ClientID %>');
             var showPwdCheck = document.getElementById('<%= CheckBoxShowPassword.ClientID %>');
            pwdBox.type = showPwdCheck.checked ? 'text' : 'password';
        }
    </script>

    <div class="form-container">
        <h2>Create an Account</h2>
        <asp:Label ID="MessageLabel" runat="server" CssClass="validation-error" Style="display: block; text-align: center; margin-bottom: 15px;" />

        <table class="form-table">
            <tr>
                <td>
                    <label><strong>Name</strong></label></td>
                <td>
                    <asp:TextBox ID="TextBoxName" runat="server" CssClass="input-style" />
                    <asp:RequiredFieldValidator ID="NameValidator" runat="server" ControlToValidate="TextBoxName" ErrorMessage="Name is required" CssClass="validation-error" />
                </td>
            </tr>
            <tr>
                <td>
                    <label><strong>Username</strong></label></td>
                <td>
                    <asp:TextBox ID="TextBoxUsername" runat="server" CssClass="input-style" />
                    <asp:RequiredFieldValidator ID="UsernameValidator" runat="server" ControlToValidate="TextBoxUsername" ErrorMessage="Username is required" CssClass="validation-error" />
                </td>
            </tr>
            <tr>
                <td>
                    <label><strong>Email</strong></label></td>
                <td>
                    <asp:TextBox ID="TextBoxEmail" runat="server" TextMode="Email" CssClass="input-style" />
                    <asp:RequiredFieldValidator ID="EmailValidator" runat="server" ControlToValidate="TextBoxEmail" ErrorMessage="Email is required" CssClass="validation-error" />
                    <asp:RegularExpressionValidator ID="RegexEmail" runat="server" ControlToValidate="TextBoxEmail" ErrorMessage="Invalid Email" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" CssClass="validation-error" />
                </td>
            </tr>
            <tr>
                <td>
                    <label><strong>Password</strong></label></td>
                <td>
                    <asp:TextBox ID="TextBoxPassword" runat="server" TextMode="Password" CssClass="input-style" />
                    <asp:RequiredFieldValidator ID="PasswordValidator" runat="server" ControlToValidate="TextBoxPassword" ErrorMessage="Password is required" CssClass="validation-error" />
                    <asp:RegularExpressionValidator ID="RegexPwd" runat="server" ControlToValidate="TextBoxPassword" ErrorMessage="Password must be 8–16 chars, include uppercase, lowercase, number & symbol" ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$!%*?&]).{8,16}$" CssClass="validation-error" />
                    <div style="margin-top: 5px;">
                        <asp:CheckBox ID="CheckBoxShowPassword" runat="server" onclick="togglePasswordVisibility()" />
                        <label>Show Password</label>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <label><strong>Phone</strong></label></td>
                <td>
                    <asp:TextBox ID="TextBoxPhone" runat="server" TextMode="Phone" CssClass="input-style" />
                    <asp:RequiredFieldValidator ID="PhoneValidator" runat="server" ControlToValidate="TextBoxPhone" ErrorMessage="Phone number is required" CssClass="validation-error" />
                    <asp:RegularExpressionValidator ID="RegexPhone" runat="server" ControlToValidate="TextBoxPhone" ErrorMessage="Invalid phone number" ValidationExpression="^01\d{8,9}$" CssClass="validation-error" />
                </td>
            </tr>
            <tr>
                <td>
                    <label><strong>Address</strong></label></td>
                <td>
                    <asp:TextBox ID="TextBoxAddress" runat="server" TextMode="MultiLine" Rows="3" Columns="25" CssClass="input-style" />
                    <asp:RequiredFieldValidator ID="AddressValidator" runat="server" ControlToValidate="TextBoxAddress" ErrorMessage="Address is required" CssClass="validation-error" />
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center;">
                    <asp:Button ID="RegisterBtn" runat="server" Text="Register" OnClick="RegisterBtn_Click" CssClass="register-button" />
                </td>
            </tr>
        </table>
    </div>



</asp:Content>
