CREATE VIEW stg_order_payments AS

SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    CAST(payment_value AS REAL) AS payment_value

FROM olist_order_payments_dataset