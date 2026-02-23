CREATE VIEW customer_metrics AS

WITH customer_agg AS (

    SELECT
        customer_unique_id,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(order_value) AS total_revenue,
        AVG(order_value) AS avg_order_value,
        MIN(order_purchase_timestamp) AS first_purchase,
        MAX(order_purchase_timestamp) AS last_purchase,
        AVG(review_score) AS avg_review_score
    FROM fact_orders
    GROUP BY customer_unique_id

)

SELECT
    *,
    CAST(
        julianday(last_purchase) -
        julianday(first_purchase)
    AS INTEGER) AS customer_lifetime_days,

    CAST(
        julianday('now') -
        julianday(last_purchase)
    AS INTEGER) AS recency_days

FROM customer_agg;

CREATE TABLE customer_metrics_table AS
SELECT * FROM customer_metrics;