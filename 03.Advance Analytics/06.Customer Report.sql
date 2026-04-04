/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

-- =============================================================================
-- Create Report: gold.report_customers
-- =============================================================================

CREATE VIEW customer_report AS 
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/

WITH base_query AS (
	SELECT
		c.customer_key,
		c.customer_number,
		CONCAT(c.first_name,' ',c.last_name) AS cust_name,
		TIMESTAMPDIFF(YEAR,c.birthdate,CURRENT_DATE()) AS age,
		s.order_number,
		s.product_key,
		s.order_date,
		s.quantity,
		s.sales_amount
	FROM gold_dim_customers AS c
	JOIN gold_fact_sales AS s
		ON c.customer_key = s.customer_key
	WHERE order_date IS NOT NULL
    AND order_Date > 0
)
,aggregations AS (
/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
	SELECT
		customer_key,
		customer_number,
		cust_name,
		age,
		COUNT(DISTINCT order_number) AS Total_orders,
		SUM(sales_amount) AS Total_Sales,
		SUM(quantity) AS total_quantity,
		COUNT(Product_key) AS Total_Product,
		MAX(order_date) AS Last_order,
		TIMESTAMPDIFF(MONTH,MIN(order_Date),MAX(order_Date)) AS lifespan
	FROM base_query
	GROUP BY 
	customer_key,
	customer_number,
	cust_name,
	age
)
	SELECT
		customer_key,
		customer_number,
		cust_name,
		age,
        CASE 
			WHEN age < 20 THEN  'Under 20'
            WHEN age BETWEEN 20 AND 29 THEN '20-29'
            WHEN age BETWEEN 30 AND 39 THEN '30-39'
            WHEN age BETWEEN 40 AND 49 THEN '40-49'
            ELSE '50 and above' 
		END AS age_groups,
		CASE 
			WHEN total_sales > 5000  AND lifespan >= 12 THEN 'VIP'
			WHEN total_sales <= 5000 AND lifespan >= 12 THEN 'Regular'
			ELSE 'New'
		END AS customer_segment,
		Total_orders,
		Total_Sales,
		total_quantity,
		Total_Product,
		Last_order,
        -- Order Recency
        TIMESTAMPDIFF(MONTH,last_order,CURRENT_DATE) AS recency,
		lifespan,
        -- Average order Value
        CASE 
			WHEN total_orders = 0 THEN 0 
            ELSE Total_sales/Total_orders 
		END AS Avg_Order_value,
        -- average monthly spend
        CASE 
			WHEN lifespan = 0 THEN total_sales
            ELSE total_sales/lifespan END AS avg_montly_spend
	FROM aggregations
;
 
-- total_customer and sales by segments

SELECT 
	customer_segment,
	COUNT(customer_number) AS total_customers,
	SUM(total_sales) AS Total_sales
FROM customer_report
GROUP BY customer_segment
;