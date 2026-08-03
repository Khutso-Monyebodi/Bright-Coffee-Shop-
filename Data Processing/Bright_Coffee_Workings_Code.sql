--Checking the full table
SELECT *
FROM bright_coffee_shop.default.sales_analysis;

--Checking how many rows does my dataset have
SELECT COUNT(*) AS Num_of_rows,
        COUNT(DISTINCT transaction_id) AS User_id
FROM bright_coffee_shop.default.sales_analysis;

--Checking for NULLs in the dataset
SELECT COUNT(*) AS NULL_Rows
FROM bright_coffee_shop.default.sales_analysis
WHERE transaction_id IS NULL 
OR transaction_date IS NULL
OR transaction_time IS NULL
OR transaction_qty IS NULL
OR product_id IS NULL
OR store_id IS NULL;

-- Checking what is the starting date and the ending date of the dataset
SELECT MIN(transaction_date) AS Earliest_date,
        MAX(transaction_date) AS Latest_date
FROM bright_coffee_shop.default.sales_analysis;

--Calculating revenue
SELECT ROUND(SUM(transaction_qty * TRY_CAST(REPLACE(unit_price, ',','.')AS DOUBLE)),2) AS Revenue
FROM bright_coffee_shop.default.sales_analysis;

-- Calculating Total Revenue
SELECT DISTINCT store_location,
ROUND(SUM(transaction_qty * TRY_CAST(REPLACE(unit_price, ',','.')AS DOUBLE)),2) AS Total_Revenue
FROM bright_coffee_shop.default.sales_analysis
GROUP BY store_location
ORDER BY Total_Revenue;

--Checking the distict branches
SELECT DISTINCT store_location,
                store_id
FROM bright_coffee_shop.default.sales_analysis;

-- Checking the distinct product category 
SELECT DISTINCT product_category
FROM bright_coffee_shop.default.sales_analysis;

-- Checking the distinct product types 
SELECT DISTINCT product_type
FROM bright_coffee_shop.default.sales_analysis;

-- Checking the lowest and the highest prices in the unit prices column
SELECT MIN((transaction_qty * TRY_CAST(REPLACE(unit_price, ',','.')AS DOUBLE))) AS Lowest_unit_price,
        MAX((transaction_qty * TRY_CAST(REPLACE(unit_price, ',','.')AS DOUBLE))) AS Highest_unit_prices
FROM bright_coffee_shop.default.sales_analysis;

--Total Revenue by Store location
SELECT DISTINCT store_location,
               ROUND(SUM(transaction_qty * TRY_CAST(REPLACE(unit_price, ',','.')AS DOUBLE)),2) AS Total_Revenue
FROM bright_coffee_shop.default.sales_analysis
GROUP BY store_location
ORDER BY Total_Revenue;

-- Checking Stores, products, and number of products
SELECT COUNT(*) AS number_of_rows,
      COUNT(DISTINCT transaction_id) AS number_of_sales,
      COUNT(DISTINCT product_id) AS number_of_products,
      COUNT(DISTINCT store_id) AS number_of_stores
FROM bright_coffee_shop.default.sales_analysis

SELECT ROUND(AVG(transaction_qty * TRY_CAST(REPLACE(unit_price, ',','.')AS DOUBLE)),2) AS Avg_Transaction,
        store_location
FROM bright_coffee_shop.default.sales_analysis;

--------------------------------------------------------------------------------------------------------------------
-- Big Cleaned Query
--------------------------------------------------------------------------------------------------------------------

SELECT transaction_id,
        transaction_date,
        transaction_qty,
        store_id,
        store_location,
        product_id,
        unit_price,
        product_category,
        product_type,
        product_detail,
        
--Adding Date Functions to the table
        DAYNAME(transaction_date) AS Day_name,
        MONTHNAME(transaction_date) AS Month_name,
        WEEKDAY(transaction_date) AS Week_day,
        HOUR(transaction_time) AS Transaction_hour,
        DATE_FORMAT(transaction_time, 'HH:mm:ss') AS Clean_time,
        DAYOFMONTH(transaction_date) AS Day_of_month,
         ROUND(transaction_qty * TRY_CAST(REPLACE(unit_price, ',','.')AS DOUBLE),2) AS Sale_per_transaction,

-- Adding case Statement buckets to the table
CASE
        WHEN HOUR(transaction_time) BETWEEN 0 AND 2 THEN 'Early Hours'
        WHEN HOUR(transaction_time) BETWEEN 3 AND 5 THEN 'Witch Hours'
        WHEN HOUR(transaction_time) BETWEEN 6 AND 8 THEN 'Rush Hours'
        WHEN HOUR(transaction_time) BETWEEN 9 AND 11 THEN 'Morning Hours'
        WHEN HOUR(transaction_time) BETWEEN 12 AND 14 THEN 'Lunch Hour'
        WHEN HOUR(transaction_time) BETWEEN 15 AND 17 THEN 'Afternoon Hours'
        WHEN HOUR(transaction_time) BETWEEN 18 AND 20 THEN 'Evening Hours'
    ELSE 'Late Hours'
END AS Transaction_time_bucket,
--Day Type
CASE
        WHEN DAYNAME(transaction_date) IN ('Sun', 'Sat')THEN 'Weekend'
        ELSE 'Weekday'
END AS Day_Type,

--Spending buckets
CASE
        WHEN Sale_per_transaction <=50 THEN '01. Low Spend'
        WHEN Sale_per_transaction BETWEEN 51 AND 100 THEN '02. Med Spend'
        ELSE '03. High Spend'
END AS spend_bucket
FROM bright_coffee_shop.default.sales_analysis;
