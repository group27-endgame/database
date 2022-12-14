---------Service----------
--average money amount
SELECT AVG(service_money_amount) as MoneyAmountSource
FROM [Advella].[dbo].[Task_Services]

SELECT AVG(money_amount) as MoneyAmountEDW
FROM [AdvellaDW].[edw].[Fact_Task_Service]

--sum of all bidders
SELECT SUM(service_number_of_bids) as SumNumberOfBidsSource
FROM [Advella].[dbo].[Task_Services]

SELECT SUM(number_of_bids) as SumNumberOfBidsEDW
FROM [AdvellaDW].[edw].[Fact_Task_Service]


---------Product----------
--average money amount
SELECT AVG(product_money_amount) as MoneyAmountSource
FROM [Advella].[dbo].[Products]

SELECT AVG(money_amount) as MoneyAmountEDW
FROM [AdvellaDW].[edw].[Fact_Product]

--sum of all bidders
SELECT SUM(product_number_of_bids) as SumNumberOfBidsSource
FROM [Advella].[dbo].[Products]

SELECT SUM(number_of_bids) as SumNumberOfBidsEDW
FROM [AdvellaDW].[edw].[Fact_Product]