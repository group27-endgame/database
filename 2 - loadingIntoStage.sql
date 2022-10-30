
--need to drop the constraints and add them again for testing. will most probably be removed later

alter table [AdvellaDW].[stage].[Fact_User] drop constraint FK_Users_Id;

alter table [AdvellaDW].[stage].[Fact_Task_Service] drop constraint FK_Service_Id_Task_Service;
alter table [AdvellaDW].[stage].[Fact_Task_Service] drop constraint FK_Category_Id_Task_Service;
alter table [AdvellaDW].[stage].[Fact_Task_Service] drop constraint FK_Users_Id_Task_Service;

alter table [AdvellaDW].[stage].[Fact_Product] drop constraint FK_Product_Id_Product;
alter table [AdvellaDW].[stage].[Fact_Product] drop constraint FK_Category_Id_Product;
alter table [AdvellaDW].[stage].[Fact_Product] drop constraint FK_Users_Id_Product;

alter table [AdvellaDW].[stage].[Fact_Service_Reporting] drop constraint FK_Reported_Service_Id_Service;
alter table [AdvellaDW].[stage].[Fact_Service_Reporting] drop constraint FK_Category_Id_Service_Category;
alter table [AdvellaDW].[stage].[Fact_Service_Reporting] drop constraint FK_Users_Id_Service_Category;


alter table [AdvellaDW].[stage].[Fact_Product_Reporting] drop constraint FK_Reported_Product_Id_Product;
alter table [AdvellaDW].[stage].[Fact_Product_Reporting] drop constraint FK_Category_Id_Product_Category;
alter table [AdvellaDW].[stage].[Fact_Product_Reporting] drop constraint FK_Users_Id_Product_Category;

truncate table [AdvellaDW].[stage].[Dim_Users];
truncate table [AdvellaDW].[stage].[Dim_Services];
truncate table [AdvellaDW].[stage].[Dim_Products];
truncate table [AdvellaDW].[stage].[Dim_Categories_Service];
truncate table [AdvellaDW].[stage].[Dim_Categories_Product];
truncate table [AdvellaDW].[stage].[Dim_Reported_Services];
truncate table [AdvellaDW].[stage].[Dim_Reported_Products];
truncate table [AdvellaDW].[stage].[Dim_Categories_Report];

truncate table [AdvellaDW].[stage].[Fact_User];
truncate table [AdvellaDW].[stage].[Fact_Task_Service];
truncate table [AdvellaDW].[stage].[Fact_Product];
truncate table [AdvellaDW].[stage].[Fact_Service_Reporting];
truncate table [AdvellaDW].[stage].[Fact_Product_Reporting];

ALTER TABLE [AdvellaDW].[stage].[Fact_User] ADD CONSTRAINT FK_Users_Id FOREIGN KEY(users_id) REFERENCES [AdvellaDW].[stage].[Dim_Users](users_id);

ALTER TABLE [AdvellaDW].[stage].[Fact_Task_Service] ADD CONSTRAINT FK_Service_Id_Task_Service FOREIGN KEY(service_id) REFERENCES [AdvellaDW].[stage].[Dim_Services](service_id);
ALTER TABLE [AdvellaDW].[stage].[Fact_Task_Service] ADD CONSTRAINT FK_Category_Id_Task_Service FOREIGN KEY(category_id) REFERENCES [AdvellaDW].[stage].[Dim_Categories_Service](category_id);
ALTER TABLE [AdvellaDW].[stage].[Fact_Task_Service] ADD CONSTRAINT FK_Users_Id_Task_Service FOREIGN KEY(users_id) REFERENCES [AdvellaDW].[stage].[Dim_Users](users_id);

ALTER TABLE [AdvellaDW].[stage].[Fact_Product] ADD CONSTRAINT FK_Product_Id_Product FOREIGN KEY(product_id) REFERENCES [AdvellaDW].[stage].[Dim_Products](product_id);
ALTER TABLE [AdvellaDW].[stage].[Fact_Product] ADD CONSTRAINT FK_Category_Id_Product FOREIGN KEY(category_id) REFERENCES [AdvellaDW].[stage].[Dim_Categories_Product](category_id);
ALTER TABLE [AdvellaDW].[stage].[Fact_Product] ADD CONSTRAINT FK_Users_Id_Product FOREIGN KEY(users_id) REFERENCES [AdvellaDW].[stage].[Dim_Users](users_id);

ALTER TABLE [AdvellaDW].[stage].[Fact_Service_Reporting] ADD CONSTRAINT FK_Reported_Service_Id_Service FOREIGN KEY(reported_service_id) REFERENCES [AdvellaDW].[stage].[Dim_Reported_Services](reported_service_id);
ALTER TABLE [AdvellaDW].[stage].[Fact_Service_Reporting] ADD CONSTRAINT FK_Category_Id_Service_Category FOREIGN KEY(category_id) REFERENCES [AdvellaDW].[stage].[Dim_Categories_Report](category_id);
ALTER TABLE [AdvellaDW].[stage].[Fact_Service_Reporting] ADD CONSTRAINT FK_Users_Id_Service_Category FOREIGN KEY(users_id) REFERENCES [AdvellaDW].[stage].[Dim_Users](users_id);

ALTER TABLE [AdvellaDW].[stage].[Fact_Product_Reporting] ADD CONSTRAINT FK_Reported_Product_Id_Product FOREIGN KEY(reported_product_id) REFERENCES [AdvellaDW].[stage].[Dim_Reported_Products](reported_product_id);
ALTER TABLE [AdvellaDW].[stage].[Fact_Product_Reporting] ADD CONSTRAINT FK_Category_Id_Product_Category FOREIGN KEY(category_id) REFERENCES [AdvellaDW].[stage].[Dim_Categories_Report](category_id);
ALTER TABLE [AdvellaDW].[stage].[Fact_Product_Reporting] ADD CONSTRAINT FK_Users_Id_Product_Category FOREIGN KEY(users_id) REFERENCES [AdvellaDW].[stage].[Dim_Users](users_id);



--inserting into dimension tables
INSERT INTO [AdvellaDW].[stage].[Dim_Users](
	[users_id], [email], [user_password], [username], [user_description]) 
SELECT [users_id], [email], [user_password], [username], [user_description]
FROM [Advella].[dbo].[Users]


INSERT INTO [AdvellaDW].[stage].[Dim_Services](
	[service_id], [service_title], [service_detail]) 
SELECT [service_id], [service_title], [service_detail]
FROM [Advella].[dbo].[Task_Services]


INSERT INTO [AdvellaDW].[stage].[Dim_Products](
	[product_id], [product_title], [product_detail]) 
SELECT [product_id], [product_title], [product_detail]
FROM [Advella].[dbo].[Products]


INSERT INTO [AdvellaDW].[stage].[Dim_Categories_Service](
	[category_id], [category_title]) 
SELECT [category_id], [category_title]
FROM [Advella].[dbo].[Categories_Service]


INSERT INTO [AdvellaDW].[stage].[Dim_Categories_Product](
	[category_id], [category_title]) 
SELECT [category_id], [category_title]
FROM [Advella].[dbo].[Categories_Product]


INSERT INTO [AdvellaDW].[stage].[Dim_Reported_Services](
	[reported_service_id], [reason]) 
SELECT [reported_service_id], [reason]
FROM [Advella].[dbo].[Reported_Services]


INSERT INTO [AdvellaDW].[stage].[Dim_Reported_Products](
	[reported_product_id], [reason]) 
SELECT [reported_product_id], [reason]
FROM [Advella].[dbo].[Reported_Products]


INSERT INTO [AdvellaDW].[stage].[Dim_Categories_Report](
	[category_id], [category_title]) 
SELECT [category_id], [category_title]
FROM [Advella].[dbo].[Categories_Report]




--inserting into fact table
INSERT INTO [AdvellaDW].[stage].[Fact_User](
	[location], [registration_datetime], [rating], [users_id])
SELECT [user_location], [registration_datetime], r.[rating], u.[users_id]
FROM [Advella].[dbo].[Users] u
INNER JOIN [Advella].[dbo].[Ratings] as r on r.users_id = u.users_id


INSERT INTO [AdvellaDW].[stage].[Fact_Task_Service](
	[money_amount], [location], [posted_datetime], [deadline], [number_of_bids], [status], [service_id], [category_id], [users_id])
SELECT [service_money_amount], [service_location], [service_posted_datetime], [service_deadline], [service_number_of_bids], [service_status], [service_id], c.[category_id], u.[users_id]
FROM [Advella].[dbo].[Task_Services] s
INNER JOIN [Advella].[dbo].[Categories_Service] as c on c.category_id = s.category_id
INNER JOIN [Advella].[dbo].[Users] as u on u.users_id = s.users_id


INSERT INTO [AdvellaDW].[stage].[Fact_Product](
	[money_amount], [location], [posted_datetime], [deadline], [number_of_bids], [status], [product_id], [category_id], [users_id])
SELECT [product_money_amount], [product_pick_up_location], [product_posted_datetime], [product_deadline], [product_number_of_bids], [product_status], [product_id], c.[category_id], u.[users_id]
FROM [Advella].[dbo].[Products] p
INNER JOIN [Advella].[dbo].[Categories_Service] as c on c.category_id = p.category_id
INNER JOIN [Advella].[dbo].[Users] as u on u.users_id = p.users_id


INSERT INTO [AdvellaDW].[stage].[Fact_Service_Reporting](
	[reported_datetime], [service_id], [reported_service_id], [category_id], [users_id])
SELECT [reported_datetime], s.[service_id], [reported_service_id], c.[category_id], u.[users_id]
FROM [Advella].[dbo].[Reported_Services] rs
INNER JOIN [Advella].[dbo].[Task_Services] as s on s.service_id = rs.service_id
INNER JOIN [Advella].[dbo].[Categories_Report] as c on c.category_id = rs.category_id
INNER JOIN [Advella].[dbo].[Users] as u on u.users_id = rs.users_id


INSERT INTO [AdvellaDW].[stage].[Fact_Product_Reporting](
	[reported_datetime], [product_id], [reported_product_id], [category_id], [users_id])
SELECT [reported_datetime], p.[product_id], [reported_product_id], c.[category_id], u.[users_id]
FROM [Advella].[dbo].[Reported_Products] rp
INNER JOIN [Advella].[dbo].[Products] as p on p.product_id = rp.product_id
INNER JOIN [Advella].[dbo].[Categories_Report] as c on c.category_id = rp.category_id
INNER JOIN [Advella].[dbo].[Users] as u on u.users_id = rp.users_id