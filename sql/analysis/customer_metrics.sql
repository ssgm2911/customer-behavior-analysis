-- =============================================
-- CUSTOMER METRICS TABLE
-- Based exclusively on fact_orders (star schema)
-- Grain: 1 row per customer
-- =============================================

DROP TABLE IF EXISTS customer_metrics;

CREATE TABLE customer_metrics AS

WITH customer_base AS (
    SELECT
        customer_key,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(order_value) AS total_revenue,
        AVG(order_value) AS avg_order_value,
        MIN(order_date_key) AS first_purchase_date,
        MAX(order_date_key) AS last_purchase_date
    FROM fact_orders
    GROUP BY customer_key
),

reference_date AS (
    -- Use max date from fact_orders (NOT current date)
    SELECT MAX(order_date_key) AS max_date
    FROM fact_orders
)

SELECT
    cb.customer_key,
    cb.total_orders,
    ROUND(cb.total_revenue, 2) AS total_revenue,
    ROUND(cb.avg_order_value, 2) AS avg_order_value,
    cb.first_purchase_date,
    cb.last_purchase_date,

    -- Recency (days since last purchase)
    CAST(
        JULIANDAY(r.max_date) - JULIANDAY(cb.last_purchase_date)
        AS INTEGER
    ) AS recency_days,

    -- Customer lifetime (days between first and last purchase)
    CAST(
        JULIANDAY(cb.last_purchase_date) -
        JULIANDAY(cb.first_purchase_date)
        AS INTEGER
    ) AS customer_lifetime_days,

    -- Churn definition: inactive > 90 days
    CASE 
        WHEN (JULIANDAY(r.max_date) - JULIANDAY(cb.last_purchase_date)) > 90 
        THEN 1 ELSE 0
    END AS churn_flag

FROM customer_base cb
CROSS JOIN reference_date r;