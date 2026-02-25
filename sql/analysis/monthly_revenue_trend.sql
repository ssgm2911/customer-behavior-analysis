/*
Business Question:
How is revenue evolving over time?
Are there seasonality patterns or growth trends?

Grain:
Year-Month level
*/

SELECT
    d.year,
    d.month,
    d.year || '-' || d.month AS year_month,
    SUM(f.revenue) AS total_revenue,
    COUNT(DISTINCT f.order_id) AS total_orders,
    ROUND(SUM(f.revenue) * 1.0 / COUNT(DISTINCT f.order_id), 2) AS avg_order_value

FROM fact_orders f
JOIN dim_date d
    ON f.date_key = d.date_key

GROUP BY d.year, d.month
ORDER BY d.year, d.month;