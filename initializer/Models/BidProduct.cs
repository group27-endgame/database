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
        return "INSERT INTO dbo.Bids_Product (product_id, users_id) VALUES " + 
            $"({this.productId}, {this.userId});\n" +
            $"UPDATE dbo.Products SET product_number_of_bids = product_number_of_bids+1 WHERE product_id={this.productId};";
    }
}