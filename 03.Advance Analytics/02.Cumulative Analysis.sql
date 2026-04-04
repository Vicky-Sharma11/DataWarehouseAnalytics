-- Calculate Total sales per month and 
-- running total of sales over time

WITH total_sales_per_month AS (
	SELECT
		DATE_FORMAT(order_date,'%Y-%m') AS order_month,
		YEAR(order_date) AS yr,
		SUM(sales_amount) AS total_sales
	FROM gold_fact_sales
	WHERE order_date IS NOT NULL
	AND order_date != 0000-00-00
	GROUP BY DATE_FORMAT(order_date,'%Y-%m'),YEAR(order_date)
)
SELECT
	order_month,
	total_sales,
	SUM(total_sales) OVER( 
		PARTITION BY yr
		ORDER BY order_month ) AS running_sales
FROM total_sales_per_month
;

-- Calculate 3-month moving average per month

WITH total_sales_per_month AS (
	SELECT
		DATE_FORMAT(order_date,'%Y-%m') AS order_month,
		YEAR(order_date) AS yr,
		AVG(price) AS avg_price
	FROM gold_fact_sales
	WHERE order_date IS NOT NULL
	AND order_date != 0000-00-00
	GROUP BY DATE_FORMAT(order_date,'%Y-%m'),YEAR(order_date)
)
SELECT
	order_month,
	avg_price,
	avg(avg_price) OVER( 
		PARTITION BY yr
		ORDER BY order_month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg
FROM total_sales_per_month
;

