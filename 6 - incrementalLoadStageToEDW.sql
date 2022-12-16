/*Creating the etl schema to store our log table in*/
Create schema etl

CREATE TABLE etl.[LogUpdate](
	[Table] [nvarchar](50) NULL,
	[LastLoadDate] int NULL
) ON [PRIMARY]
GO

/*Populating log update table with table names and dates*/

INSERT INTO [etl].[LogUpdate] ([Table],[LastLoadDate]) VALUES ('Dim_Users',20221201)
INSERT INTO [etl].[LogUpdate] ([Table],[LastLoadDate]) VALUES ('Dim_Services',20221201)
INSERT INTO [etl].[LogUpdate] ([Table],[LastLoadDate]) VALUES ('Dim_Products',20221201)
INSERT INTO [etl].[LogUpdate] ([Table],[LastLoadDate]) VALUES ('Dim_Categories_Service',20221201)
INSERT INTO [etl].[LogUpdate] ([Table],[LastLoadDate]) VALUES ('Dim_Categories_Product',20221201)
INSERT INTO [etl].[LogUpdate] ([Table],[LastLoadDate]) VALUES ('Fact_User',20221201)
INSERT INTO [etl].[LogUpdate] ([Table],[LastLoadDate]) VALUES ('Fact_Task_Service',20221201)
INSERT INTO [etl].[LogUpdate] ([Table],[LastLoadDate]) VALUES ('Fact_Product',20221201)

/*Adding validTo and from to dimensions*/
alter table [AdvellaDW].[edw].[Dim_Users] add ValidFrom int, ValidTo int;
alter table [AdvellaDW].[edw].[Dim_Services] add ValidFrom int, ValidTo int;
alter table [AdvellaDW].[edw].[Dim_Products] add ValidFrom int, ValidTo int;
alter table [AdvellaDW].[edw].[Dim_Categories_Service] add ValidFrom int, ValidTo int;
alter table [AdvellaDW].[edw].[Dim_Categories_Product] add ValidFrom int, ValidTo int;

/*Updating values in tables*/
update [AdvellaDW].[edw].[Dim_Users] set ValidFrom = 20221201, ValidTo = 99990101;
update [AdvellaDW].[edw].[Dim_Services] set ValidFrom = 20221201, ValidTo = 99990101;
update [AdvellaDW].[edw].[Dim_Products] set ValidFrom = 20221201, ValidTo = 99990101;
update [AdvellaDW].[edw].[Dim_Categories_Service] set ValidFrom = 20221201, ValidTo = 99990101;
update [AdvellaDW].[edw].[Dim_Categories_Product] set ValidFrom = 20221201, ValidTo = 99990101;



----------Dim_Users----------

  /*Include these with each  dim_users dbo > stage*/
declare @LastLoadDateDimUsers int set @LastLoadDateDimUsers = (select MAX([LastLoadDate]) from [etl].[LogUpdate] where [Table] = 'Dim_Users')
declare @NewLoadDateDimUsers int set @NewLoadDateDimUsers = CONVERT(CHAR(8), GETDATE(), 112)
declare @FutureDateDimUsers int set @FutureDateDimUsers = 99990101

/*INSERTING dim_users dbo > stage*/

  SELECT [users_id], 
  [email], 
  [user_password], 
  [username], 
  [user_description] --Select all the records from the dbo production databas
  INTO #tmp -- All the selected records (except those that are already in stage and new records in stage) are inserted into tmp
  FROM [AdvellaDW].[stage].[Dim_Users]
  EXCEPT SELECT [users_id], 
  [email], 
  [user_password], 
  [username], 
  [user_description]
  FROM [AdvellaDW].[edw].[Dim_Users]

  INSERT INTO [AdvellaDW].[edw].[Dim_Users]( -- Here is where we start inserting all the records from tmp into stage
  [users_id], 
  [email], 
  [user_password], 
  [username], 
  [user_description],
  [ValidFrom],
  [ValidTo])
  SELECT  [users_id], 
  [email], 
  [user_password], 
  [username], 
  [user_description],
  @NewLoadDateDimUsers,
  @FutureDateDimUsers
  from #tmp

INSERT INTO [etl].[LogUpdate] ([Table], [LastLoadDate]) VALUES ('Dim_Users', @NewLoadDateDimUsers) -- We create a log in the LogUpdate table

drop table if exists #tmp -- we must make sure to drop the tmp table at the end
  
/*End of INSERTING Dim_Users dbo > stage*/

/*UPDATING dim_users dbo > stage*/
    SELECT [users_id], --Select all the records from the dbo production database
    [email], 
    [user_password], 
    [username], 
    [user_description]
	 INTO #tmp -- All the selected records (except those that are already in stage and new records in stage) are inserted into tmp
	 FROM [AdvellaDW].[stage].[Dim_Users]
	 EXCEPT SELECT [users_id],  --Except those which are already in stage
	[email], 
    [user_password], 
    [username], 
    [user_description]
	 FROM [AdvellaDW].[edw].[Dim_Users]
	 EXCEPT SELECT [users_id],  --Except new records
	[email], 
    [user_password], 
    [username], 
    [user_description]
    from [AdvellaDW].[stage].[Dim_Users]
	WHERE users_id in (SELECT [users_id] FROM [AdvellaDW].[stage].[Dim_Users] EXCEPT SELECT [users_id] FROM [AdvellaDW].[edw].[Dim_Users] WHERE [ValidTo] = 99990101)

	UPDATE [AdvellaDW].[edw].[Dim_Users]
	SET [users_id] = t.users_id,
	[ValidTo] = @FutureDateDimUsers
	FROM #tmp t
	WHERE [AdvellaDW].[edw].[Dim_Users].[users_id] = t.users_id AND [AdvellaDW].[edw].[Dim_Users].[ValidTo] = 99990101
	

	INSERT INTO [etl].[LogUpdate] ([Table], [LastLoadDate]) VALUES ('Dim_Users', @NewLoadDateDimUsers) -- We create a log in the LogUpdate table

	drop table if exists #tmp -- we must make sure to drop the tmp table at the end

/*End of UPDATING Dim_Users dbo > stage*/

/*DELETING Dim_Users dbo > stage*/

UPDATE [AdvellaDW].[edw].[Dim_Users]
SET ValidTo = @NewLoadDateDimUsers-1
WHERE [users_id] in (
SELECT [users_id]
FROM [AdvellaDW].[edw].[Dim_Users]
WHERE [users_id] IN (
SELECT [users_id] FROM [AdvellaDW].[edw].[Dim_Users]
EXCEPT SELECT [users_id] from [AdvellaDW].[stage].[Dim_Users]))

INSERT INTO [etl].[LogUpdate] ([Table], [LastLoadDate]) VALUES ('Dim_Users', @NewLoadDateDimUsers)

/*End of DELETING Dim_Users dbo > stage*/


----------END Dim_Users----------


----------Dim_Services----------

  /*Include these with each  dim_services dbo > stage*/
declare @LastLoadDateDimServices int set @LastLoadDateDimServices = (select MAX([LastLoadDate]) from [etl].[LogUpdate] where [Table] = 'Dim_Services')
declare @NewLoadDateDimServices int set @NewLoadDateDimServices = CONVERT(CHAR(8), GETDATE(), 112)
declare @FutureDateDimServices int set @FutureDateDimServices = 99990101

/*INSERTING dim_services dbo > stage*/

  SELECT [service_id], [service_title], [service_detail] --Select all the records from the dbo production databas
  INTO #tmp -- All the selected records (except those that are already in stage and new records in stage) are inserted into tmp
  FROM [AdvellaDW].[stage].[Dim_Services]
  EXCEPT SELECT [service_id], [service_title], [service_detail]
  FROM [AdvellaDW].[edw].[Dim_Services]



  INSERT INTO [AdvellaDW].[edw].[Dim_Services]( -- Here is where we start inserting all the records from tmp into stage
  [service_id], [service_title], [service_detail],
  [ValidFrom],
  [ValidTo])
  SELECT  [service_id], [service_title], [service_detail],
  @NewLoadDateDimServices,
  @FutureDateDimServices
  from #tmp

INSERT INTO [etl].[LogUpdate] ([Table], [LastLoadDate]) VALUES ('Dim_Services', @NewLoadDateDimServices) -- We create a log in the LogUpdate table

drop table if exists #tmp -- we must make sure to drop the tmp table at the end
  
/*End of INSERTING Dim_Services dbo > stage*/

/*UPDATING Dim_Services dbo > stage*/
    SELECT [service_id], [service_title], [service_detail] --Select all the records from the dbo production database
	 INTO #tmp -- All the selected records (except those that are already in stage and new records in stage) are inserted into tmp
	 FROM [AdvellaDW].[stage].[Dim_Services]
	 EXCEPT SELECT [service_id], [service_title], [service_detail]  --Except those which are already in stage
	 FROM [AdvellaDW].[edw].[Dim_Services]
	 EXCEPT SELECT [service_id], [service_title], [service_detail]  --Except new records
    from [AdvellaDW].[stage].[Dim_Services]
	WHERE service_id in (SELECT [service_id] FROM [AdvellaDW].[stage].[Dim_Services] EXCEPT SELECT [service_id] FROM [AdvellaDW].[edw].[Dim_Services] WHERE [ValidTo] = 99990101)

	UPDATE [AdvellaDW].[edw].[Dim_Services]
	SET [service_id] = t.service_id,
	[ValidTo] = @FutureDateDimServices
	FROM #tmp t
	WHERE [AdvellaDW].[edw].[Dim_Services].[service_id] = t.service_id AND [AdvellaDW].[edw].[Dim_Services].[ValidTo] = 99990101
	

	INSERT INTO [etl].[LogUpdate] ([Table], [LastLoadDate]) VALUES ('Dim_Services', @NewLoadDateDimServices) -- We create a log in the LogUpdate table

	drop table if exists #tmp -- we must make sure to drop the tmp table at the end

/*End of UPDATING Dim_Services dbo > stage*/

/*DELETING Dim_Services dbo > stage*/

UPDATE [AdvellaDW].[edw].[Dim_Services]
SET ValidTo = @NewLoadDateDimServices-1
WHERE [service_id] in (
SELECT [service_id]
FROM [AdvellaDW].[edw].[Dim_Services]
WHERE [service_id] IN (
SELECT [service_id] FROM [AdvellaDW].[edw].[Dim_Services]
EXCEPT SELECT [service_id] from [AdvellaDW].[stage].[Dim_Services]))

INSERT INTO [etl].[LogUpdate] ([Table], [LastLoadDate]) VALUES ('Dim_Services', @NewLoadDateDimServices)

/*End of DELETING Dim_Services dbo > stage*/

----------END DIM_SERVICES----------


----------Dim_Products----------

  /*Include these with each  dim_users dbo > stage*/
declare @LastLoadDateDimProducts int set @LastLoadDateDimProducts = (select MAX([LastLoadDate]) from [etl].[LogUpdate] where [Table] = 'Dim_Products')
declare @NewLoadDateDimProducts int set @NewLoadDateDimProducts = CONVERT(CHAR(8), GETDATE(), 112)
declare @FutureDateDimProducts int set @FutureDateDimProducts = 99990101

/*INSERTING dim_services dbo > stage*/

  SELECT [product_id], [product_title], [product_detail] --Select all the records from the dbo production databas
  INTO #tmp -- All the selected records (except those that are already in stage and new records in stage) are inserted into tmp
  FROM [AdvellaDW].[stage].[Dim_Products]
  EXCEPT SELECT [product_id], [product_title], [product_detail]
  FROM [AdvellaDW].[edw].[Dim_Products]



  INSERT INTO [AdvellaDW].[edw].[Dim_Products]( -- Here is where we start inserting all the records from tmp into stage
  [product_id], [product_title], [product_detail],
  [ValidFrom],
  [ValidTo])
  SELECT  [product_id], [product_title], [product_detail],
  @NewLoadDateDimProducts,
  @FutureDateDimProducts
  from #tmp

INSERT INTO [etl].[LogUpdate] ([Table], [LastLoadDate]) VALUES ('Dim_Products', @NewLoadDateDimProducts) -- We create a log in the LogUpdate table

drop table if exists #tmp -- we must make sure to drop the tmp table at the end
  
/*End of INSERTING Dim_Products dbo > stage*/

/*UPDATING Dim_Products dbo > stage*/
    SELECT [product_id], [product_title], [product_detail] --Select all the records from the dbo production database
	 INTO #tmp -- All the selected records (except those that are already in stage and new records in stage) are inserted into tmp
	 FROM [AdvellaDW].[stage].[Dim_Products]
	 EXCEPT SELECT [product_id], [product_title], [product_detail]  --Except those which are already in stage
	 FROM [AdvellaDW].[edw].[Dim_Products]
	 EXCEPT SELECT [product_id], [product_title], [product_detail]  --Except new records
    from [AdvellaDW].[stage].[Dim_Products]
	WHERE product_id in (SELECT [product_id] FROM [AdvellaDW].[stage].[Dim_Products] EXCEPT SELECT [product_id] FROM [AdvellaDW].[edw].[Dim_Products] WHERE [ValidTo] = 99990101)

	UPDATE [AdvellaDW].[edw].[Dim_Products]
	SET [product_id] = t.product_id,
	[ValidTo] = @FutureDateDimProducts
	FROM #tmp t
	WHERE [AdvellaDW].[edw].[Dim_Products].[product_id] = t.product_id AND [AdvellaDW].[edw].[Dim_Products].[ValidTo] = 99990101
	

	INSERT INTO [etl].[LogUpdate] ([Table], [LastLoadDate]) VALUES ('Dim_Products', @NewLoadDateDimProducts) -- We create a log in the LogUpdate table

	drop table if exists #tmp -- we must make sure to drop the tmp table at the end

/*End of UPDATING Dim_Products dbo > stage*/

/*DELETING Dim_Products dbo > stage*/

UPDATE [AdvellaDW].[edw].[Dim_Products]
SET ValidTo = @NewLoadDateDimProducts-1
WHERE [product_id] in (
SELECT [product_id]
FROM [AdvellaDW].[edw].[Dim_Products]
WHERE [product_id] IN (
SELECT [product_id] FROM [AdvellaDW].[edw].[Dim_Products]
EXCEPT SELECT [product_id] from [AdvellaDW].[stage].[Dim_Products]))

INSERT INTO [etl].[LogUpdate] ([Table], [LastLoadDate]) VALUES ('Dim_Products', @NewLoadDateDimProducts)

/*End of DELETING Dim_Products dbo > stage*/

----------END Dim_Products----------


----------Dim_Categories_Service----------

  /*Include these with each  dim_users dbo > stage*/
declare @LastLoadDateDimCategoriesService int set @LastLoadDateDimCategoriesService = (select MAX([LastLoadDate]) from [etl].[LogUpdate] where [Table] = 'Dim_Categories_Service')
declare @NewLoadDateDimCategoriesService int set @NewLoadDateDimCategoriesService = CONVERT(CHAR(8), GETDATE(), 112)
declare @FutureDateDimCategoriesService int set @FutureDateDimCategoriesService = 99990101

/*INSERTING dim_services dbo > stage*/

  SELECT [category_id], [category_title] --Select all the records from the dbo production databas
  INTO #tmp -- All the selected records (except those that are already in stage and new records in stage) are inserted into tmp
  FROM [AdvellaDW].[stage].[Dim_Categories_Service]
  EXCEPT SELECT [category_id], [category_title]
  FROM [AdvellaDW].[edw].[Dim_Categories_Service]



  INSERT INTO [AdvellaDW].[edw].[Dim_Categories_Service]( -- Here is where we start inserting all the records from tmp into stage
  [category_id], [category_title],
  [ValidFrom],
  [ValidTo])
  SELECT  [category_id], [category_title],
  @NewLoadDateDimCategoriesService,
  @FutureDateDimCategoriesService
  from #tmp

INSERT INTO [etl].[LogUpdate] ([Table], [LastLoadDate]) VALUES ('Dim_Categories_Service', @NewLoadDateDimCategoriesService) -- We create a log in the LogUpdate table

drop table if exists #tmp -- we must make sure to drop the tmp table at the end
  
/*End of INSERTING Dim_Categories_Service dbo > stage*/

/*UPDATING Dim_Categories_Service dbo > stage*/
    SELECT [category_id], [category_title] --Select all the records from the dbo production database
	 INTO #tmp -- All the selected records (except those that are already in stage and new records in stage) are inserted into tmp
	 FROM [AdvellaDW].[stage].[Dim_Categories_Service]
	 EXCEPT SELECT [category_id], [category_title]  --Except those which are already in stage
	 FROM [AdvellaDW].[edw].[Dim_Categories_Service]
	 EXCEPT SELECT [category_id], [category_title]  --Except new records
    from [AdvellaDW].[stage].[Dim_Categories_Service]
	WHERE category_id in (SELECT [category_id] FROM [AdvellaDW].[stage].[Dim_Categories_Service] EXCEPT SELECT [category_id] FROM [AdvellaDW].[edw].[Dim_Categories_Service] WHERE [ValidTo] = 99990101)

	UPDATE [AdvellaDW].[edw].[Dim_Categories_Service]
	SET [category_id] = t.category_id,
	[ValidTo] = @FutureDateDimCategoriesService
	FROM #tmp t
	WHERE [AdvellaDW].[edw].[Dim_Categories_Service].[category_id] = t.category_id AND [AdvellaDW].[edw].[Dim_Categories_Service].[ValidTo] = 99990101
	

	INSERT INTO [etl].[LogUpdate] ([Table], [LastLoadDate]) VALUES ('Dim_Categories_Service', @NewLoadDateDimCategoriesService) -- We create a log in the LogUpdate table

	drop table if exists #tmp -- we must make sure to drop the tmp table at the end

/*End of UPDATING Dim_Categories_Service dbo > stage*/

/*DELETING Dim_Categories_Service dbo > stage*/

UPDATE [AdvellaDW].[edw].[Dim_Categories_Service]
SET ValidTo = @NewLoadDateDimCategoriesService-1
WHERE [category_id] in (
SELECT [category_id]
FROM [AdvellaDW].[edw].[Dim_Categories_Service]
WHERE [category_id] IN (
SELECT [category_id] FROM [AdvellaDW].[edw].[Dim_Categories_Service]
EXCEPT SELECT [category_id] from [AdvellaDW].[stage].[Dim_Categories_Service]))

INSERT INTO [etl].[LogUpdate] ([Table], [LastLoadDate]) VALUES ('Dim_Categories_Service', @NewLoadDateDimCategoriesService)

/*End of DELETING Dim_Categories_Service dbo > stage*/

----------END Dim_Categories_Service----------


----------Dim_Categories_Product----------

  /*Include these with each  dim_users dbo > stage*/
declare @LastLoadDateDimCategoriesProduct int set @LastLoadDateDimCategoriesProduct = (select MAX([LastLoadDate]) from [etl].[LogUpdate] where [Table] = 'Dim_Categories_Product')
declare @NewLoadDateDimCategoriesProduct int set @NewLoadDateDimCategoriesProduct = CONVERT(CHAR(8), GETDATE(), 112)
declare @FutureDateDimCategoriesProduct int set @FutureDateDimCategoriesProduct = 99990101

/*INSERTING dim_services dbo > stage*/

  SELECT [category_id], [category_title] --Select all the records from the dbo production databas
  INTO #tmp -- All the selected records (except those that are already in stage and new records in stage) are inserted into tmp
  FROM [AdvellaDW].[stage].[Dim_Categories_Product]
  EXCEPT SELECT [category_id], [category_title]
  FROM [AdvellaDW].[edw].[Dim_Categories_Product]



  INSERT INTO [AdvellaDW].[edw].[Dim_Categories_Product]( -- Here is where we start inserting all the records from tmp into stage
  [category_id], [category_title],
  [ValidFrom],
  [ValidTo])
  SELECT  [category_id], [category_title],
  @NewLoadDateDimCategoriesProduct,
  @FutureDateDimCategoriesProduct
  from #tmp

INSERT INTO [etl].[LogUpdate] ([Table], [LastLoadDate]) VALUES ('Dim_Categories_Product', @NewLoadDateDimCategoriesProduct) -- We create a log in the LogUpdate table

drop table if exists #tmp -- we must make sure to drop the tmp table at the end
  
/*End of INSERTING Dim_Categories_Product dbo > stage*/

/*UPDATING Dim_Categories_Product dbo > stage*/
    SELECT [category_id], [category_title] --Select all the records from the dbo production database
	 INTO #tmp -- All the selected records (except those that are already in stage and new records in stage) are inserted into tmp
	 FROM [AdvellaDW].[stage].[Dim_Categories_Product]
	 EXCEPT SELECT [category_id], [category_title]  --Except those which are already in stage
	 FROM [AdvellaDW].[edw].[Dim_Categories_Product]
	 EXCEPT SELECT [category_id], [category_title]  --Except new records
    from [AdvellaDW].[stage].[Dim_Categories_Product]
	WHERE category_id in (SELECT [category_id] FROM [AdvellaDW].[stage].[Dim_Categories_Product] EXCEPT SELECT [category_id] FROM [AdvellaDW].[edw].[Dim_Categories_Product] WHERE [ValidTo] = 99990101)

	UPDATE [AdvellaDW].[edw].[Dim_Categories_Product]
	SET [category_id] = t.category_id,
	[ValidTo] = @FutureDateDimCategoriesProduct
	FROM #tmp t
	WHERE [AdvellaDW].[edw].[Dim_Categories_Product].[category_id] = t.category_id AND [AdvellaDW].[edw].[Dim_Categories_Product].[ValidTo] = 99990101
	

	INSERT INTO [etl].[LogUpdate] ([Table], [LastLoadDate]) VALUES ('Dim_Categories_Product', @NewLoadDateDimCategoriesProduct) -- We create a log in the LogUpdate table

	drop table if exists #tmp -- we must make sure to drop the tmp table at the end

/*End of UPDATING Dim_Categories_Product dbo > stage*/

/*DELETING Dim_Categories_Product dbo > stage*/

UPDATE [AdvellaDW].[edw].[Dim_Categories_Product]
SET ValidTo = @NewLoadDateDimCategoriesProduct-1
WHERE [category_id] in (
SELECT [category_id]
FROM [AdvellaDW].[edw].[Dim_Categories_Product]
WHERE [category_id] IN (
SELECT [category_id] FROM [AdvellaDW].[edw].[Dim_Categories_Product]
EXCEPT SELECT [category_id] from [AdvellaDW].[stage].[Dim_Categories_Product]))

INSERT INTO [etl].[LogUpdate] ([Table], [LastLoadDate]) VALUES ('Dim_Categories_Product', @NewLoadDateDimCategoriesProduct)

/*End of DELETING Dim_Categories_Product dbo > stage*/

----------END Dim_Categories_Product----------


----------STAGING FACTS----------

/*Staging facts*/

--FACT_USER--
declare @LastLoadDateFactUser int set @LastLoadDateFactUser = (select MAX([LastLoadDate]) from [etl].[LogUpdate] where [Table] = 'Fact_User')
declare @NewLoadDateFactUser int set @NewLoadDateFactUser = (CONVERT(CHAR(8), GETDATE(), 112))
declare @FutureDateFactUser int set @FutureDateFactUser = 99990101

TRUNCATE TABLE [AdvellaDW].[stage].[Fact_User]

INSERT INTO [AdvellaDW].[edw].[Fact_User] ([U_ID], [D_ID], [T_ID], [fact_user_id], [location], [rating])
SELECT u.[U_ID], d.[D_ID], t.[T_ID], f.[fact_user_id], f.[location], f.[rating]
 FROM [AdvellaDW].[stage].[Fact_User] f
INNER JOIN [AdvellaDW].[edw].[Dim_Users] as u on u.users_id = f.users_id
INNER JOIN [AdvellaDW].[edw].[DimDate] as d on d.Date = (SELECT CONVERT(VARCHAR(10),f.registration_datetime,111))
inner join [AdvellaDW].[edw].[DimTime] as t on t.Time = (SELECT CONVERT(VARCHAR(8), f.registration_datetime,108))
 

INSERT INTO [etl].[LogUpdate] ([Table], [LastLoadDate]) VALUES ('Fact_User', @NewLoadDateFactUser)

 drop table if exists #tmp -- we must make sure to drop the tmp table at the end

-----End of staging fact_user facts-----

--Fact_Task_Service--
declare @LastLoadDateFactTaskService int set @LastLoadDateFactTaskService = (select MAX([LastLoadDate]) from [etl].[LogUpdate] where [Table] = 'Fact_Task_Service')
declare @NewLoadDateFactTaskService int set @NewLoadDateFactTaskService = (CONVERT(CHAR(8), GETDATE(), 112))
declare @FutureDateFactTaskService int set @FutureDateFactTaskService = 99990101

TRUNCATE TABLE [AdvellaDW].[edw].[Fact_Task_Service]

INSERT INTO [AdvellaDW].[edw].[Fact_Task_Service] (
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
 

INSERT INTO [etl].[LogUpdate] ([Table], [LastLoadDate]) VALUES ('Fact_Task_Service', @NewLoadDateFactTaskService)

 drop table if exists #tmp -- we must make sure to drop the tmp table at the end

-----End of staging Fact_Task_Service facts-----

--Fact_Product--
declare @LastLoadDateFactProduct int set @LastLoadDateFactProduct = (select MAX([LastLoadDate]) from [etl].[LogUpdate] where [Table] = 'Fact_Product')
declare @NewLoadDateFactProduct int set @NewLoadDateFactProduct = (CONVERT(CHAR(8), GETDATE(), 112))
declare @FutureDateFactProduct int set @FutureDateFactProduct = 99990101

TRUNCATE TABLE [AdvellaDW].[edw].[Fact_Product]

INSERT INTO [AdvellaDW].[edw].[Fact_Product] (
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
 

INSERT INTO [etl].[LogUpdate] ([Table], [LastLoadDate]) VALUES ('Fact_Product', @NewLoadDateFactProduct)

 drop table if exists #tmp -- we must make sure to drop the tmp table at the end

-----End of staging Fact_Product facts-----

 /*End of staging facts*/
