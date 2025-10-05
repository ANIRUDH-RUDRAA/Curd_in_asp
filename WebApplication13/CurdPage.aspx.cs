using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services.Protocols;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace WebApplication13
{
    public partial class CurdPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
    
         public class data
        {

            public int  id  { get; set; }


            public string firstname { get; set; }
            public string Lastname { get; set; }
            public string password { get; set; }
            public string confirm { get; set; }
            public string email { get; set; }
            public string mobile { get; set; }
            public string address { get; set; }
            public string gender { get; set; }
            public string sports { get; set; }
            public string dob { get; set; }
            public string country { get; set; }

        }



        [System.Web.Services.WebMethod]
        public static  string   Savedata(data obj)
        {

            SqlConnection sqlConnection = new SqlConnection("Data Source=localhost;Initial Catalog=studentmanagmentsystem;Integrated Security=True;");

            sqlConnection.Open();

            SqlCommand sqlCommand = new SqlCommand("insert into UserRegistration (FirstName, LastName,Password,Email,Mobile,Address,Gender,Sports,DOB,Country,CreatedDate) values(@FirstName, @LastName,@Password,@Email,@Mobile,@Address,@Gender,@Sports,@DOB,@Country,getdate())", sqlConnection);
            sqlCommand.Parameters.AddWithValue("@FirstName", obj.firstname);
            sqlCommand.Parameters.AddWithValue("@LastName", obj.Lastname);
            sqlCommand.Parameters.AddWithValue("@Password", obj.password);
            sqlCommand.Parameters.AddWithValue("@Email", obj.email);
            sqlCommand.Parameters.AddWithValue("@Mobile", obj.mobile);
            sqlCommand.Parameters.AddWithValue("@Address", obj.address);
            sqlCommand.Parameters.AddWithValue("@Gender", obj.gender);
            sqlCommand.Parameters.AddWithValue("@Sports", obj.sports);
            sqlCommand.Parameters.AddWithValue("@DOB", obj.dob);
            sqlCommand.Parameters.AddWithValue("@Country", obj.country);

           int i =  sqlCommand.ExecuteNonQuery();

            if (i>0)
            {

                return "savedata";
            }
            else
            {
                return "somathing went wrong";
            }
                     

        }

           [System.Web.Services.WebMethod]
            public static List<data>   getdate()
           {
            List<data> values = new List<data>();

            string selectQuery = "SELECT * FROM UserRegistration";
            DataTable customerTable = new DataTable();

            using (SqlConnection sqlConnection = new SqlConnection("Data Source=localhost;Initial Catalog=studentmanagmentsystem;Integrated Security=True;"))
            {
                using (SqlCommand command = new SqlCommand(selectQuery, sqlConnection))
                {
                    using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                    {
                        adapter.Fill(customerTable);
                    }
                }
            }

            foreach (DataRow row in customerTable.Rows)
            {
                data p = new data()
                {
                    id = Convert.ToInt32(row["UserId"]),
                    firstname = Convert.ToString(row["FirstName"]),
                    Lastname = Convert.ToString(row["LastName"]),
                    email = Convert.ToString(row["Email"]),
                    mobile = Convert.ToString(row["Mobile"]),
                    address = Convert.ToString(row["Address"]),
                    gender = Convert.ToString(row["Gender"]),
                    sports = Convert.ToString(row["Sports"]),
                    dob = Convert.ToString(row["DOB"]),
                    country = Convert.ToString(row["Country"]),
                    password = Convert.ToString(row["Password"]),


                };
               values.Add(p);
            }


            return values; 
           }


        [System.Web.Services.WebMethod]
        public static  List<data> edit( string editid )
        {
            List<data> values = new List<data>();

            string selectQuery = "SELECT * FROM UserRegistration  where UserId = @id ";
            DataTable customerTable = new DataTable();

            using (SqlConnection sqlConnection = new SqlConnection("Data Source=localhost;Initial Catalog=studentmanagmentsystem;Integrated Security=True;"))
            {
                using (SqlCommand command = new SqlCommand(selectQuery, sqlConnection))
                {
                    command.Parameters.AddWithValue("@id", editid);

                    using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                    {
                        adapter.Fill(customerTable);
                    }
                }
            }

            foreach (DataRow row in customerTable.Rows)
            {
                data p = new data()
                {
                    id = Convert.ToInt32(row["UserId"]),
                    firstname = Convert.ToString(row["FirstName"]),
                    Lastname = Convert.ToString(row["LastName"]),
                    email = Convert.ToString(row["Email"]),
                    mobile = Convert.ToString(row["Mobile"]),
                    address = Convert.ToString(row["Address"]),
                    gender = Convert.ToString(row["Gender"]),
                    sports = Convert.ToString(row["Sports"]),
                    dob = Convert.ToString(row["DOB"]),
                    country = Convert.ToString(row["Country"]),
                    password = Convert.ToString(row["Password"]),


                };
                values.Add(p);
            }


            return values;
        }
    }











    
    
    
    
}