public class UserGenerator
{
    private int amount;

    public UserGenerator(int amount)
    {
        this.amount = amount;
    }

    public void generate()
    {
        string[] usernames = File.ReadAllLines("data/users.csv");
        string[] locations = File.ReadAllLines("data/locations.csv");

        using(TextWriter tw = new StreamWriter("output/users.sql"))
        {
            Directory.CreateDirectory("output");
            
            for(int i = 0; i<usernames.Length; i+=(usernames.Length/amount))
            {
                User user = new User($"{usernames[i]}@gmail.com", usernames[i], locations[new Random().Next(0, locations.Length)]);
                tw.WriteLine(user.toSql());
            }
        }
    }
}