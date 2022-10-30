

/*
drop table [AdvellaDW].[edw].[Dim_Users];
drop table [AdvellaDW].[edw].[Dim_Services];
drop table [AdvellaDW].[edw].[Dim_Products];
drop table [AdvellaDW].[edw].[Dim_Categories_Service];
drop table [AdvellaDW].[edw].[Dim_Categories_Product];
drop table [AdvellaDW].[edw].[Dim_Reported_Services];
drop table [AdvellaDW].[edw].[Dim_Reported_Products];
drop table [AdvellaDW].[edw].[Dim_Categories_Report];

drop table [AdvellaDW].[edw].[Fact_User];
drop table [AdvellaDW].[edw].[Fact_Task_Service];
drop table [AdvellaDW].[edw].[Fact_Product];
drop table [AdvellaDW].[edw].[Fact_Service_Reporting];
drop table [AdvellaDW].[edw].[Fact_Product_Reporting];
*/


-- DIMENSION TABLES

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AdvellaDW].[edw].[Dim_Users]') AND type in (N'U'))

CREATE TABLE [AdvellaDW].[edw].[Dim_Users] (
	U_ID INT IDENTITY PRIMARY KEY,
	users_id INT,
	email NCHAR VARYING(100),
	user_password NCHAR VARYING(100),
	username NCHAR VARYING(100),
	user_description NCHAR VARYING(200)
);


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AdvellaDW].[edw].[Dim_Services]') AND type in (N'U'))

CREATE TABLE [AdvellaDW].[edw].[Dim_Services] (
	S_ID INT IDENTITY PRIMARY KEY,
	service_id INT,
	service_title NCHAR VARYING(100),
	service_detail NCHAR VARYING(200)
);


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AdvellaDW].[edw].[Dim_Products]') AND type in (N'U'))

CREATE TABLE [AdvellaDW].[edw].[Dim_Products] (
	P_ID INT IDENTITY PRIMARY KEY,
	product_id INT,
	product_title NCHAR VARYING(100),
	product_detail NCHAR VARYING(200)
);


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AdvellaDW].[edw].[Dim_Categories_Service]') AND type in (N'U'))

CREATE TABLE [AdvellaDW].[edw].[Dim_Categories_Service] (
	CS_ID INT IDENTITY PRIMARY KEY,
	category_id INT,
	category_title NCHAR VARYING(100)
);


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AdvellaDW].[edw].[Dim_Categories_Product]') AND type in (N'U'))

CREATE TABLE [AdvellaDW].[edw].[Dim_Categories_Product] (
	CP_ID INT IDENTITY PRIMARY KEY,
	category_id INT,
	category_title NCHAR VARYING(100)
);


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AdvellaDW].[edw].[Dim_Reported_Services]') AND type in (N'U'))

CREATE TABLE [AdvellaDW].[edw].[Dim_Reported_Services] (
	RS_ID INT IDENTITY PRIMARY KEY,
	reported_service_id INT,
	reason NCHAR VARYING(200),
);


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AdvellaDW].[edw].[Dim_Reported_Products]') AND type in (N'U'))

CREATE TABLE [AdvellaDW].[edw].[Dim_Reported_Products] (
	RP_ID INT IDENTITY PRIMARY KEY,
	reported_product_id INT,
	reason NCHAR VARYING(200),
);


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AdvellaDW].[edw].[Dim_Categories_Report]') AND type in (N'U'))

CREATE TABLE [AdvellaDW].[edw].[Dim_Categories_Report] (
	CR_ID INT IDENTITY PRIMARY KEY,
	category_id INT,
	category_title NCHAR VARYING(100)
);


--Create DimDate
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GrinHouseDW].[edw].[DimDate]') AND type in (N'U'))

CREATE TABLE [AdvellaDW].[edw].[DimDate] (
 D_ID INT NOT NULL,
 Date DATE,
 Day INT,
 Month INT,
 MonthName NCHAR VARYING(10),
 Week INT,
 Quarter INT,
 Year INT,
 DayOfWeek INT,
 WeekdayName NCHAR VARYING(10)
CONSTRAINT [PK_DimDate]  PRIMARY KEY CLUSTERED
 (
	[D_ID] ASC
 )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

/* Adding data from start of times until end of times, for 100 years */
DECLARE @StartDate DATETIME;
DECLARE @EndDate DATETIME;

SET @StartDate = 2021-01-01
SET @EndDate = DATEADD(YEAR, 100, getdate())


WHILE @StartDate <= @EndDate
BEGIN
	INSERT INTO [AdvellaDW].[edw].[DimDate]
	(
		[D_ID],
		[Date],
		[Day],
		[Month],
		[MonthName],
		[Week],
		[Quarter],
		[Year],
		[DayOfWeek],
		[WeekdayName]
	)
	SELECT
		CONVERT(CHAR(8), @StartDate, 112) as D_ID,
		@StartDate as [Date],
		DATEPART(day, @StartDate) as Day,
		DATEPART(month, @StartDate) as Month,
		DATENAME(month, @StartDate) as MonthName,
		DATEPART(week, @StartDate) as Week,
		DATEPART(QUARTER, @StartDate) as Quarter,
		DATEPART(YEAR, @StartDate) as Year,
		DATEPART(WEEKDAY, @StartDate) as DayOfWeek,
		DATENAME(weekday, @StartDate) as WeekdayName

	SET @StartDate = DATEADD(dd, 1, @StartDate)
END



--Create DimTime
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[GrinHouseDW].[edw].[DimTime]') AND type in (N'U'))

-- Then create a new table
CREATE TABLE [AdvellaDW].[edw].[DimTime](
    [T_ID] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
    [Time] [time](0) NULL,
    [Hour] [int] NULL,
    [Minute] [int] NULL,
	[Seconds] [int] NULL
);
 
-- Needed if the dimension already existed
-- with other column, otherwise the validation
-- of the insert could fail.
GO
 
-- Create a time and a counter variable for the loop
DECLARE @Time as time;
SET @Time = '0:00:00';
 
DECLARE @counter as int;
SET @counter = 0;
 
 
 
-- Loop 1440 times (24hours * 60minutes)
WHILE @counter < 86400
BEGIN

    INSERT INTO [AdvellaDW].[edw].[DimTime] ([Time]
                       , [Hour]
                       , [Minute]
					   , [Seconds])

                VALUES (@Time
                       , DATEPART(Hour, @Time) + 1
                       , DATEPART(Minute, @Time) + 1
					   , DATEPART(Second, @Time) + 1
                       );
 
    -- Raise time with one minute
    SET @Time = DATEADD(SECOND, 1, @Time);
 
    -- Raise counter by one
    set @counter = @counter + 1;
END


-- FACT TABLES

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AdvellaDW].[edw].[Fact_User]') AND type in (N'U'))

CREATE TABLE [AdvellaDW].[edw].[Fact_User] (
	U_ID INT,
	D_ID INT,
	T_ID INT,
	fact_user_id INT,
	location NCHAR VARYING(100),
	rating FLOAT
);


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AdvellaDW].[edw].[Fact_Task_Service]') AND type in (N'U'))

CREATE TABLE [AdvellaDW].[edw].[Fact_Task_Service] (
	S_ID INT,
	CS_ID INT,
	U_ID INT,
	PD_ID INT,
	DD_ID INT,
	PT_ID INT,
	DT_ID INT,
	fact_service_id INT,
	money_amount FLOAT,
	location NCHAR VARYING(100),
	number_of_bids INT,
	status NCHAR VARYING(50)
);


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AdvellaDW].[edw].[Fact_Product]') AND type in (N'U'))

CREATE TABLE [AdvellaDW].[edw].[Fact_Product] (
	P_ID INT,
	CP_ID INT,
	U_ID INT,
	PD_ID INT,
	DD_ID INT,
	PT_ID INT,
	DT_ID INT,
	fact_product_id INT,
	money_amount FLOAT,
	location NCHAR VARYING(100),
	number_of_bids INT,
	status NCHAR VARYING(50)
);


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AdvellaDW].[edw].[Fact_Service_Reporting]') AND type in (N'U'))

CREATE TABLE [AdvellaDW].[edw].[Fact_Service_Reporting] (
	S_ID INT,
	RS_ID INT,
	CR_ID INT,
	U_ID INT,
	D_ID INT,
	T_ID INT,
	fact_service_reporting_id INT
);


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[AdvellaDW].[edw].[Fact_Product_Reporting]') AND type in (N'U'))

CREATE TABLE [AdvellaDW].[edw].[Fact_Product_Reporting] (
	P_ID INT,
	RP_ID INT,
	CR_ID INT,
	U_ID INT,
	D_ID INT,
	T_ID INT,
	fact_product_reporting_id INT
);


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

/*
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
alter table [AdvellaDW].[edw].[Fact_Product_Reporting] drop constraint FK_T_ID_Fact_Product_Reporting;
*/