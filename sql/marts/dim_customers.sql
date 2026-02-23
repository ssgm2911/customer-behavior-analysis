DROP TABLE IF EXISTS dim_customers;

CREATE TABLE dim_customers AS
SELECT DISTINCT
    customer_unique_id        AS customer_key,
    customer_id,
    customer_city,
    customer_state
FROM stg_customers;