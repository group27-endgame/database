class BidProduct: Bid
{
    private int productId;
    private int userId;
    private int value;

    public BidProduct(int productId, int userId, int value)
        :base(productId, userId, value)
    {
        this.productId = productId;
        this.userId = userId;
        this.value = value;
    }

    public override string toSql()
    {
        return "INSERT INTO dbo.Bids_Product (product_id, users_id, value) VALUES " + 
            $"({this.productId}, {this.userId}, {this.value});\n" +
            $"UPDATE dbo.Products SET product_number_of_bids = product_number_of_bids+1 WHERE product_id={this.productId};";
    }
}