SELECT COUNT(*) AS total_rows
FROM store_sales_data_original;

DESCRIBE store_sales_data_original;

SELECT*
FROM store_sales_data_original
LIMIT 10;


# Total Sales, Profit and Profit Margin

SELECT
	SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM store_sales_data_original;

SELECT
	ROUND(SUM(Profit)/SUM(Sales)*100,2) AS overall_profit_margin
FROM store_sales_data_original;


# Category and Subcategory Profitability

SELECT 
	`Category of Goods`,
	SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    ROUND(SUM(Profit)/SUM(Sales)*100,2) AS profit_margin
FROM store_sales_data_original
GROUP BY `Category of Goods`
ORDER BY total_profit DESC;


SELECT 
	`Category of Goods`, `Sub-Category`,
	SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    ROUND(SUM(Profit)/SUM(Sales)*100,2) AS profit_margin
FROM store_sales_data_original
GROUP BY `Category of Goods`, `Sub-Category`
ORDER BY profit_margin ASC;


# Top Sub-Category by Profit within Each Category 

SELECT `Category of Goods`, `Sub-Category`,
       SUM(Profit) AS total_profit,
       RANK() OVER (PARTITION BY `Category of Goods` ORDER BY SUM(Profit) DESC) AS profit_rank
FROM store_sales_data_original
GROUP BY `Category of Goods`, `Sub-Category`
ORDER BY `Category of Goods`, profit_rank ASC;



# High Sales but poor profit

SELECT 
	`Sub-Category`,
	SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    ROUND(SUM(Profit)/SUM(Sales)*100,2) AS profit_margin
FROM store_sales_data_original
GROUP BY `Sub-Category`
ORDER BY total_sales DESC;



# Regional Performance

SELECT 
	`Region`,
	SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    ROUND(SUM(Profit)/SUM(Sales)*100,2) AS profit_margin
FROM store_sales_data_original
GROUP BY `Region`
ORDER BY total_profit DESC;


SELECT `State`, `City Type`, `Outlet Type`,
       SUM(Sales) AS total_sales,
       SUM(Profit) AS total_profit,
       ROUND(SUM(Profit)/SUM(Sales)*100,2) AS profit_margin
FROM store_sales_data_original
GROUP BY `State`, `City Type`, `Outlet Type`
ORDER BY profit_margin DESC;



# Discount Analysis

SELECT
	CASE
		WHEN Discount = 0 THEN 'No Discount'
		WHEN Discount <= 0.25 THEN 'Low Discount'
		WHEN Discount <= 0.35 THEN 'Medium Discount'
		WHEN Discount <= 0.50 THEN 'High Discount'
        ELSE 'Check'
    END AS discount_type,
    
    COUNT(*) AS transactions,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    ROUND(SUM(Profit)/SUM(Sales)*100,2) AS profit_margin
    
FROM store_sales_data_original
GROUP BY discount_type
ORDER BY profit_margin DESC;



# Low Margin Segments

WITH category_margins AS (
    SELECT `Category of Goods`, `Sub-Category`,
           SUM(Sales) AS total_sales,
           SUM(Profit) AS total_profit,
           ROUND(SUM(Profit)/SUM(Sales)*100,2) AS profit_margin
    FROM store_sales_data_original
    GROUP BY `Category of Goods`, `Sub-Category`
)
SELECT *
FROM category_margins
WHERE profit_margin < 14.9
ORDER BY profit_margin ASC;




# Low Margin but High Discount

SELECT
	`Category of Goods`, `Sub-Category`,
	CASE
		WHEN Discount = 0 THEN 'No Discount'
		WHEN Discount <= 0.25 THEN 'Low Discount'
		WHEN Discount <= 0.35 THEN 'Medium Discount'
		WHEN Discount <= 0.50 THEN 'High Discount'
    END AS discount_type,
    
    COUNT(*) AS transactions,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    ROUND(SUM(Profit)/SUM(Sales)*100,2) AS profit_margin
    
FROM store_sales_data_original
GROUP BY `Category of Goods`, `Sub-Category`, discount_type
ORDER BY profit_margin ASC;



# Customer Analysis

	#By total sales
SELECT
	`Customer Name`, `Last Name`,
    CONCAT(`Customer Name`,' ',`Last Name`) AS customer_full_name,
    COUNT(*) AS transactions,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    ROUND(SUM(Profit)/SUM(Sales)*100,2) AS profit_margin
    
FROM store_sales_data_original
GROUP BY `Customer Name`, `Last Name`
ORDER BY total_sales DESC
LIMIT 30;

	#By total profit
SELECT
	`Customer Name`, `Last Name`,
    CONCAT(`Customer Name`,' ',`Last Name`) AS customer_full_name,
    COUNT(*) AS transactions,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    ROUND(SUM(Profit)/SUM(Sales)*100,2) AS profit_margin
    
FROM store_sales_data_original
GROUP BY `Customer Name`, `Last Name`
ORDER BY total_profit DESC
LIMIT 30;
	


# Time Analysis

SELECT
	YEAR(`Order Date`) AS order_year,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    ROUND(SUM(Profit)/SUM(Sales)*100,2) AS profit_margin
    
FROM store_sales_data_original
GROUP BY YEAR(`Order Date`)
ORDER BY order_year;


