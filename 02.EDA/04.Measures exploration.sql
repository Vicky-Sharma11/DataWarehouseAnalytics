-- Measures exploration

-- find the total sales 
SELECT 
SUM(sales_amount) AS Total_sales
FROM gold_fact_sales
;

-- find how many quantity are sold

SELECT
SUM(quantity) AS Total_quanity_sold
FROM gold_fact_sales
;
-- find the average selling price

SELECT 
AVG(price) AS avg_price
FROM gold_fact_sales 
;
-- find the total number of order

SELECT
COUNT(DISTINCT order_number) AS Total_order
FROM gold_fact_sales
;
-- find the total number of products

SELECT 
COUNT(product_key) AS total_products
FROM gold_dim_products ;

-- find the total number of customers 

SELECT
COUNT(customer_key) AS Total_customers
FROM gold_dim_customers ;

-- find the total number of customers who have place an order

SELECT
COUNT(DISTINCT customer_key) Total_cust_who_placed_order
FROM gold_fact_sales
;

-- generate report that shows all key metrics of business

SELECT 'Total_sales' AS measure_name, SUM(sales_amount) AS measure_value  FROM gold_fact_sales
UNION ALL
SELECT 'Total_quantity' AS measure_name, SUM(quantity) AS measure_value  FROM gold_fact_sales
UNION ALL
SELECT 'Avg_price' AS measure_name, AVG(price) AS measure_value  FROM gold_fact_sales
UNION ALL
SELECT 'Total_nr._order' AS measure_name, COUNT(DISTINCT order_number) AS measure_value  FROM gold_fact_sales
UNION ALL
SELECT 'Total_nr._product' AS measure_name, COUNT(product_key) AS measure_value  FROM gold_dim_products
UNION ALL
SELECT 'Total_customers' AS measure_name, COUNT(customer_key) AS measure_value  FROM gold_dim_customers
UNION ALL
SELECT 'Total_customers_who_placed_order' AS measure_name, COUNT(DISTINCT customer_key) AS measure_value  FROM gold_fact_sales
;

