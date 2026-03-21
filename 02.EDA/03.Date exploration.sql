-- Date Exploration

-- find the date of first and last order 

SELECT
MIN(order_Date) AS first_order_date,
MAX(order_date) AS first_order_date
FROM gold_fact_sales
WHERE order_date IS NOT NULL
AND order_date > 0 
;

-- how many years of sales are available

SELECT
TIMESTAMPDIFF(YEAR,MIN(order_date),MAX(order_date)) 
FROM gold_fact_sales
WHERE order_date IS NOT NULL
AND order_date > 0
;

-- young and oldest customer

SELECT
MIN(birthdate) oldest_customer,
MAX(birthdate) youngest_customer,
TIMESTAMPDIFF(YEAR,MIN(birthdate),CURRENT_DATE() ) AS oldest_age,
TIMESTAMPDIFF(YEAR,MAX(birthdate),CURRENT_DATE() ) AS youngest_age
FROM gold_dim_customers
WHERE birthdate IS NOT NULL
AND birthdate > 0
;