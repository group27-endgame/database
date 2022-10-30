
/*
drop table [AdvellaDW].[stage].[Dim_Users];
drop table [AdvellaDW].[stage].[Dim_Services];
drop table [AdvellaDW].[stage].[Dim_Products];
drop table [AdvellaDW].[stage].[Dim_Categories_Service];
drop table [AdvellaDW].[stage].[Dim_Categories_Product];
drop table [AdvellaDW].[stage].[Dim_Reported_Services];
drop table [AdvellaDW].[stage].[Dim_Reported_Products];
drop table [AdvellaDW].[stage].[Dim_Categories_Report];

drop table [AdvellaDW].[stage].[Fact_User];
drop table [AdvellaDW].[stage].[Fact_Task_Service];
drop table [AdvellaDW].[stage].[Fact_Product];
drop table [AdvellaDW].[stage].[Fact_Service_Reporting];
drop table [AdvellaDW].[stage].[Fact_Product_Reporting];
*/


-- DIMENSION TABLES

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AdvellaDW].[stage].[Dim_Users]') AND type in (N'U'))

CREATE TABLE [AdvellaDW].[stage].[Dim_Users] (
	users_id INT PRIMARY KEY,
	email NCHAR VARYING(100),
	user_password NCHAR VARYING(100),
	username NCHAR VARYING(100),
	user_description NCHAR VARYING(200)
);


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AdvellaDW].[stage].[Dim_Services]') AND type in (N'U'))

CREATE TABLE [AdvellaDW].[stage].[Dim_Services] (
	service_id INT PRIMARY KEY,
	service_title NCHAR VARYING(100),
	service_detail NCHAR VARYING(200)
);


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AdvellaDW].[stage].[Dim_Products]') AND type in (N'U'))

CREATE TABLE [AdvellaDW].[stage].[Dim_Products] (
	product_id INT PRIMARY KEY,
	product_title NCHAR VARYING(100),
	product_detail NCHAR VARYING(200)
);


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AdvellaDW].[stage].[Dim_Categories_Service]') AND type in (N'U'))

CREATE TABLE [AdvellaDW].[stage].[Dim_Categories_Service] (
	category_id INT PRIMARY KEY,
	category_title NCHAR VARYING(100)
);


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AdvellaDW].[stage].[Dim_Categories_Product]') AND type in (N'U'))

CREATE TABLE [AdvellaDW].[stage].[Dim_Categories_Product] (
	category_id INT PRIMARY KEY,
	category_title NCHAR VARYING(100)
);


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AdvellaDW].[stage].[Dim_Reported_Services]') AND type in (N'U'))

CREATE TABLE [AdvellaDW].[stage].[Dim_Reported_Services] (
	reported_service_id INT PRIMARY KEY,
	reason NCHAR VARYING(200),
);


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AdvellaDW].[stage].[Dim_Reported_Products]') AND type in (N'U'))

CREATE TABLE [AdvellaDW].[stage].[Dim_Reported_Products] (
	reported_product_id INT PRIMARY KEY,
	reason NCHAR VARYING(200),
);


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AdvellaDW].[stage].[Dim_Categories_Report]') AND type in (N'U'))

CREATE TABLE [AdvellaDW].[stage].[Dim_Categories_Report] (
	category_id INT PRIMARY KEY,
	category_title NCHAR VARYING(100)
);




-- FACT TABLES

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AdvellaDW].[stage].[Fact_User]') AND type in (N'U'))

CREATE TABLE [AdvellaDW].[stage].[Fact_User] (
	fact_user_id INT IDENTITY,
	location NCHAR VARYING(100),
	registration_datetime DATETIME,
	rating FLOAT,
	users_id INT
);


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AdvellaDW].[stage].[Fact_Task_Service]') AND type in (N'U'))

CREATE TABLE [AdvellaDW].[stage].[Fact_Task_Service] (
	fact_service_id INT IDENTITY,
	money_amount FLOAT,
	location NCHAR VARYING(100),
	posted_datetime DATETIME,
	deadline DATETIME,
	number_of_bids INT,
	status NCHAR VARYING(50),
	service_id INT,
	category_id INT,
	users_id INT
);


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AdvellaDW].[stage].[Fact_Product]') AND type in (N'U'))

CREATE TABLE [AdvellaDW].[stage].[Fact_Product] (
	fact_product_id INT IDENTITY,
	money_amount FLOAT,
	location NCHAR VARYING(100),
	posted_datetime DATETIME,
	deadline DATETIME,
	number_of_bids INT,
	status NCHAR VARYING(50),
	product_id INT,
	category_id INT,
	users_id INT
);


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AdvellaDW].[stage].[Fact_Service_Reporting]') AND type in (N'U'))

CREATE TABLE [AdvellaDW].[stage].[Fact_Service_Reporting] (
	fact_service_reporting_id INT IDENTITY,
	reported_datetime DATETIME,
	service_id INT,
	reported_service_id INT,
	category_id INT,
	users_id INT
);


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AdvellaDW].[stage].[Fact_Product_Reporting]') AND type in (N'U'))

CREATE TABLE [AdvellaDW].[stage].[Fact_Product_Reporting] (
	fact_product_reporting_id INT IDENTITY,
	reported_datetime DATETIME,
	product_id INT,
	reported_product_id INT,
	category_id INT,
	users_id INT
);



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



/*
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
*/