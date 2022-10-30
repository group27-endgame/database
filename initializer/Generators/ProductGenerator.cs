/// <summary>
/// Generator for SQL files for Products and Products Bids.
/// SQL File can be found in output/products.sql.
/// </summary>
/// <param name="amount">How many Products will be generated.</param>
/// <param name="usersAmount">How many Users were generated. This will be used as userIds for Products</param>
/// <param name="minPrice">Minimum price for Products</param>
/// <param name="maxPrice">Maximum price for Products</param>
/// <param name="minBids">Minimum of bids generated for each Product</param>
/// <param name="maxBids">Maximum of bids generated for each Product</param>
/// <param name="startDate">Start date from when Products will be generated</param>
/// <param name="endDate">End date till when Products will be generated</param>
/// <param name="categories">Which categories are included in csv file and are mapped with ID in model.</param>
/// <param name="statusOpenOnly">If true, only open Products will be generated. If false then both close and open will be generated.</param>
public class ProductGenerator
{
    private int amount,usersAmount,minPrice, maxPrice, minBids, maxBids;
    private DateTime startDate,endDate;
    private List<Category> categories;
    bool statusOpenOnly;

    public ProductGenerator(int amount, int usersAmount, int minPrice, int maxPrice, int minBids, int maxBids, DateTime startDate, DateTime endDate, List<Category> categories, bool statusOpenOnly)
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
        Console.ForegroundColor = ConsoleColor.Yellow;
        Console.WriteLine("Staring to Generate Products");

        string[] allProducts = File.ReadAllLines("data/products.csv");
        string[] locations = File.ReadAllLines("data/locations.csv");

        Directory.CreateDirectory("output");

        using(TextWriter tw = new StreamWriter("output/products.sql"))
        {
            for(int i = 0; i<this.amount; i++)
            {
                long timestampStartDate = new DateTimeOffset(this.startDate).ToUnixTimeMilliseconds();
                long timestampEndDate = new DateTimeOffset(this.endDate).ToUnixTimeMilliseconds();

                int ownerId = new Random().Next(1, this.usersAmount+1);

                DateTime randomDate = DateTimeOffset.FromUnixTimeMilliseconds(new Random().NextInt64(timestampStartDate, timestampEndDate)).DateTime;

                Category randomCategory = this.categories[new Random().Next(1, this.categories.Count)];
                List<string> productCat = new List<string>();

                foreach(string productss in allProducts)
                {
                    if(productss.Split(",")[1].Contains(randomCategory.getCategoryName()))
                        productCat.Add(productss.Split(",")[0]);
                }

                string productName = productCat[new Random().Next(0, productCat.Count)];

                Product product = new Product(
                    ownerId, 
                    randomCategory.getCategoryId(),
                    productName,
                    $"Selling {productName}. If you are interested please contact me",
                    randomDate,
                    new Random().Next(this.minPrice, this.maxPrice),
                    locations[new Random().Next(0, locations.Length)],
                    statusOpenOnly ? "open" : new Random().Next(0, 2) == 1 ? "open" : "closed"
                );

                tw.WriteLine(product.toSql());

                for(int j = 0;j<new Random().Next(minBids, maxBids); j++){
                    int bidderId = 0;

                    do{
                        bidderId = new Random().Next(1, this.usersAmount+1);
                    }while(bidderId == ownerId);

                    Bid bidProduct = new BidProduct(i+1, bidderId);
                    tw.WriteLine(bidProduct.toSql());
                }
            }
        }

        Console.WriteLine("End of Generating Products");
    }
}