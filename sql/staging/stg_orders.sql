CREATE VIEW stg_orders AS
SELECT
    order_id,
    customer_id,
    LOWER(order_status) AS order_status,
    order_purchase_timestamp,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM olist_orders_dataset;