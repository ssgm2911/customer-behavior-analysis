-- =============================================
-- REVENUE BY CATEGORY
-- Uses fact_orders (filtered delivered)
-- Joins to items and products for category
-- =============================================

SELECT
    p.product_category_name,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    COUNT(DISTINCT fo.order_id) AS total_orders
FROM fact_orders fo

JOIN stg_order_items oi
    ON fo.order_id = oi.order_id

JOIN stg_products p
    ON oi.product_id = p.product_id

GROUP BY p.product_category_name
ORDER BY total_revenue DESC;