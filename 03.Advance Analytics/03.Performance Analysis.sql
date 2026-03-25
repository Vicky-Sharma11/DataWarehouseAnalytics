-- Performance Analysis
-- Analyze yearly product performance vs average and previous year

WITH yearly_sales AS (
    SELECT
        p.product_key,
        p.product_name,
        DATE_FORMAT(f.order_date, '%Y') AS year,
        SUM(f.sales_amount) AS current_year_sales
    FROM gold_fact_sales AS f
    LEFT JOIN gold_dim_products AS p ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY p.product_key, p.product_name, DATE_FORMAT(f.order_date, '%Y')
),
sales_metrics AS (
    SELECT
        product_name,
        year,
        current_year_sales,
        AVG(current_year_sales) OVER (PARTITION BY product_key) AS avg_sales,
        LAG(current_year_sales) OVER (PARTITION BY product_key ORDER BY year) AS previous_year_sales
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
    END AS avg_performance,
    previous_year_sales,
    current_year_sales - previous_year_sales AS diff_from_py,
    CASE 
        WHEN previous_year_sales IS NULL THEN 'No Previous Year'
        WHEN current_year_sales > previous_year_sales THEN 'Sales Increased'
        WHEN current_year_sales < previous_year_sales THEN 'Sales Decreased'
        ELSE 'No Change'
    END AS sales_trend
FROM sales_metrics
ORDER BY product_name, year;