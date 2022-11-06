class Program
{
    public static void Main()
    {
        List<Category> serviceCategories = new List<Category>{
            new Category(1, "Technology"),
            new Category(2, "Marketing"),
            new Category(3, "Lifestyle"),
        };
        List<Category> productCategories = new List<Category>{
            new Category(1, "Books"),
            new Category(2, "Laptops"),
            new Category(3, "Phones"),
        };

        int usersAmount = 100, serviceAmount = 100, productAmount = 100;
        int minPrice = 500, maxPrice = 20000;
        int minBids = 0, maxBids = 50;

        DateTime startDate = new DateTime(2022, 6, 1), endDate = new DateTime(2022, 11, 15);

        UserGenerator userGenerator = new UserGenerator(usersAmount, startDate, endDate);
        ServiceGenerator serviceGenerator = new ServiceGenerator(serviceAmount, usersAmount, minPrice, maxPrice, minBids, maxBids, startDate, endDate, serviceCategories, false);
        ProductGenerator productGenerator = new ProductGenerator(productAmount, usersAmount, minPrice, maxPrice, minBids, maxBids, startDate, endDate, productCategories, false);

        userGenerator.generate();
        serviceGenerator.generate();
        productGenerator.generate();
    }
}