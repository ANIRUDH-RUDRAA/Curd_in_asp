using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI;

namespace WebApplication13
{
    public partial class CUrd_gpt_ : System.Web.UI.Page
    {
        string conStr = "Data Source=localhost;Initial Catalog=studentmanagmentsystem;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e) { }

        [WebMethod]
        public static List<State> GetStates()
        {
            List<State> list = new List<State>();
            using (SqlConnection con = new SqlConnection("Data Source=localhost;Initial Catalog=studentmanagmentsystem;Integrated Security=True;"))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT StateId, StateName FROM State", con);
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                    list.Add(new State { StateId = dr.GetInt32(0), StateName = dr.GetString(1) });
            }
            return list;
        }

        [WebMethod]
        public static List<City> GetCities(int stateId)
        {
            List<City> list = new List<City>();
            using (SqlConnection con = new SqlConnection("Data Source=localhost;Initial Catalog=studentmanagmentsystem;Integrated Security=True;"))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT CityId, CityName FROM City WHERE StateId=@StateId", con);
                cmd.Parameters.AddWithValue("@StateId", stateId);
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                    list.Add(new City { CityId = dr.GetInt32(0), CityName = dr.GetString(1) });
            }
            return list;
        }

        [WebMethod]
        public static string SaveUser(User user)
        {
            using (SqlConnection con = new SqlConnection("Data Source=localhost;Initial Catalog=studentmanagmentsystem;Integrated Security=True;"))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = con;

                if (string.IsNullOrEmpty(user.UserId))
                {
                    cmd.CommandText = @"INSERT INTO UserRegistration
                    (FirstName, LastName, Password, Email, Mobile, Address, Gender, Sports, DOB, StateId, CityId)
                    VALUES (@FirstName,@LastName,@Password,@Email,@Mobile,@Address,@Gender,@Sports,@DOB,@StateId,@CityId)";
                }
                else
                {
                    cmd.CommandText = @"UPDATE UserRegistration SET
                    FirstName=@FirstName, LastName=@LastName, Password=@Password, Email=@Email, Mobile=@Mobile,
                    Address=@Address, Gender=@Gender, Sports=@Sports, DOB=@DOB, StateId=@StateId, CityId=@CityId
                    WHERE UserId=@UserId";
                    cmd.Parameters.AddWithValue("@UserId", user.UserId);
                }

                cmd.Parameters.AddWithValue("@FirstName", user.FirstName);
                cmd.Parameters.AddWithValue("@LastName", user.LastName);
                cmd.Parameters.AddWithValue("@Password", user.Password);
                cmd.Parameters.AddWithValue("@Email", user.Email);
                cmd.Parameters.AddWithValue("@Mobile", user.Mobile ?? "");
                cmd.Parameters.AddWithValue("@Address", user.Address ?? "");
                cmd.Parameters.AddWithValue("@Gender", user.Gender ?? "");
                cmd.Parameters.AddWithValue("@Sports", user.Sports ?? "");
                cmd.Parameters.AddWithValue("@DOB", string.IsNullOrEmpty(user.DOB) ? (object)DBNull.Value : user.DOB);
                cmd.Parameters.AddWithValue("@StateId", string.IsNullOrEmpty(user.StateId) ? (object)DBNull.Value : user.StateId);
                cmd.Parameters.AddWithValue("@CityId", string.IsNullOrEmpty(user.CityId) ? (object)DBNull.Value : user.CityId);

                cmd.ExecuteNonQuery();
            }
            return "Saved Successfully!";
        }

        [WebMethod]
        public static List<UserView> GetUsers()
        {
            List<UserView> list = new List<UserView>();
            using (SqlConnection con = new SqlConnection("Data Source=localhost;Initial Catalog=studentmanagmentsystem;Integrated Security=True;"))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                SELECT u.UserId, u.FirstName, u.LastName, u.Email, u.Mobile, u.Gender, u.Sports, u.DOB, s.StateName, c.CityName
                FROM UserRegistration u
                LEFT JOIN State s ON s.StateId = u.StateId
                LEFT JOIN City c ON c.CityId = u.CityId", con);

                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    list.Add(new UserView
                    {
                        UserId = dr.GetInt32(0),
                        FirstName = dr.GetString(1),
                        LastName = dr.GetString(2),
                        Email = dr.GetString(3),
                        Mobile = dr.IsDBNull(4) ? "" : dr.GetString(4),
                        Gender = dr.IsDBNull(5) ? "" : dr.GetString(5),
                        Sports = dr.IsDBNull(6) ? "" : dr.GetString(6),
                        DOB = dr.IsDBNull(7) ? "" : dr.GetDateTime(7).ToString("yyyy-MM-dd"),
                        StateName = dr.IsDBNull(8) ? "" : dr.GetString(8),
                        CityName = dr.IsDBNull(9) ? "" : dr.GetString(9)
                    });
                }
            }
            return list;
        }

        [WebMethod]
        public static User GetUserById(int userId)
        {
            User u = new User();
            using (SqlConnection con = new SqlConnection("Data Source=localhost;Initial Catalog=studentmanagmentsystem;Integrated Security=True;"))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"SELECT UserId, FirstName, LastName, Password, Email, Mobile, Address, Gender, Sports, DOB, StateId, CityId
                                                  FROM UserRegistration WHERE UserId=@UserId", con);
                cmd.Parameters.AddWithValue("@UserId", userId);
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    u.UserId = dr["UserId"].ToString();
                    u.FirstName = dr["FirstName"].ToString();
                    u.LastName = dr["LastName"].ToString();
                    u.Password = dr["Password"].ToString();
                    u.Email = dr["Email"].ToString();
                    u.Mobile = dr["Mobile"].ToString();
                    u.Address = dr["Address"].ToString();
                    u.Gender = dr["Gender"].ToString();
                    u.Sports = dr["Sports"].ToString();
                    u.DOB = dr["DOB"].ToString();
                    u.StateId = dr["StateId"].ToString();
                    u.CityId = dr["CityId"].ToString();
                }
            }
            return u;
        }

        [WebMethod]
        public static string DeleteUser(int userId)
        {
            using (SqlConnection con = new SqlConnection("Data Source=localhost;Initial Catalog=studentmanagmentsystem;Integrated Security=True;"))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("DELETE FROM UserRegistration WHERE UserId=@UserId", con);
                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.ExecuteNonQuery();
            }
            return "Deleted Successfully!";
        }

        // Classes
        public class State { public int StateId; public string StateName; }
        public class City { public int CityId; public string CityName; }
        public class User { public string UserId, FirstName, LastName, Password, Email, Mobile, Address, Gender, Sports, DOB, StateId, CityId; }
        public class UserView { public int UserId; public string FirstName, LastName, Email, Mobile, Gender, Sports, DOB, StateName, CityName; }
    }
}
