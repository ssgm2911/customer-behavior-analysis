DROP TABLE IF EXISTS fact_orders;

CREATE TABLE fact_orders AS
SELECT
    o.order_id,
    c.customer_unique_id       AS customer_key,
    oi.product_id              AS product_key,
    DATE(o.order_purchase_timestamp) AS date_key,

    oi.price                   AS revenue,
    oi.freight_value           AS freight,
    r.review_score,

    JULIANDAY(o.order_delivered_customer_date) -
    JULIANDAY(o.order_purchase_timestamp) AS delivery_days

FROM stg_orders o
LEFT JOIN stg_customers c
    ON o.customer_id = c.customer_id
LEFT JOIN stg_order_items oi
    ON o.order_id = oi.order_id
LEFT JOIN stg_reviews r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered';