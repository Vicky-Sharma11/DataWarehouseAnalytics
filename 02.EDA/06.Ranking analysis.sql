-- Ranking Analysis

-- which 5 products generate the highest revenue

SELECT 
p.product_name,
SUM(sales_amount) AS Total_revenue
FROM gold_fact_sales AS s
LEFT JOIN gold_dim_products AS p
	ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY Total_revenue DESC
LIMIT 5 ;

-- 5 worst performing products in terms of sales

SELECT 
p.product_name,
SUM(sales_amount) AS Total_revenue
FROM gold_fact_sales AS s
LEFT JOIN gold_dim_products AS p
	ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY Total_revenue 
LIMIT 5 ;

-- Top 10 customers who have generated the highest revenue

SELECT 
c.customer_key,
c.first_name,
c.last_name,
SUM(s.sales_amount) AS Total_Revenue
FROM gold_fact_sales AS s
LEFT JOIN gold_dim_customers AS c
	ON s.customer_key = c.customer_key
GROUP BY 
c.customer_key,
c.first_name,
c.last_name
ORDER BY Total_Revenue DESC
LIMIT 10 ;

-- worst 3 customer with lowest order placed

SELECT 
c.customer_key,
c.first_name,
c.last_name,
COUNT(DISTINCT s.order_number) AS Total_Order
FROM gold_fact_sales AS s
LEFT JOIN gold_dim_customers AS c
	ON s.customer_key = c.customer_key
GROUP BY 
c.customer_key,
c.first_name,
c.last_name
ORDER BY Total_order 
LIMIT 3 ;
