class User
{
    private string email;
    private string password;
    private string username;
    private string description;
    private string location;
    private DateTime registrationDateTime;

    public User(string email, string username, string location, DateTime registrationDateTime)
    {
        this.email = email;
        this.password = "password";
        this.username = username;
        this.description = $"My name is {this.username} and I live in {this.location}. If you want to contact me outside of this awesome portal, you can do that on {this.email}";
        this.location = location;
        this.registrationDateTime = registrationDateTime;
    }

    public string toSql()
    {
        return "INSERT INTO dbo.Users (email, user_password, username, user_description, user_location, registration_datetime) VALUES " +
            $"('{this.email}', '{this.password}', '{this.username}', '{this.description}', '{this.location}', '{this.registrationDateTime}');";
    }
}