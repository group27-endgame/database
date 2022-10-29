

/*
drop table [Advella].[dbo].[Reported_Products];
drop table [Advella].[dbo].[Reported_Services];
drop table [Advella].[dbo].[Chats_Product];
drop table [Advella].[dbo].[Chats_Service];
drop table [Advella].[dbo].[Bids_Product];
drop table [Advella].[dbo].[Bids_Service];
drop table [Advella].[dbo].[Products];
drop table [Advella].[dbo].[Task_Services];
drop table [Advella].[dbo].[Categories_Product];
drop table [Advella].[dbo].[Categories_Service];
drop table [Advella].[dbo].[Contact_Us];
drop table [Advella].[dbo].[Ratings];
drop table [Advella].[dbo].[Users_Roles];
drop table [Advella].[dbo].[Roles];
drop table [Advella].[dbo].[Users];
*/

-- DROP DATABASE --
alter database [Advella] set single_user with rollback immediate
drop database Advella
-- DROP DATABASE --

CREATE DATABASE Advella

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Users]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Users](
	users_id INT IDENTITY PRIMARY KEY,
	email NCHAR VARYING(100) NOT NULL,
	user_password NCHAR VARYING(100) NOT NULL,
	username NCHAR VARYING(100) NOT NULL,
	user_description NCHAR VARYING(200),
	user_location NCHAR VARYING(100),
	registration_datetime DATETIME DEFAULT GETDATE()
);
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Roles]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Roles](
	role_id INT IDENTITY PRIMARY KEY,
	role_name NCHAR VARYING(100)
);

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Users_Roles]') AND type in (N'U'))

INSERT INTO [Advella].[dbo].[Roles] VALUES ('user'), ('admin');

CREATE TABLE [Advella].[dbo].[Users_Roles](
	users_id INT,
	role_id INT,
	FOREIGN KEY(users_id) REFERENCES [Advella].[dbo].[Users](users_id),
	FOREIGN KEY(role_id) REFERENCES [Advella].[dbo].[Roles](role_id)
);

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Ratings]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Ratings](
	rating_id INT IDENTITY PRIMARY KEY,
	users_id INT,
	rating FLOAT,
	votes INT DEFAULT 0,
	FOREIGN KEY(users_id) REFERENCES [Advella].[dbo].[Users](users_id)
);

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Contact_Us]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Contact_Us](
	contact_us_id INT IDENTITY PRIMARY KEY,
	users_id INT,
	message_datetime DATETIME DEFAULT GETDATE(),
	message_content NCHAR VARYING(100),
	seen BIT DEFAULT 0,
	FOREIGN KEY(users_id) REFERENCES [Advella].[dbo].[Users](users_id)
);
--ALTER TABLE [Advella].[dbo].[Contact_Us] ADD seen BIT

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Categories_Service]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Categories_Service](
	category_id INT IDENTITY PRIMARY KEY,
	category_title NCHAR VARYING(100) NOT NULL
);

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Categories_Product]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Categories_Product](
	category_id INT IDENTITY PRIMARY KEY,
	category_title NCHAR VARYING(100) NOT NULL
);

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Task_Services]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Task_Services](
	service_id INT IDENTITY PRIMARY KEY,
	service_title NCHAR VARYING(100) NOT NULL,
	users_id INT,
	category_id INT,
	service_detail NCHAR VARYING(200),
	service_money_amount FLOAT DEFAULT 0,
	service_duration INT,
	service_posted_datetime DATETIME DEFAULT GETDATE(),
	service_deadline DATETIME,
	service_location NCHAR VARYING(100),
	service_number_of_bids INT DEFAULT 0,
	service_number_of_likes INT DEFAULT 0,
	service_status NCHAR VARYING(50) DEFAULT 'open',
	FOREIGN KEY(users_id) REFERENCES [Advella].[dbo].[Users](users_id),
	FOREIGN KEY(category_id) REFERENCES [Advella].[dbo].[Categories_Service](category_id)
);

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Products]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Products](
	product_id INT IDENTITY PRIMARY KEY,
	product_title NCHAR VARYING(100) NOT NULL,
	users_id INT NOT NULL,
	category_id INT NOT NULL,
	product_detail NCHAR VARYING(200),
	product_money_amount FLOAT DEFAULT 0,
	product_pick_up_location NCHAR VARYING(100),
	product_posted_datetime DATETIME DEFAULT GETDATE(),
	product_deadline DATETIME,
	product_number_of_bids INT DEFAULT 0,
	product_status NCHAR VARYING(50) DEFAULT 'open',
	FOREIGN KEY(users_id) REFERENCES [Advella].[dbo].[Users](users_id),
	FOREIGN KEY(category_id) REFERENCES [Advella].[dbo].[Categories_Service](category_id)
);

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Bids_Service]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Bids_Service](
	service_id INT,
	users_id INT,
	FOREIGN KEY(service_id) REFERENCES [Advella].[dbo].[Task_Services](service_id),
	FOREIGN KEY(users_id) REFERENCES [Advella].[dbo].[Users](users_id)
);

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Bids_Product]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Bids_Product](
	product_id INT,
	users_id INT,
	FOREIGN KEY(product_id) REFERENCES [Advella].[dbo].[Products](product_id),
	FOREIGN KEY(users_id) REFERENCES [Advella].[dbo].[Users](users_id)
);

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Chats_Service]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Chats_Service](
	chat_id INT IDENTITY PRIMARY KEY,
	service_id INT,
	users_id INT,
	chat_message NCHAR VARYING(200),
	FOREIGN KEY(service_id) REFERENCES [Advella].[dbo].[Task_Services](service_id),
	FOREIGN KEY(users_id) REFERENCES [Advella].[dbo].[Users](users_id)
);

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Chats_Product]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Chats_Product](
	chat_id INT IDENTITY PRIMARY KEY,
	product_id INT,
	users_id INT,
	chat_message NCHAR VARYING(200),
	FOREIGN KEY(product_id) REFERENCES [Advella].[dbo].[Products](product_id),
	FOREIGN KEY(users_id) REFERENCES [Advella].[dbo].[Users](users_id)
);

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Reported_Services]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Reported_Services](
	reported_service_id INT IDENTITY PRIMARY KEY,
	service_id INT,
	users_id INT,
	reported_datetime DATETIME DEFAULT GETDATE(),
	reason NCHAR VARYING(200),
	FOREIGN KEY(service_id) REFERENCES [Advella].[dbo].[Task_Services](service_id),
	FOREIGN KEY(users_id) REFERENCES [Advella].[dbo].[Users](users_id)
);

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Reported_Products]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Reported_Products](
	reported_product_id INT IDENTITY PRIMARY KEY,
	product_id INT,
	users_id INT,
	reported_datetime DATETIME DEFAULT GETDATE(),
	reason NCHAR VARYING(200),
	FOREIGN KEY(product_id) REFERENCES [Advella].[dbo].[Products](product_id),
	FOREIGN KEY(users_id) REFERENCES [Advella].[dbo].[Users](users_id)
);

/*
INSERT INTO [Advella].[dbo].[Users] VALUES ('seymourbutz@butz.com', 'mikehunt', 'seymourbutz', 'wazzup', 'hell', '2022-09-30 23:59:02');--, '2022-09-30 23:59:02');
INSERT INTO [Advella].[dbo].[Roles] VALUES ('user');
INSERT INTO [Advella].[dbo].[Users_Roles] VALUES (1, 1);
INSERT INTO [Advella].[dbo].[Ratings] VALUES (1, 8.5, 110);
INSERT INTO [Advella].[dbo].[Contact_Us] VALUES (1, '2022-09-30 23:59:02', 'ymca', 0);
INSERT INTO [Advella].[dbo].[Categories_Service] VALUES ('Prostitute');
INSERT INTO [Advella].[dbo].[Categories_Product] VALUES ('Erotic');
INSERT INTO [Advella].[dbo].[Task_Services] VALUES ('Call girl', 1, 1, 'you know what it is', 5.50, 100, '2022-09-30 23:59:02', '2022-09-30 23:59:02', 'your house', 1000, 5000, 'Open');
INSERT INTO [Advella].[dbo].[Products] VALUES ('Teletubbies toy', 1, 1, 'you can do whatever you want with it if you catch my drift', 55550.00, 'sewers', '2022-09-30 23:59:02', '2022-09-30 23:59:02', 5000, 'Open');
INSERT INTO [Advella].[dbo].[Chats_Service] VALUES (1, 1, 'do pice');
INSERT INTO [Advella].[dbo].[Chats_Product] VALUES (1, 1, 'do prdele');
INSERT INTO [Advella].[dbo].[Reported_Services] VALUES (1, 1, '2022-09-30 23:59:02', 'finally, a worthy opponent');
INSERT INTO [Advella].[dbo].[Reported_Products] VALUES (1, 1, '2022-09-30 23:59:02', 'avengers assemble');
*/