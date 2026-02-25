/*
Business Question:
Which states drive the most revenue?
*/

SELECT
    c.customer_state,
    SUM(f.order_value) AS total_revenue,
    COUNT(DISTINCT f.order_id) AS total_orders

FROM fact_orders f
JOIN dim_customers c
    ON f.customer_key = c.customer_key

GROUP BY c.customer_state
ORDER BY total_revenue DESC
LIMIT 10;