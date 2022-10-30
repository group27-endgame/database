class BidService: Bid
{
    private int serviceId;
    private int userId;

    public BidService(int serviceId, int userId)
        :base(serviceId, userId)
    {
        this.serviceId = serviceId;
        this.userId = userId;
    }

    public override string toSql()
    {
        return "INSERT INTO dbo.Bids_Service (service_id, users_id) VALUES " + 
            $"({this.serviceId}, {this.userId});";
    }
}