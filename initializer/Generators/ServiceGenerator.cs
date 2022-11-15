/// <summary>
/// Generator for SQL files for Services and Service Bids.
/// SQL File can be found in output/services.sql.
/// </summary>
/// <param name="amount">How many Services will be generated.</param>
/// <param name="usersAmount">How many Users were generated. This will be used as userIds for Services</param>
/// <param name="minPrice">Minimum price for Services</param>
/// <param name="maxPrice">Maximum price for Services</param>
/// <param name="minBids">Minimum of bids generated for each Service</param>
/// <param name="maxBids">Maximum of bids generated for each Service</param>
/// <param name="startDate">Start date from when services will be generated</param>
/// <param name="endDate">End date till when services will be generated</param>
/// <param name="categories">Which categories are included in csv file and are mapped with ID in model.</param>
/// <param name="statusOpenOnly">If true, only open services will be generated. If false then both close and open will be generated.</param>
public class ServiceGenerator
{
    private int amount,usersAmount,minPrice, maxPrice, minBids, maxBids;
    private DateTime startDate,endDate;
    private List<Category> categories;
    bool statusOpenOnly;

    public ServiceGenerator(int amount, int usersAmount, int minPrice, int maxPrice, int minBids, int maxBids, DateTime startDate, DateTime endDate, List<Category> categories, bool statusOpenOnly)
    {
        this.amount = amount;
        this.usersAmount = usersAmount;
        this.startDate = startDate;
        this.endDate = endDate;
        this.minPrice = minPrice;
        this.maxPrice = maxPrice;
        this.minBids = minBids;
        this.maxBids = maxBids;
        this.categories = categories;
        this.statusOpenOnly = statusOpenOnly;
    }

    public void generate()
    {
        Console.ForegroundColor = ConsoleColor.Green;
        Console.WriteLine("Staring to Generate Services");

        string[] allServices = File.ReadAllLines("data/services.csv");
        string[] locations = File.ReadAllLines("data/locations.csv");

        Directory.CreateDirectory("output");

        using(TextWriter tw = new StreamWriter("output/services.sql"))
        {
            for(int i = 0; i<this.amount; i++)
            {
                long timestampStartDate = new DateTimeOffset(this.startDate).ToUnixTimeMilliseconds();
                long timestampEndDate = new DateTimeOffset(this.endDate).ToUnixTimeMilliseconds();

                int ownerId = new Random().Next(1, this.usersAmount+1);

                DateTime randomDate = DateTimeOffset.FromUnixTimeMilliseconds(new Random().NextInt64(timestampStartDate, timestampEndDate)).DateTime;

                Category randomCategory = this.categories[new Random().Next(1, this.categories.Count)];
                List<string> servicesCat = new List<string>();

                foreach(string servicee in allServices)
                {
                    if(servicee.Split(",")[1].Contains(randomCategory.getCategoryName()))
                        servicesCat.Add(servicee.Split(",")[0]);
                }

                string serviceName = servicesCat[new Random().Next(0, servicesCat.Count)];
                string location = locations[new Random().Next(0, locations.Length)];
                string city = location.Split(",")[0];
                string region = location.Split(",")[1];

                int price = new Random().Next(this.minPrice, this.maxPrice)

                Service service = new Service(
                    ownerId, 
                    randomCategory.getCategoryId(),
                    serviceName,
                    $"Offering my services for {serviceName}. If you are interested please contact me",
                    randomDate,
                    price,
                    $"{city}, {region}",
                    statusOpenOnly ? "open" : new Random().Next(0, 2) == 1 ? "open" : "closed"
                );

                tw.WriteLine(service.toSql());

                for(int j = 0;j<new Random().Next(minBids, maxBids); j++){
                    int bidderId = 0;

                    do{
                        bidderId = new Random().Next(1, this.usersAmount+1);
                    }while(bidderId == ownerId);

                    Bid bidService = new BidService(i+1, bidderId, price + ((i+1) * 100));
                    tw.WriteLine(bidService.toSql());
                }
            }
        }
        Console.WriteLine("End of Generating Services");
    }
}