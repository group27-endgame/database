class BidService: Bid
{
    private int serviceId;
    private int userId;
    private int value;

    public BidService(int serviceId, int userId, int value)
        :base(serviceId, userId, value)
    {
        this.serviceId = serviceId;
        this.userId = userId;
        this.value = value;
    }

    public override string toSql()
    {
        return "INSERT INTO dbo.Bids_Service (service_id, users_id, value) VALUES " + 
            $"({this.serviceId}, {this.userId}, {this.value});\n" +
            $"UPDATE dbo.Task_Services SET service_number_of_bids = service_number_of_bids+1 WHERE service_id = {this.serviceId};";
    }
}