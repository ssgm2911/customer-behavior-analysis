CREATE VIEW stg_order_items AS
SELECT
    order_id,
    product_id,
    seller_id,
    price,
    freight_value
FROM olist_order_items_dataset;