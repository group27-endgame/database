public abstract class Task
{
    public Task(int userId, int categoryId, string name, string detail, DateTime posted, double price, string location, string status)
    {}
    public abstract string toSql();
}