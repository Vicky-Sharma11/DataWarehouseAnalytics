-- Dimensions Exploration

-- explore all countries our customer come from

SELECT
DISTINCT country
FROM gold_dim_customers ;

-- explore all product categories "The Major Division"

SELECT 
DISTINCT category,subcategory, product_name
FROM gold_dim_products 
ORDER BY 1,2,3 ;

