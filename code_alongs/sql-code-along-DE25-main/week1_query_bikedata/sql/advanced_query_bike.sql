/* ==================
   Investigate unique 
   customers 
   ================== */

-- DISTINCT 
SELECT DISTINCT order_id
FROM staging.joined_table
ORDER BY order_id DESC; 

-- find unique values of customer_id
SELECT DISTINCT customer_id
FROM staging.joined_table
ORDER BY customer_id ASC;

-- find unique values of customer full names
SELECT DISTINCT customer_first_name, customer_last_name
FROM staging.joined_table
ORDER BY customer_first_name, customer_last_name;

-- it is 'Justina Jenkins' that is the issue 
-- this can be found out by one window function 
-- below also shows WHERE clause with two conditions
SELECT 
  customer_id,
  customer_first_name,
  customer_last_name,
  customer_city
FROM staging.joined_table
WHERE customer_first_name = 'Justina' AND customer_last_name = 'Jenkins'

/* ===========
   Introduce
   aggregation 
   =========== */
-- aggregate over rows
-- there are different ways of aggregation (max, min...)

-- what is the total revenues from all orders
SELECT 
  ROUND(SUM(quantity*list_price)) AS total_revenue
FROM staging.joined_table; 

-- try out other aggregation functions
SELECT 
  ROUND(MIN(quantity*list_price)) AS min_revenue,
  ROUND(MAX(quantity*list_price)) AS max_revenue
FROM staging.joined_table; 

/* ===============
   CASE...WHEN
   ================ */
-- similar if...else in other languages

-- we can replace the order_status column to some descriptons

SELECT 
  order_id,
  product_name,
  CASE order_status
    WHEN 1 THEN 'Pending'
    WHEN 2 THEN 'Processing'
    WHEN 3 THEN 'Rejected'
    WHEN 4 THEN 'Completed'
  END AS order_status_description
FROM staging.joined_table;
