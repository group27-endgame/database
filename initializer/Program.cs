class Program
{
    public static void Main()
    {
        List<Category> serviceCategories = new List<Category>{
            new Category(1, "Technology"),
            new Category(2, "Marketing"),
            new Category(2, "Lifestyle"),
        };
        List<Category> productCategories = new List<Category>{
            new Category(1, "Books"),
            new Category(2, "Laptops"),
            new Category(2, "Phones"),
        };

        int usersAmount = 200, serviceAmount = 200, productAmount = 200;

        UserGenerator userGenerator = new UserGenerator(usersAmount);
        ServiceGenerator serviceGenerator = new ServiceGenerator(serviceAmount, usersAmount, 500, 50000, 0, 10, new DateTime(2022, 6, 1), new DateTime(2022, 11, 1), serviceCategories, false);
        ProductGenerator productGenerator = new ProductGenerator(productAmount, usersAmount, 500, 50000, 0, 10, new DateTime(2022, 6, 1), new DateTime(2022, 11, 1), productCategories, false);

        userGenerator.generate();
        serviceGenerator.generate();
        productGenerator.generate();
    }
}