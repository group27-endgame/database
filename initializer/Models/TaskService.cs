public class Service: Task
{
    private int userId;
    private int categoryId;
    private string serviceName;
    private string serviceDetail;
    private DateTime posted;
    private double price;
    private string location;
    private string status;

    public Service(int userId, int categoryId, string serviceName, string serviceDetail, DateTime posted, double price, string location, string status)
        :base(userId, categoryId, serviceName, serviceDetail, posted, price, location, status)
    {
        this.userId = userId;
        this.categoryId = categoryId;
        this.serviceName = serviceName;
        this.serviceDetail = serviceDetail;
        this.posted = posted;
        this.price = price;
        this.location = location;
        this.status = status;
    }

    public override string toSql()
    {
        return $"INSERT INTO dbo.Task_Services (service_title, users_id, category_id, service_detail, service_money_amount, service_pick_up_location, service_posted_datetime, service_status)" +
            $" VALUES " +
            $"('{this.serviceName}', {this.userId}, {this.categoryId}, '{this.serviceDetail}', {this.price}, '{this.location}', {new DateTimeOffset(this.posted).ToUnixTimeMilliseconds()}, '{this.status}');";
    }
}