CREATE VIEW cohort_retention AS

WITH customer_first_purchase AS (

    SELECT
        customer_unique_id,
        MIN(order_purchase_timestamp) AS first_purchase_date,
        strftime('%Y-%m', MIN(order_purchase_timestamp)) AS cohort_month
    FROM fact_orders
    GROUP BY customer_unique_id

),

orders_with_cohort AS (

    SELECT
        f.customer_unique_id,
        strftime('%Y-%m', f.order_purchase_timestamp) AS order_month,
        c.cohort_month,

        -- Cohort index (difference in months)
        (
            (CAST(strftime('%Y', f.order_purchase_timestamp) AS INTEGER) -
             CAST(strftime('%Y', c.first_purchase_date) AS INTEGER)) * 12
            +
            (CAST(strftime('%m', f.order_purchase_timestamp) AS INTEGER) -
             CAST(strftime('%m', c.first_purchase_date) AS INTEGER))
        ) AS cohort_index

    FROM fact_orders f
    JOIN customer_first_purchase c
        ON f.customer_unique_id = c.customer_unique_id

),

cohort_counts AS (

    SELECT
        cohort_month,
        cohort_index,
        COUNT(DISTINCT customer_unique_id) AS active_customers
    FROM orders_with_cohort
    GROUP BY cohort_month, cohort_index

),

cohort_sizes AS (

    SELECT
        cohort_month,
        active_customers AS cohort_size
    FROM cohort_counts
    WHERE cohort_index = 0

)

SELECT
    cc.cohort_month,
    cc.cohort_index,
    cc.active_customers,
    cs.cohort_size,
    ROUND(
        1.0 * cc.active_customers / cs.cohort_size,
        4
    ) AS retention_rate

FROM cohort_counts cc
JOIN cohort_sizes cs
    ON cc.cohort_month = cs.cohort_month

ORDER BY cc.cohort_month, cc.cohort_index;

CREATE TABLE cohort_retention_table AS
SELECT * FROM cohort_retention;