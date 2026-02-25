/*
Business Question:
What is the distribution of customer lifetime value?
Do we depend on a small group of high-value customers?
*/

SELECT
    c.customer_key,
    COUNT(DISTINCT f.order_id) AS total_orders,
    SUM(f.order_value) AS lifetime_revenue,
    ROUND(AVG(f.order_value), 2) AS avg_order_value

FROM fact_orders f
JOIN dim_customers c
    ON f.customer_key = c.customer_key

GROUP BY c.customer_key
ORDER BY lifetime_revenue DESC;