<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CUrd_gpt_.aspx.cs" Inherits="WebApplication13.CUrd_gpt_" EnableEventValidation="false"  %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>User Registration</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.2/css/bootstrap.min.css" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
<form id="form1" runat="server">
<div class="container mt-5">
    <h2>User Registration Form</h2>
    <input type="hidden" id="hfUserId" />
    <div class="form-group"><label>First Name</label><input type="text" class="form-control" id="txtFirstName" /></div>
    <div class="form-group"><label>Last Name</label><input type="text" class="form-control" id="txtLastName" /></div>
    <div class="form-group"><label>Password</label><input type="password" class="form-control" id="txtPassword" /></div>
    <div class="form-group"><label>Email</label><input type="email" class="form-control" id="txtEmail" /></div>
    <div class="form-group"><label>Mobile</label><input type="text" class="form-control" id="txtMobile" /></div>
    <div class="form-group"><label>Address</label><textarea class="form-control" id="txtAddress"></textarea></div>
    <div class="form-group"><label>Gender</label><br />
        <input type="radio" name="gender" value="Male" /> Male
        <input type="radio" name="gender" value="Female" /> Female
    </div>
    <div class="form-group"><label>Sports</label><br />
        <input type="checkbox" name="sports" value="Cricket" /> Cricket
        <input type="checkbox" name="sports" value="Football" /> Football
        <input type="checkbox" name="sports" value="Hockey" /> Hockey
    </div>
    <div class="form-group"><label>DOB</label><input type="date" class="form-control" id="txtDOB" /></div>
    <div class="form-group"><label>State</label>
        <select class="form-control" id="ddlState"><option value="">--Select State--</option></select>
    </div>
    <div class="form-group"><label>City</label>
        <select class="form-control" id="ddlCity"><option value="">--Select City--</option></select>
    </div>
    <button type="button" class="btn btn-primary" id="btnSave">Save</button>

    <hr />
    <h3>Users</h3>
    <table class="table table-bordered" id="tblUsers">
        <thead>
            <tr>
                <th>ID</th><th>Name</th><th>Email</th><th>Mobile</th><th>Gender</th><th>Sports</th><th>DOB</th><th>State</th><th>City</th><th>Actions</th>
            </tr>
        </thead>
        <tbody></tbody>
    </table>
</div>
</form>

<script>
    $(document).ready(function () {
        loadStates(); loadUsers();

        $('#ddlState').change(function () {
            var stateId = $(this).val();
            if (stateId) {
                $.ajax({
                    type: "POST", url: "CUrd_gpt_.aspx/GetCities",
                    data: JSON.stringify({ stateId: stateId }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (res) {
                        var ddlCity = $('#ddlCity');
                        ddlCity.empty().append('<option value="">--Select City--</option>');
                        $.each(res.d, function (i, c) { ddlCity.append('<option value="' + c.CityId + '">' + c.CityName + '</option>'); });
                    }
                });
            }
        });

        $('#btnSave').click(function () {
            var user = {
                UserId: $('#hfUserId').val(),
                FirstName: $('#txtFirstName').val(),
                LastName: $('#txtLastName').val(),
                Password: $('#txtPassword').val(),
                Email: $('#txtEmail').val(),
                Mobile: $('#txtMobile').val(),
                Address: $('#txtAddress').val(),
                Gender: $('input[name=gender]:checked').val(),
                Sports: $('input[name=sports]:checked').map(function () { return this.value; }).get().join(','),
                DOB: $('#txtDOB').val(),
                StateId: $('#ddlState').val(),
                CityId: $('#ddlCity').val()
            };
            $.ajax({
                type: "POST", url: "CUrd_gpt_.aspx/SaveUser",
                data: JSON.stringify({ user: user }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (res) { alert(res.d); clearForm(); loadUsers(); }
            });
        });

        $(document).on('click', '.btnEdit', function () {
            var userId = $(this).data('id');
            $.ajax({
                type: "POST", url: "CUrd_gpt_.aspx/GetUserById",
                data: JSON.stringify({ userId: userId }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (res) {
                    var user = res.d;
                    $('#hfUserId').val(user.UserId);
                    $('#txtFirstName').val(user.FirstName);
                    $('#txtLastName').val(user.LastName);
                    $('#txtPassword').val(user.Password);
                    $('#txtEmail').val(user.Email);
                    $('#txtMobile').val(user.Mobile);
                    $('#txtAddress').val(user.Address);
                    $('#txtDOB').val(user.DOB ? user.DOB.split('T')[0] : '');
                    $('input[name=gender][value="' + user.Gender + '"]').prop('checked', true);
                    $('input[name=sports]').prop('checked', false);
                    if (user.Sports) { user.Sports.split(',').map(s => s.trim()).forEach(s => $('input[name=sports][value="' + s + '"]').prop('checked', true)); }
                    $('#ddlState').val(user.StateId);
                    $.ajax({
                        type: "POST", url: "CUrd_gpt_.aspx/GetCities",
                        data: JSON.stringify({ stateId: user.StateId }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (resCities) {
                            var ddlCity = $('#ddlCity');
                            ddlCity.empty().append('<option value="">--Select City--</option>');
                            $.each(resCities.d, function (i, c) { ddlCity.append('<option value="' + c.CityId + '">' + c.CityName + '</option>'); });
                            ddlCity.val(user.CityId);
                        }
                    });
                }
            });
        });

        $(document).on('click', '.btnDelete', function () {
            if (confirm('Are you sure to delete?')) {
                var userId = $(this).data('id');
                $.ajax({
                    type: "POST", url: "CUrd_gpt_.aspx/DeleteUser",
                    data: JSON.stringify({ userId: userId }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (res) { alert(res.d); loadUsers(); }
                });
            }
        });

        function loadStates() {
            $.ajax({
                type: "POST", url: "CUrd_gpt_.aspx/GetStates",
                data: "{}", contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (res) {
                    var ddlState = $('#ddlState');
                    ddlState.empty().append('<option value="">--Select State--</option>');
                    $.each(res.d, function (i, s) { ddlState.append('<option value="' + s.StateId + '">' + s.StateName + '</option>'); });
                }
            });
        }

        function loadUsers() {
            $.ajax({
                type: "POST", url: "CUrd_gpt_.aspx/GetUsers",
                data: "{}", contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (res) {
                    var tbody = $('#tblUsers tbody');
                    tbody.empty();
                    $.each(res.d, function (i, u) {
                        tbody.append('<tr>' +
                            '<td>' + u.UserId + '</td>' +
                            '<td>' + u.FirstName + ' ' + u.LastName + '</td>' +
                            '<td>' + u.Email + '</td>' +
                            '<td>' + u.Mobile + '</td>' +
                            '<td>' + u.Gender + '</td>' +
                            '<td>' + u.Sports + '</td>' +
                            '<td>' + u.DOB + '</td>' +
                            '<td>' + u.StateName + '</td>' +
                            '<td>' + u.CityName + '</td>' +
                            '<td><button type="button" class="btn btn-sm btn-info btnEdit" data-id="' + u.UserId + '">Edit</button> ' +
                            '<button type="button"  class="btn btn-sm btn-danger btnDelete" data-id="' + u.UserId + '">Delete</button></td>' +
                            '</tr>');
                    });
                }
            });
        }

        function clearForm() {
            $('#hfUserId').val('');
            $('#txtFirstName,#txtLastName,#txtPassword,#txtEmail,#txtMobile,#txtAddress,#txtDOB').val('');
            $('input[name=gender]').prop('checked', false);
            $('input[name=sports]').prop('checked', false);
            $('#ddlState,#ddlCity').val('');
        }
    });
</script>
</body>
</html>