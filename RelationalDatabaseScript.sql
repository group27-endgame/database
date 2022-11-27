/*
drop table [Advella].[dbo].[Images_Products];
drop table [Advella].[dbo].[Images_Services];
drop table [Advella].[dbo].[Reported_Products];
drop table [Advella].[dbo].[Reported_Services];
drop table [Advella].[dbo].[Categories_Report]
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
drop table [Advella].[dbo].[Chats_User_History];
drop table [Advella].[dbo].[Chats_Room];
drop table [Advella].[dbo].[Chats_Message];
drop table [Advella].[dbo].[Users_Roles];
drop table [Advella].[dbo].[Roles];
drop table [Advella].[dbo].[Users];
*/

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Users]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Users](
	users_id INT IDENTITY PRIMARY KEY,
	email NCHAR VARYING(100),
	user_password NCHAR VARYING(100),
	username NCHAR VARYING(100),
	user_description NCHAR VARYING(200),
	user_location NCHAR VARYING(100),
	registration_datetime DATETIME DEFAULT GETDATE()
);

--ALTER TABLE [Advella].[dbo].[Users] ADD CONSTRAINT USERS_DEFAULT_DATE DEFAULT GETDATE() FOR registration_datetime;

--ALTER TABLE [Advella].[dbo].[Users] ADD registration_datetime DATETIME;

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Roles]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Roles](
	role_id INT IDENTITY PRIMARY KEY,
	role_name NCHAR VARYING(100)
);

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Users_Roles]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Users_Roles](
	users_id INT,
	role_id INT,
	FOREIGN KEY(users_id) REFERENCES [Advella].[dbo].[Users](users_id),
	FOREIGN KEY(role_id) REFERENCES [Advella].[dbo].[Roles](role_id)
);

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Chats_Room]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Chats_Room](
	id INT IDENTITY PRIMARY KEY,
	chat_id NCHAR VARYING(100),
	chat_sender_id INT,
	chat_recipient_id INT,
	FOREIGN KEY(chat_sender_id) REFERENCES [Advella].[dbo].[Users](users_id),
	FOREIGN KEY(chat_recipient_id) REFERENCES [Advella].[dbo].[Users](users_id)
);

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Chats_Message]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Chats_Message](
	id INT IDENTITY PRIMARY KEY,
	chat_id NCHAR VARYING(100),
	chat_sender_id INT,
	chat_recipient_id INT,
	chat_content NCHAR VARYING(256),
	chat_datetime DATETIME,
	chat_status NCHAR VARYING(50),
	FOREIGN KEY(chat_sender_id) REFERENCES [Advella].[dbo].[Users](users_id),
	FOREIGN KEY(chat_recipient_id) REFERENCES [Advella].[dbo].[Users](users_id)
);

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Chats_User_History]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Chats_User_History](
	chat_user_history_id INT IDENTITY PRIMARY KEY,
	chat_sender_id INT,
	chat_recipient_id INT,
	FOREIGN KEY(chat_sender_id) REFERENCES [Advella].[dbo].[Users](users_id),
	FOREIGN KEY(chat_recipient_id) REFERENCES [Advella].[dbo].[Users](users_id)
);

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Ratings]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Ratings](
	rating_id INT IDENTITY PRIMARY KEY,
	users_id INT,
	rating FLOAT,
	votes INT,
	FOREIGN KEY(users_id) REFERENCES [Advella].[dbo].[Users](users_id)
);

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Contact_Us]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Contact_Us](
	contact_us_id INT IDENTITY PRIMARY KEY,
	users_id INT,
	message_datetime DATETIME DEFAULT GETDATE(),
	message_content NCHAR VARYING(100),
	seen BIT,
	FOREIGN KEY(users_id) REFERENCES [Advella].[dbo].[Users](users_id)
);

--ALTER TABLE [Advella].[dbo].[Contact_Us] ADD seen BIT

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Categories_Service]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Categories_Service](
	category_id INT IDENTITY PRIMARY KEY,
	category_title NCHAR VARYING(100)
);

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Categories_Product]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Categories_Product](
	category_id INT IDENTITY PRIMARY KEY,
	category_title NCHAR VARYING(100)
);

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Task_Services]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Task_Services](
	service_id INT IDENTITY PRIMARY KEY,
	service_title NCHAR VARYING(100),
	users_id INT,
	category_id INT,
	service_detail NCHAR VARYING(200),
	service_money_amount FLOAT,
	service_duration INT,
	service_posted_datetime DATETIME DEFAULT GETDATE(),
	service_deadline DATETIME,
	service_location NCHAR VARYING(100),
	service_number_of_bids INT,
	service_status NCHAR VARYING(50),
	FOREIGN KEY(users_id) REFERENCES [Advella].[dbo].[Users](users_id),
	FOREIGN KEY(category_id) REFERENCES [Advella].[dbo].[Categories_Service](category_id)
);

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Products]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Products](
	product_id INT IDENTITY PRIMARY KEY,
	product_title NCHAR VARYING(100),
	users_id INT,
	category_id INT,
	product_detail NCHAR VARYING(200),
	product_money_amount FLOAT,
	product_pick_up_location NCHAR VARYING(100),
	product_posted_datetime DATETIME DEFAULT GETDATE(),
	product_deadline DATETIME,
	product_number_of_bids INT,
	product_status NCHAR VARYING(50),
	FOREIGN KEY(users_id) REFERENCES [Advella].[dbo].[Users](users_id),
	FOREIGN KEY(category_id) REFERENCES [Advella].[dbo].[Categories_Service](category_id)
);

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Bids_Service]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Bids_Service](
	service_id INT,
	users_id INT,
	bid_value FLOAT,
	FOREIGN KEY(service_id) REFERENCES [Advella].[dbo].[Task_Services](service_id),
	FOREIGN KEY(users_id) REFERENCES [Advella].[dbo].[Users](users_id)
);

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Bids_Product]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Bids_Product](
	product_id INT,
	users_id INT,
	bid_value FLOAT,
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

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Categories_Report]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Categories_Report](
	category_id INT IDENTITY PRIMARY KEY,
	category_title NCHAR VARYING(100)
);

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Reported_Services]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Reported_Services](
	reported_service_id INT IDENTITY PRIMARY KEY,
	service_id INT,
	users_id INT,
	category_id INT,
	reported_datetime DATETIME DEFAULT GETDATE(),
	reason NCHAR VARYING(200),
	FOREIGN KEY(service_id) REFERENCES [Advella].[dbo].[Task_Services](service_id),
	FOREIGN KEY(users_id) REFERENCES [Advella].[dbo].[Users](users_id),
	FOREIGN KEY(category_id) REFERENCES [Advella].[dbo].[Categories_Report](category_id)
);

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Reported_Products]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Reported_Products](
	reported_product_id INT IDENTITY PRIMARY KEY,
	product_id INT,
	users_id INT,
	category_id INT,
	reported_datetime DATETIME DEFAULT GETDATE(),
	reason NCHAR VARYING(200),
	FOREIGN KEY(product_id) REFERENCES [Advella].[dbo].[Products](product_id),
	FOREIGN KEY(users_id) REFERENCES [Advella].[dbo].[Users](users_id),
	FOREIGN KEY(category_id) REFERENCES [Advella].[dbo].[Categories_Report](category_id)
);

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Images_Services]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Images_Services](
	image_id INT IDENTITY PRIMARY KEY,
	service_id INT,
	path NCHAR VARYING(200),
	FOREIGN KEY(service_id) REFERENCES [Advella].[dbo].[Task_Services](service_id)
);

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Advella].[dbo].[Images_Products]') AND type in (N'U'))

CREATE TABLE [Advella].[dbo].[Images_Products](
	image_id INT IDENTITY PRIMARY KEY,
	product_id INT,
	path NCHAR VARYING(200),
	FOREIGN KEY(product_id) REFERENCES [Advella].[dbo].[Products](product_id)
);

/*
insert into [Advella].[dbo].[Roles] values ('user'), ('admin');

insert into [Advella].[dbo].[Categories_Product] values ('Books'), ('Laptops'), ('Phones');
insert into [Advella].[dbo].[Categories_Service] values ('Technology'), ('Marketing'), ('Lifestyle');
*/

/*
INSERT INTO [Advella].[dbo].[Users] VALUES ('seymourbutz@butz.com', 'mikehunt', 'seymourbutz', 'wazzup', 'hell', '2022-09-30 23:59:02');--, '2022-09-30 23:59:02');
INSERT INTO [Advella].[dbo].[Roles] VALUES ('user');
INSERT INTO [Advella].[dbo].[Users_Roles] VALUES (1, 1);
INSERT INTO [Advella].[dbo].[Ratings] VALUES (1, 8.5, 110);
INSERT INTO [Advella].[dbo].[Contact_Us] VALUES (1, '2022-09-30 23:59:02', 'ymca', 0);
INSERT INTO [Advella].[dbo].[Categories_Service] VALUES ('Prostitute');
INSERT INTO [Advella].[dbo].[Categories_Product] VALUES ('Erotic');
INSERT INTO [Advella].[dbo].[Task_Services] VALUES ('Call girl', 1, 1, 'you know what it is', 5.50, 100, '2022-09-30 23:59:02', '2022-09-30 23:59:02', 'your house', 1000, 'Open');
INSERT INTO [Advella].[dbo].[Products] VALUES ('Teletubbies toy', 1, 1, 'you can do whatever you want with it if you catch my drift', 55550.00, 'sewers', '2022-09-30 23:59:02', '2022-09-30 23:59:02', 5000, 'Open');
INSERT INTO [Advella].[dbo].[Chats_Service] VALUES (1, 1, 'do pice');
INSERT INTO [Advella].[dbo].[Chats_Product] VALUES (1, 1, 'do prdele');
INSERT INTO [Advella].[dbo].[Categories_Report] VALUES ('Spam');
INSERT INTO [Advella].[dbo].[Reported_Services] VALUES (1, 1, 1, '2022-09-30 23:59:02', 'finally, a worthy opponent');
INSERT INTO [Advella].[dbo].[Reported_Products] VALUES (1, 1, 1, '2022-09-30 23:59:02', 'avengers assemble');
*/



-- TRIGGERS CUZ MSSQL IS STUPID


GO
    CREATE TRIGGER trg_UpdateRegDate
    ON [Advella].[dbo].[Users]
    AFTER INSERT
    AS
        UPDATE [Advella].[dbo].[Users]
        SET registration_datetime = GETDATE()
        WHERE users_id IN (SELECT DISTINCT users_id FROM Inserted)
GO

GO
    CREATE TRIGGER trg_ContactUsDate
    ON [Advella].[dbo].[Contact_Us]
    AFTER INSERT
    AS
        UPDATE [Advella].[dbo].[Contact_Us]
        SET message_datetime = GETDATE(), seen = 0
        WHERE contact_us_id IN (SELECT DISTINCT contact_us_id FROM Inserted)
GO

GO
    CREATE TRIGGER ServicePostedDate
    ON [Advella].[dbo].[Task_Services]
    AFTER INSERT
    AS
        UPDATE [Advella].[dbo].[Task_Services]
        SET service_posted_datetime = GETDATE()
        WHERE service_id IN (SELECT DISTINCT service_id FROM Inserted)
GO

GO
    CREATE TRIGGER ProductPostedDate
    ON [Advella].[dbo].[Products]
    AFTER INSERT
    AS
        UPDATE [Advella].[dbo].[Products]
        SET product_posted_datetime = GETDATE()
        WHERE product_id IN (SELECT DISTINCT product_id FROM Inserted)
GO

GO
    CREATE TRIGGER Reported_ServicesDate
    ON [Advella].[dbo].[Reported_Services]
    AFTER INSERT
    AS
        UPDATE [Advella].[dbo].[Reported_Services]
        SET reported_datetime = GETDATE()
        WHERE reported_datetime IN (SELECT DISTINCT reported_datetime FROM Inserted)
GO

GO
    CREATE TRIGGER Reported_ProductsDate
    ON [Advella].[dbo].[Reported_Products]
    AFTER INSERT
    AS
        UPDATE [Advella].[dbo].[Reported_Products]
        SET reported_datetime = GETDATE()
        WHERE reported_datetime IN (SELECT DISTINCT reported_datetime FROM Inserted)
GO