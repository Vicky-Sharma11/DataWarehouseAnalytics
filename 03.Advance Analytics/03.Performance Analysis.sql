-- Performance Analysis

/*Analyze the yearly performance of products by comparing each product,
sales to both it's average sales performance and the previous year's sales*/

WITH yearly_sales AS (
    SELECT
        p.product_key,
        p.product_name,
        YEAR(order_date) AS year,
        SUM(sales_amount) AS current_year_sales
    FROM gold_fact_sales AS f
    JOIN gold_dim_products AS p
        ON f.product_key = p.product_key
    WHERE order_date IS NOT NULL
    GROUP BY p.product_key, p.product_name, YEAR(order_date)
),
base AS (
    SELECT
        *,
        AVG(current_year_sales) OVER(PARTITION BY product_key) AS avg_sales,
        LAG(current_year_sales) OVER(PARTITION BY product_key ORDER BY year) AS previous_year_sales
    FROM yearly_sales
)
SELECT
    product_name,
    year,
    current_year_sales,
    avg_sales,
    current_year_sales - avg_sales AS diff_from_avg,
    CASE 
        WHEN current_year_sales > avg_sales THEN 'Above Average'
        WHEN current_year_sales < avg_sales THEN 'Below Average'
        ELSE 'Average'
    END AS avg_change,
    previous_year_sales,
    current_year_sales - previous_year_sales AS diff_from_py,
    CASE 
        WHEN previous_year_sales IS NULL THEN 'No Previous Year'
        WHEN current_year_sales > previous_year_sales THEN 'Sales Increased'
        WHEN current_year_sales < previous_year_sales THEN 'Sales Decreased'
        ELSE 'No Change'
    END AS sales_change
FROM base
ORDER BY product_name, year
