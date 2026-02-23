DROP TABLE IF EXISTS dim_products;

CREATE TABLE dim_products AS
SELECT DISTINCT
    oi.product_id AS product_key,
    p.product_category_name,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM stg_order_items oi
LEFT JOIN olist_products_dataset p
    ON oi.product_id = p.product_id;