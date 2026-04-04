-- segment product into cost range and,
-- count how many product falls into each segment


WITH product_segmentation AS (
	SELECT
		product_key,
		product_name,
		cost,
	CASE 
		WHEN cost < 100 THEN 'Below 100'
		WHEN cost >= 100 AND cost <= 500 THEN '100-500'
		WHEN cost >500 AND cost <=1000 THEN '501-1000'
		ELSE 'Above 1000'
	END AS cost_ranges
	FROM gold_dim_products
)
SELECT
	cost_ranges,
	COUNT(product_key) AS Total_Products
FROM product_segmentation
GROUP BY cost_ranges
;

/* 
group customer into 3 segments based on their spending behaviour 
1. VIP : atleast 12 months of history and spending more than 5000
2. Regular : at least 12 months of history but spending less than or equal to 5000
3. New : lifespan less than 12 months
find total number of customer inside each segment
*/

WITH total_spending_by_customer AS (
	SELECT
	customer_key,
	SUM(sales_amount) AS total_sales,
	TIMESTAMPDIFF( MONTH, MIN(order_date), MAX(order_date)) AS lifespan
	FROM gold_fact_sales
    WHERE order_date IS NOT NULL
    AND order_date > 0
	GROUP BY customer_key
)
,customer_segmentation AS (
	SELECT
	customer_key,
	total_sales,
	CASE 
		WHEN total_sales > 5000  AND lifespan >= 12 THEN 'VIP'
		WHEN total_sales <= 5000 AND lifespan >= 12 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment
	FROM total_spending_by_customer
)
SELECT
	customer_segment,
	COUNT(customer_key)  AS Total_customer
FROM customer_segmentation
GROUP BY customer_segment
;

