class BidProduct: Bid
{
    private int productId;
    private int userId;

    public BidProduct(int productId, int userId)
        :base(productId, userId)
    {
        this.productId = productId;
        this.userId = userId;
    }

    public override string toSql()
    {
        return "INSERT INTO dbo.Bids_Service (product_id, users_id) VALUES " + 
            $"({this.productId}, {this.userId});\n" +
            $"UPDATE dbo.Task_Services SET service_number_of_bids = service_number_of_bids+1 WHERE product_id={this.productId};";
    }
}