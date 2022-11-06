public class UserGenerator
{
    private int amount;
    private DateTime startDate,endDate;

    public UserGenerator(int amount, DateTime startDate, DateTime endDate)
    {
        this.amount = amount;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    public void generate()
    {
        Console.ForegroundColor = ConsoleColor.Blue;
        Console.WriteLine("Staring to Generate Users");
        string[] usernames = File.ReadAllLines("data/users.csv");
        string[] locations = File.ReadAllLines("data/locations.csv");

        using(TextWriter tw = new StreamWriter("output/users.sql"))
        {
            Directory.CreateDirectory("output");
            
            for(int i = 0; i<usernames.Length; i+=(usernames.Length/amount))
            {
                long timestampStartDate = new DateTimeOffset(this.startDate).ToUnixTimeMilliseconds();
                long timestampEndDate = new DateTimeOffset(this.endDate).ToUnixTimeMilliseconds();
                DateTime randomDate = DateTimeOffset.FromUnixTimeMilliseconds(new Random().NextInt64(timestampStartDate, timestampEndDate)).DateTime;

                string location = locations[new Random().Next(0, locations.Length)];
                string city = location.Split(",")[0];
                string region = location.Split(",")[1];
                User user = new User($"{usernames[i]}@gmail.com", usernames[i], $"{city}, {region}", randomDate);
                tw.WriteLine(user.toSql());
                tw.WriteLine($"INSERT INTO dbo.Users_Roles values ({(i/(usernames.Length/amount)+1)}, 1);");
            }
        }
        Console.WriteLine("End of Generating Users");
    }
}