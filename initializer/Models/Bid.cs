public abstract class Bid
{
    public Bid(int bidId, int userId, int value){}

    public abstract string toSql();
}