-- =============================================
-- FACT TABLE: fact_orders
-- Grain: 1 row per order
-- Cleaned exactly as Notebook 02 (Python)
-- =============================================

DROP TABLE IF EXISTS fact_orders;

CREATE TABLE fact_orders AS

WITH order_revenue AS (
    -- Revenue aggregated from payments
    SELECT
        order_id,
        SUM(payment_value) AS order_value
    FROM stg_order_payments
    GROUP BY order_id
),

order_reviews AS (
    -- Average review per order
    SELECT
        order_id,
        AVG(review_score) AS review_score
    FROM stg_reviews
    GROUP BY order_id
)

SELECT
    o.order_id,
    c.customer_unique_id              AS customer_key,
    
    DATE(o.order_purchase_timestamp)  AS order_date_key,

    -- Revenue
    r.order_value,

    -- Review
    rv.review_score,

    -- Delivery metrics
    JULIANDAY(o.order_delivered_customer_date) -
    JULIANDAY(o.order_estimated_delivery_date) AS delivery_delay_days,

    -- Time features
    CAST(STRFTIME('%Y', o.order_purchase_timestamp) AS INTEGER) AS order_year,
    CAST(STRFTIME('%m', o.order_purchase_timestamp) AS INTEGER) AS order_month

FROM stg_orders o

LEFT JOIN stg_customers c
    ON o.customer_id = c.customer_id

LEFT JOIN order_revenue r
    ON o.order_id = r.order_id

LEFT JOIN order_reviews rv
    ON o.order_id = rv.order_id

WHERE 
    -- Only delivered orders
    o.order_status = 'delivered'
    
    -- Remove rows with missing delivery date
    AND o.order_delivered_customer_date IS NOT NULL
    
    -- Remove missing revenue
    AND r.order_value IS NOT NULL