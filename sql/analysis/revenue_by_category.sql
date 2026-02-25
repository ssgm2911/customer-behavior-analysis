/*
Business Question:
Which product categories generate the most revenue?
Is revenue diversified or concentrated?
*/

SELECT
    p.product_category_name,
    SUM(f.revenue) AS total_revenue,
    COUNT(DISTINCT f.order_id) AS total_orders,
    ROUND(AVG(f.revenue), 2) AS avg_item_value

FROM fact_orders f
JOIN dim_products p
    ON f.product_key = p.product_key

GROUP BY p.product_category_name
ORDER BY total_revenue DESC;