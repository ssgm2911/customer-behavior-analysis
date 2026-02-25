/*
Business Question:
What percentage of customers make repeat purchases?
*/

WITH customer_orders AS (
    SELECT
        customer_key,
        COUNT(DISTINCT order_id) AS order_count
    FROM fact_orders
    GROUP BY customer_key
)

SELECT
    COUNT(CASE WHEN order_count > 1 THEN 1 END) * 1.0 
    / COUNT(*) AS repeat_customer_rate
FROM customer_orders;