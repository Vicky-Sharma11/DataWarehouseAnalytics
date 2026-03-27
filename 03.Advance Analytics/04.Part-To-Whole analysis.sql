-- which category contribute the most to overall sales

WITH category_wise_sales AS (
	SELECT 
		p.category,
		SUM(sales_amount) AS Total_Sales_By_Category
	FROM gold_fact_sales AS s
	JOIN gold_dim_products AS p
	ON s.product_key = p.product_key
	GROUP BY 
	p.category
)

SELECT
	category,
	Total_Sales_By_Category,
	SUM(Total_Sales_By_Category) OVER() AS Total_Sales,
	CONCAT(
		ROUND(Total_Sales_By_Category/SUM(Total_Sales_By_Category) OVER()*100,
            2
            ),'%') AS percentage_of_total_sales
FROM category_wise_sales
ORDER BY Total_Sales_By_Category DESC
;


