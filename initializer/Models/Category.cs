public class Category
{
    private int categoryId;
    private string categoryName;

    public Category(int categoryId, string categoryName)
    {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
    }

    public int getCategoryId() => this.categoryId;

    public string getCategoryName() => this.categoryName;
}