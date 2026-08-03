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

        



