


alter table [AdvellaDW].[edw].[Fact_User] drop constraint FK_U_ID_Fact_User;
alter table [AdvellaDW].[edw].[Fact_User] drop constraint FK_D_ID_Fact_User;
alter table [AdvellaDW].[edw].[Fact_User] drop constraint FK_T_ID_Fact_User;

alter table [AdvellaDW].[edw].[Fact_Task_Service] drop constraint FK_S_ID_Fact_Task_Service;
alter table [AdvellaDW].[edw].[Fact_Task_Service] drop constraint FK_CS_ID_Fact_Task_Service;
alter table [AdvellaDW].[edw].[Fact_Task_Service] drop constraint FK_U_ID_Fact_Task_Service;
alter table [AdvellaDW].[edw].[Fact_Task_Service] drop constraint FK_PD_ID_Fact_Task_Service;
alter table [AdvellaDW].[edw].[Fact_Task_Service] drop constraint FK_DD_ID_Fact_Task_Service;
alter table [AdvellaDW].[edw].[Fact_Task_Service] drop constraint FK_PT_ID_Fact_Task_Service;
alter table [AdvellaDW].[edw].[Fact_Task_Service] drop constraint FK_DT_ID_Fact_Task_Service;

alter table [AdvellaDW].[edw].[Fact_Product] drop constraint FK_P_ID_Fact_Product;
alter table [AdvellaDW].[edw].[Fact_Product] drop constraint FK_CP_ID_Fact_Product;
alter table [AdvellaDW].[edw].[Fact_Product] drop constraint FK_U_ID_Fact_Product;
alter table [AdvellaDW].[edw].[Fact_Product] drop constraint FK_PD_ID_Fact_Product;
alter table [AdvellaDW].[edw].[Fact_Product] drop constraint FK_DD_ID_Fact_Product;
alter table [AdvellaDW].[edw].[Fact_Product] drop constraint FK_PT_ID_Fact_Product;
alter table [AdvellaDW].[edw].[Fact_Product] drop constraint FK_DT_ID_Fact_Product;

alter table [AdvellaDW].[edw].[Fact_Service_Reporting] drop constraint FK_S_ID_Fact_Service_Reporting;
alter table [AdvellaDW].[edw].[Fact_Service_Reporting] drop constraint FK_RS_ID_Fact_Service_Reporting;
alter table [AdvellaDW].[edw].[Fact_Service_Reporting] drop constraint FK_CR_ID_Fact_Service_Reporting;
alter table [AdvellaDW].[edw].[Fact_Service_Reporting] drop constraint FK_U_ID_Fact_Service_Reporting;
alter table [AdvellaDW].[edw].[Fact_Service_Reporting] drop constraint FK_D_ID_Fact_Service_Reporting;
alter table [AdvellaDW].[edw].[Fact_Service_Reporting] drop constraint FK_T_ID_Fact_Service_Reporting;

alter table [AdvellaDW].[edw].[Fact_Product_Reporting] drop constraint FK_P_ID_Fact_Product_Reporting;
alter table [AdvellaDW].[edw].[Fact_Product_Reporting] drop constraint FK_RP_ID_Fact_Product_Reporting;
alter table [AdvellaDW].[edw].[Fact_Product_Reporting] drop constraint FK_CR_ID_Fact_Product_Reporting;
alter table [AdvellaDW].[edw].[Fact_Product_Reporting] drop constraint FK_U_ID_Fact_Product_Reporting;
alter table [AdvellaDW].[edw].[Fact_Product_Reporting] drop constraint FK_D_ID_Fact_Product_Reporting;
alter table [AdvellaDW].[edw].[Fact_Product_Reporting] drop constraint FK_T_ID_Fact_Product_Reporting



truncate table [AdvellaDW].[edw].[Dim_Users];
truncate table [AdvellaDW].[edw].[Dim_Services];
truncate table [AdvellaDW].[edw].[Dim_Products];
truncate table [AdvellaDW].[edw].[Dim_Categories_Service];
truncate table [AdvellaDW].[edw].[Dim_Categories_Product];
truncate table [AdvellaDW].[edw].[Dim_Reported_Services];
truncate table [AdvellaDW].[edw].[Dim_Reported_Products];
truncate table [AdvellaDW].[edw].[Dim_Categories_Report];

truncate table [AdvellaDW].[edw].[Fact_User];
truncate table [AdvellaDW].[edw].[Fact_Task_Service];
truncate table [AdvellaDW].[edw].[Fact_Product];
truncate table [AdvellaDW].[edw].[Fact_Service_Reporting];
truncate table [AdvellaDW].[edw].[Fact_Product_Reporting];


--adding foreign surrogate keys in [Fact_User]
ALTER TABLE [AdvellaDW].[edw].[Fact_User] ADD CONSTRAINT FK_U_ID_Fact_User FOREIGN KEY (U_ID) REFERENCES [AdvellaDW].[edw].[Dim_Users] (U_ID);
ALTER TABLE [AdvellaDW].[edw].[Fact_User] ADD CONSTRAINT FK_D_ID_Fact_User FOREIGN KEY (D_ID) REFERENCES [AdvellaDW].[edw].[DimDate] (D_ID);
ALTER TABLE [AdvellaDW].[edw].[Fact_User] ADD CONSTRAINT FK_T_ID_Fact_User FOREIGN KEY (T_ID) REFERENCES [AdvellaDW].[edw].[DimTime] (T_ID);

--adding foreign surrogate keys in [Fact_Task_Service]
ALTER TABLE [AdvellaDW].[edw].[Fact_Task_Service] ADD CONSTRAINT FK_S_ID_Fact_Task_Service FOREIGN KEY (S_ID) REFERENCES [AdvellaDW].[edw].[Dim_Services] (S_ID);
ALTER TABLE [AdvellaDW].[edw].[Fact_Task_Service] ADD CONSTRAINT FK_CS_ID_Fact_Task_Service  FOREIGN KEY (CS_ID) REFERENCES [AdvellaDW].[edw].[Dim_Categories_Service] (CS_ID);
ALTER TABLE [AdvellaDW].[edw].[Fact_Task_Service] ADD CONSTRAINT FK_U_ID_Fact_Task_Service FOREIGN KEY (U_ID) REFERENCES [AdvellaDW].[edw].[Dim_Users] (U_ID);
ALTER TABLE [AdvellaDW].[edw].[Fact_Task_Service] ADD CONSTRAINT FK_PD_ID_Fact_Task_Service  FOREIGN KEY (PD_ID) REFERENCES [AdvellaDW].[edw].[DimDate] (D_ID);
ALTER TABLE [AdvellaDW].[edw].[Fact_Task_Service] ADD CONSTRAINT FK_DD_ID_Fact_Task_Service  FOREIGN KEY (DD_ID) REFERENCES [AdvellaDW].[edw].[DimDate] (D_ID);
ALTER TABLE [AdvellaDW].[edw].[Fact_Task_Service] ADD CONSTRAINT FK_PT_ID_Fact_Task_Service  FOREIGN KEY (PT_ID) REFERENCES [AdvellaDW].[edw].[DimTime] (T_ID);
ALTER TABLE [AdvellaDW].[edw].[Fact_Task_Service] ADD CONSTRAINT FK_DT_ID_Fact_Task_Service  FOREIGN KEY (DT_ID) REFERENCES [AdvellaDW].[edw].[DimTime] (T_ID);

--adding foreign surrogate keys in [Fact_Product]
ALTER TABLE [AdvellaDW].[edw].[Fact_Product] ADD CONSTRAINT FK_P_ID_Fact_Product FOREIGN KEY (P_ID) REFERENCES [AdvellaDW].[edw].[Dim_Products] (P_ID);
ALTER TABLE [AdvellaDW].[edw].[Fact_Product] ADD CONSTRAINT FK_CP_ID_Fact_Product   FOREIGN KEY (CP_ID) REFERENCES [AdvellaDW].[edw].[Dim_Categories_Product] (CP_ID);
ALTER TABLE [AdvellaDW].[edw].[Fact_Product] ADD CONSTRAINT FK_U_ID_Fact_Product FOREIGN KEY (U_ID) REFERENCES [AdvellaDW].[edw].[Dim_Users] (U_ID);
ALTER TABLE [AdvellaDW].[edw].[Fact_Product] ADD CONSTRAINT FK_PD_ID_Fact_Product   FOREIGN KEY (PD_ID) REFERENCES [AdvellaDW].[edw].[DimDate] (D_ID);
ALTER TABLE [AdvellaDW].[edw].[Fact_Product] ADD CONSTRAINT FK_DD_ID_Fact_Product   FOREIGN KEY (DD_ID) REFERENCES [AdvellaDW].[edw].[DimDate] (D_ID);
ALTER TABLE [AdvellaDW].[edw].[Fact_Product] ADD CONSTRAINT FK_PT_ID_Fact_Product   FOREIGN KEY (PT_ID) REFERENCES [AdvellaDW].[edw].[DimTime] (T_ID);
ALTER TABLE [AdvellaDW].[edw].[Fact_Product] ADD CONSTRAINT FK_DT_ID_Fact_Product   FOREIGN KEY (DT_ID) REFERENCES [AdvellaDW].[edw].[DimTime] (T_ID);

--adding foreign surrogate keys in [Fact_Service_Reporting]
ALTER TABLE [AdvellaDW].[edw].[Fact_Service_Reporting] ADD CONSTRAINT FK_S_ID_Fact_Service_Reporting  FOREIGN KEY (S_ID) REFERENCES [AdvellaDW].[edw].[Dim_Services] (S_ID);
ALTER TABLE [AdvellaDW].[edw].[Fact_Service_Reporting] ADD CONSTRAINT FK_RS_ID_Fact_Service_Reporting FOREIGN KEY (RS_ID) REFERENCES [AdvellaDW].[edw].[Dim_Reported_Services] (RS_ID);
ALTER TABLE [AdvellaDW].[edw].[Fact_Service_Reporting] ADD CONSTRAINT FK_CR_ID_Fact_Service_Reporting FOREIGN KEY (CR_ID) REFERENCES [AdvellaDW].[edw].[Dim_Categories_Report] (CR_ID);
ALTER TABLE [AdvellaDW].[edw].[Fact_Service_Reporting] ADD CONSTRAINT FK_U_ID_Fact_Service_Reporting FOREIGN KEY (U_ID) REFERENCES [AdvellaDW].[edw].[Dim_Users] (U_ID);
ALTER TABLE [AdvellaDW].[edw].[Fact_Service_Reporting] ADD CONSTRAINT FK_D_ID_Fact_Service_Reporting FOREIGN KEY (D_ID) REFERENCES [AdvellaDW].[edw].[DimDate] (D_ID);
ALTER TABLE [AdvellaDW].[edw].[Fact_Service_Reporting] ADD CONSTRAINT FK_T_ID_Fact_Service_Reporting FOREIGN KEY (T_ID) REFERENCES [AdvellaDW].[edw].[DimTime] (T_ID);

--adding foreign surrogate keys in [Fact_Product_Reporting]
ALTER TABLE [AdvellaDW].[edw].[Fact_Product_Reporting] ADD CONSTRAINT FK_P_ID_Fact_Product_Reporting  FOREIGN KEY (P_ID) REFERENCES [AdvellaDW].[edw].[Dim_Products] (P_ID);
ALTER TABLE [AdvellaDW].[edw].[Fact_Product_Reporting] ADD CONSTRAINT FK_RP_ID_Fact_Product_Reporting FOREIGN KEY (RP_ID) REFERENCES [AdvellaDW].[edw].[Dim_Reported_Products] (RP_ID);
ALTER TABLE [AdvellaDW].[edw].[Fact_Product_Reporting] ADD CONSTRAINT FK_CR_ID_Fact_Product_Reporting FOREIGN KEY (CR_ID) REFERENCES [AdvellaDW].[edw].[Dim_Categories_Report] (CR_ID);
ALTER TABLE [AdvellaDW].[edw].[Fact_Product_Reporting] ADD CONSTRAINT FK_U_ID_Fact_Product_Reporting FOREIGN KEY (U_ID) REFERENCES [AdvellaDW].[edw].[Dim_Users] (U_ID);
ALTER TABLE [AdvellaDW].[edw].[Fact_Product_Reporting] ADD CONSTRAINT FK_D_ID_Fact_Product_Reporting FOREIGN KEY (D_ID) REFERENCES [AdvellaDW].[edw].[DimDate] (D_ID);
ALTER TABLE [AdvellaDW].[edw].[Fact_Product_Reporting] ADD CONSTRAINT FK_T_ID_Fact_Product_Reporting FOREIGN KEY (T_ID) REFERENCES [AdvellaDW].[edw].[DimTime] (T_ID);



--inserting into dimension tables
INSERT INTO [AdvellaDW].[edw].[Dim_Users](
	[users_id], [email], [user_password], [username], [user_description]) 
SELECT [users_id], [email], [user_password], [username], [user_description]
FROM [AdvellaDW].[stage].[Dim_Users]


INSERT INTO [AdvellaDW].[edw].[Dim_Services](
	[service_id], [service_title], [service_detail]) 
SELECT [service_id], [service_title], [service_detail]
FROM [AdvellaDW].[stage].[Dim_Services]


INSERT INTO [AdvellaDW].[edw].[Dim_Products](
	[product_id], [product_title], [product_detail]) 
SELECT [product_id], [product_title], [product_detail]
FROM [AdvellaDW].[stage].[Dim_Products]


INSERT INTO [AdvellaDW].[edw].[Dim_Categories_Service](
	[category_id], [category_title]) 
SELECT [category_id], [category_title]
FROM [AdvellaDW].[stage].[Dim_Categories_Service]


INSERT INTO [AdvellaDW].[edw].[Dim_Categories_Product](
	[category_id], [category_title]) 
SELECT [category_id], [category_title]
FROM [AdvellaDW].[stage].[Dim_Categories_Product]


INSERT INTO [AdvellaDW].[edw].[Dim_Reported_Services](
	[reported_service_id], [reason]) 
SELECT [reported_service_id], [reason]
FROM [AdvellaDW].[stage].[Dim_Reported_Services]


INSERT INTO [AdvellaDW].[edw].[Dim_Reported_Products](
	[reported_product_id], [reason]) 
SELECT [reported_product_id], [reason]
FROM [AdvellaDW].[stage].[Dim_Reported_Products]


INSERT INTO [AdvellaDW].[edw].[Dim_Categories_Report](
	[category_id], [category_title]) 
SELECT [category_id], [category_title]
FROM [AdvellaDW].[stage].[Dim_Categories_Report]




--inserting into fact table
INSERT INTO [AdvellaDW].[edw].[Fact_User](
	[U_ID], [D_ID], [T_ID], [fact_user_id], [location], [rating])
SELECT u.[U_ID], d.[D_ID], t.[T_ID], f.[fact_user_id], f.[location], f.[rating]
FROM [AdvellaDW].[stage].[Fact_User] f
INNER JOIN [AdvellaDW].[edw].[Dim_Users] as u on u.users_id = f.users_id
INNER JOIN [AdvellaDW].[edw].[DimDate] as d on d.Date = (SELECT CONVERT(VARCHAR(10),f.registration_datetime,111))
inner join [AdvellaDW].[edw].[DimTime] as t on t.Time = (SELECT CONVERT(VARCHAR(8), f.registration_datetime,108))


INSERT INTO [AdvellaDW].[edw].[Fact_Task_Service](
	[S_ID], [CS_ID], [U_ID], [PD_ID], [DD_ID], [PT_ID], [DT_ID], [fact_service_id], [money_amount], [location], [number_of_bids], [status])
SELECT s.[S_ID], cs.[CS_ID], u.[U_ID], pd.[D_ID], dd.[D_ID], pt.[T_ID], dt.[T_ID], f.[fact_service_id], f.[money_amount], f.[location], f.[number_of_bids], f.[status]
FROM [AdvellaDW].[stage].[Fact_Task_Service] f
INNER JOIN [AdvellaDW].[edw].[Dim_Services] as s on s.service_id= f.service_id
INNER JOIN [AdvellaDW].[edw].[Dim_Categories_Service] as cs on cs.category_id = f.category_id
INNER JOIN [AdvellaDW].[edw].[Dim_Users] as u on u.users_id = f.users_id
INNER JOIN [AdvellaDW].[edw].[DimDate] as pd on pd.Date = (SELECT CONVERT(VARCHAR(10),f.posted_datetime,111))
INNER JOIN [AdvellaDW].[edw].[DimDate] as dd on dd.Date = (SELECT CONVERT(VARCHAR(10),f.deadline,111))
inner join [AdvellaDW].[edw].[DimTime] as pt on pt.Time = (SELECT CONVERT(VARCHAR(8), f.posted_datetime,108))
inner join [AdvellaDW].[edw].[DimTime] as dt on dt.Time = (SELECT CONVERT(VARCHAR(8), f.deadline,108))


INSERT INTO [AdvellaDW].[edw].[Fact_Product](
	[P_ID], [CP_ID], [U_ID], [PD_ID], [DD_ID], [PT_ID], [DT_ID], [fact_product_id], [money_amount], [location], [number_of_bids], [status])
SELECT p.[P_ID], cp.[CP_ID], u.[U_ID], pd.[D_ID], dd.[D_ID], pt.[T_ID], dt.[T_ID], f.[fact_product_id], f.[money_amount], f.[location], f.[number_of_bids], f.[status]
FROM [AdvellaDW].[stage].[Fact_Product] f
INNER JOIN [AdvellaDW].[edw].[Dim_Products] as p on p.product_id= f.product_id
INNER JOIN [AdvellaDW].[edw].[Dim_Categories_Product] as cp on cp.category_id = f.category_id
INNER JOIN [AdvellaDW].[edw].[Dim_Users] as u on u.users_id = f.users_id
INNER JOIN [AdvellaDW].[edw].[DimDate] as pd on pd.Date = (SELECT CONVERT(VARCHAR(10),f.posted_datetime,111))
INNER JOIN [AdvellaDW].[edw].[DimDate] as dd on dd.Date = (SELECT CONVERT(VARCHAR(10),f.deadline,111))
inner join [AdvellaDW].[edw].[DimTime] as pt on pt.Time = (SELECT CONVERT(VARCHAR(8), f.posted_datetime,108))
inner join [AdvellaDW].[edw].[DimTime] as dt on dt.Time = (SELECT CONVERT(VARCHAR(8), f.deadline,108))


INSERT INTO [AdvellaDW].[edw].[Fact_Service_Reporting](
	[S_ID], [RS_ID], [CR_ID], [U_ID], [D_ID], [T_ID], [fact_service_reporting_id])
SELECT s.[S_ID], rs.[RS_ID], cr.[CR_ID], u.[U_ID], d.[D_ID], t.[T_ID], f.[fact_service_reporting_id]
FROM [AdvellaDW].[stage].[Fact_Service_Reporting] f
INNER JOIN [AdvellaDW].[edw].[Dim_Services] as s on s.service_id= f.service_id
INNER JOIN [AdvellaDW].[edw].[Dim_Reported_Services] as rs on rs.reported_service_id = f.reported_service_id
INNER JOIN [AdvellaDW].[edw].[Dim_Categories_Report] as cr on cr.category_id = f.category_id
INNER JOIN [AdvellaDW].[edw].[Dim_Users] as u on u.users_id = f.users_id
INNER JOIN [AdvellaDW].[edw].[DimDate] as d on d.Date = (SELECT CONVERT(VARCHAR(10),f.reported_datetime,111))
inner join [AdvellaDW].[edw].[DimTime] as t on t.Time = (SELECT CONVERT(VARCHAR(8), f.reported_datetime,108))


INSERT INTO [AdvellaDW].[edw].[Fact_Product_Reporting](
	[P_ID], [RP_ID], [CR_ID], [U_ID], [D_ID], [T_ID], [fact_product_reporting_id])
SELECT p.[P_ID], rp.[RP_ID], cr.[CR_ID], u.[U_ID], d.[D_ID], t.[T_ID], f.[fact_product_reporting_id]
FROM [AdvellaDW].[stage].[Fact_Product_Reporting] f
INNER JOIN [AdvellaDW].[edw].[Dim_Products] as p on p.product_id = f.product_id
INNER JOIN [AdvellaDW].[edw].[Dim_Reported_Products] as rp on rp.reported_product_id = f.reported_product_id
INNER JOIN [AdvellaDW].[edw].[Dim_Categories_Report] as cr on cr.category_id = f.category_id
INNER JOIN [AdvellaDW].[edw].[Dim_Users] as u on u.users_id = f.users_id
INNER JOIN [AdvellaDW].[edw].[DimDate] as d on d.Date = (SELECT CONVERT(VARCHAR(10),f.reported_datetime,111))
inner join [AdvellaDW].[edw].[DimTime] as t on t.Time = (SELECT CONVERT(VARCHAR(8), f.reported_datetime,108))