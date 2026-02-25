-- =============================================
-- REPEAT CUSTOMER RATE
-- Percentage of customers with >1 order
-- =============================================

SELECT
    ROUND(
        SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) * 1.0
        / COUNT(*),
        4
    ) AS repeat_customer_rate
FROM customer_metrics;