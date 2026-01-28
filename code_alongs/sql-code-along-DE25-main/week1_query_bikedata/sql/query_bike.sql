/* ==============
   Query the data
   ============== */

-- overview of data
DESC; 

DESC staging.joined_table; 

-- select all or some columns
SELECT * FROM staging.joined_table; 

SELECT 
   order_date,
   customer_first_name,
   customer_last_name,
   product_name
FROM staging.joined_table; 

-- filter rows with WHERE clause
SELECT 
   order_date,
   customer_first_name,
   customer_last_name,
   product_name
FROM staging.joined_table
WHERE customer_first_name = 'Marvin'; 

-- create a new table for order status description
CREATE TABLE IF NOT EXISTS staging.status (
   order_status INTEGER,
   order_status_description VARCHAR
); 

SELECT * FROM staging.status; 

INSERT INTO 
   staging.status
VALUES
   (1, 'Pending'),
   (2, 'Processing'),
   (3, 'Rejected'),
   (4, 'Completed');

-- join the two tables
SELECT 
  j.order_id,
  j.order_status,
  s.order_status_description
FROM staging.joined_table j
JOIN staging.status s ON j.order_status = s.order_status; 

-- sort the rows by order_status
-- ORDER BY...ASC DESC
SELECT 
  j.order_id,
  j.order_status,
  s.order_status_description
FROM staging.joined_table j
JOIN staging.status s ON j.order_status = s.order_status
-- ORDER BY j.order_status DESC;
ORDER BY j.order_status ASC; 

