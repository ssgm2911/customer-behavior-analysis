DROP TABLE IF EXISTS dim_date;

CREATE TABLE dim_date AS
SELECT DISTINCT
    DATE(order_purchase_timestamp) AS date_key,
    STRFTIME('%Y', order_purchase_timestamp) AS year,
    STRFTIME('%m', order_purchase_timestamp) AS month,
    STRFTIME('%Y-%m', order_purchase_timestamp) AS year_month
FROM stg_orders;