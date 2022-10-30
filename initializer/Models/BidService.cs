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
            $"({this.serviceId}, {this.userId});\n" +
            $"UPDATE dbo.Task_Services SET service_number_of_bids = service_number_of_bids+1 WHERE service_id = {this.serviceId};";
    }
}