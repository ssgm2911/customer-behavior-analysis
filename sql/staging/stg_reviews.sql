CREATE VIEW stg_reviews AS
SELECT
    review_id,
    order_id,
    review_score,
    review_creation_date
FROM olist_order_reviews_dataset;