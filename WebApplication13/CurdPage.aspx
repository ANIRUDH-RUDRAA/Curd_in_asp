<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CurdPage.aspx.cs" Inherits="WebApplication13.CurdPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>


    <style>


table {
  border-collapse: collapse;
  border: 2px solid rgb(140 140 140);
  font-family: sans-serif;
  font-size: 0.8rem;
  letter-spacing: 1px;
}

caption {
  caption-side: bottom;
  padding: 10px;
  font-weight: bold;
}

thead,
tfoot {
  background-color: rgb(228 240 245);
}

th,
td {
  border: 1px solid rgb(160 160 160);
  padding: 8px 10px;
}

td:last-of-type {
  text-align: center;
}

tbody > tr:nth-of-type(even) {
  background-color: rgb(237 238 242);
}

tfoot th {
  text-align: right;
}

tfoot td {
  font-weight: bold;
}

    </style>
</head>
<body>
   


    <input  id="hiddenid"  />
    <h1>User Registration from </h1>
     <label>Enter your first name</label>
      <input type="text" name="name" id="firstname" placeholder="Enter your first name" value=""> <br>
      <label>Enter your last name</label>
      <input type="text" name="name" id="Lastname" value=""><br>
      <label>Enter your password</label>
      <input type="password" name="password" id="password" value=""> <br>
      <label>ReEnter your password</label>
      <input type="password" name="confirm" id="confirm" value=""> <br>
      <label>Enter your email</label>
      <input type="email" name="email" id="email" value=""><br>
      <label>Enter your mobile</label>
      <input type="tel" name="mobile" id="mobile" value=""><br>
      <label>Enter your address </label>
      <input type="textarea"  id="address"  row="6" col="7" ></textarea> <br>
      <label>Select your gender </label>
      <input type="radio" name="gender" id="male" value="male"><span>Male</span>
      <input type="radio" name="gender" id="female" value="female"><span>Female </span> <br>
      <label>Select sports you love</label>
      <input type="checkbox" name="sports" id="a" value="cricket"><span>cricket</span>
      <input type="checkbox" name="sports" id="b" value="football"><span>football </span>
      <input type="checkbox" name="sports" id="c" value="hockey"><span>hockey</span> <br>
      <label>Select your Date of Birth</label>
      <input type="date" name="dob" id="dob" value=""><br>
      <label>Select your country </label>
      <select name="country" id="country">
        <option value="">... Select your country...</option>
        <option value="India">India </option>
        <option value="Afghanistan">Afghanistan </option>
        <option value="France">France </option> <br>
      </select> <br>
      <label >Upload image </label>
      <input type="button"  onclick="senddata();"  value="Register">
      <input type="submit" name="reset" id="reset" value="Reset">




    <table >
        <thead>
                <tr>
                     <th scope="col">Sr</th>
                    <th scope="col">firstname</th>
                    <th scope="col">Lastname</th>
                    <th scope="col">password</th>
                    <th scope="col">email</th>
                    <th scope="col">mobile</th>
                    <th scope="col">address</th>
                    <th scope="col">gender</th>
                    <th scope="col">sports</th>
                    <th scope="col">dob</th>
                    <th scope="col">country</th>
                    <th scope="col">Action</th>
                </tr>
       </thead>
        <tbody  id="tabledata" >

        </tbody>

    </table>






    <script src="Scripts/jquery-3.7.0.min.js"></script>
    <script>


        function senddata()
        {

            var data =
            {
                
                firstname: $("#firstname").val(),
                Lastname: $("#Lastname").val(),
                password: $("#password").val(),
                confirm: $("#confirm").val(),
                email: $("#email").val(),
                mobile: $("#mobile").val(),
                address: $("#address").val(),
                gender : $("input[name='gender']:checked").val(),
                sports: $("input[name='sports']:checked").val(),
                dob: $("#dob").val(),
                country: $("#country").val(),



            }

            

            $.ajax({
                type: "POST",
                url: "/CurdPage.aspx/Savedata",
                data: JSON.stringify({ obj: data }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    alert(result.d);
                    console.log(result);
                }
            });

        }



        $(document).ready(function () {
            getadate();
        });

        function getadate()
        {

            $.ajax({
                type: "POST",
                url: "/CurdPage.aspx/getdate",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {
                    var data = result.d; 
                    var tableBody = $("#tabledata");
                    tableBody.empty(); // Clear existing rows if any

                    $.each(data, function (index, item) {
                        var row = `<tr><td>` + item.id + `</td><td>` + item.firstname + `</td><td>` + item.Lastname + `</td><td>` + item.password + `</td><td>` + item.email + "</td><td>" + item.mobile + "</td><td>" + item.address + "</td><td>" + item.gender + "</td><td>" + item.sports + "</td><td>" + item.dob + "</td><td>" + item.country + `</td><td> <button type="button" class="btn btn - primary "   onclick= editdata(` +  item.id  +`) >Edit</button></td></tr>`;
                        tableBody.append(row);
                    });
                }
            });

        }



        function editdata(id) {
            $.ajax({
                type: "POST",
                url: "/CurdPage.aspx/edit",
                data: JSON.stringify({ editid:id }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (result) {

                    var data = result.d;

                    debugger;

                    $("#hiddenid").val(data[0].id),
                    $("#firstname").val(data[0].firstname),
                        $("#Lastname").val(data[0].Lastname),
                        $("#password").val(data[0].password),

                        $("#email").val(data[0].email),
                        $("#mobile").val(data[0].mobile),
                        $("#address").val(data[0].address),
                        $("input[name='gender'][value='" + data[0].gender + "']").prop('checked', true);
                        $("input[name='sports'][value='" + data[0].sports + "']").prop('checked', true);
                        $("#dob").val(data[0].dob),
                        $("#country").val(data[0].country)




                }
            });
        }







    </script>


</body>
</html>
