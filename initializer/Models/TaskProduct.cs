public class Product: Task
{
    private int userId;
    private int categoryId;
    private string productName;
    private string productDetail;
    private DateTime posted;
    private double price;
    private string location;
    private string status;

    public Product(int userId, int categoryId, string productName, string productDetail, DateTime posted, double price, string location, string status)
        :base(userId, categoryId, productName, productDetail, posted, price, location, status)
    {
        this.userId = userId;
        this.categoryId = categoryId;
        this.productName = productName;
        this.productDetail = productDetail;
        this.posted = posted;
        this.price = price;
        this.location = location;
        this.status = status;
    }

    public override string toSql()
    {
        return $"INSERT INTO dbo.Products (product_title, users_id, category_id, product_detail, product_money_amount, product_pick_up_location, product_posted_datetime, product_status)" +
            $" VALUES " +
            $"('{this.productName}', {this.userId}, {this.categoryId}, '{this.productDetail}', {this.price}, '{this.location}', {new DateTimeOffset(this.posted).ToUnixTimeMilliseconds()}, '{this.status}');";
    }
}