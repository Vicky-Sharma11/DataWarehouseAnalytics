-- Analyze Sales Performance Over the Time


SELECT 
DATE_FORMAT(order_date, '%Y-%m') AS Order_Date,
SUM(sales_amount) AS Total_Sales,
COUNT(DISTINCT customer_key) AS Total_Customers,
SUM(quantity) AS Total_Quantity
FROM gold_fact_sales 
WHERE order_date != 0000
GROUP BY DATE_FORMAT(order_date,'%Y-%m')
ORDER BY  DATE_FORMAT(order_date,'%Y-%m')
;