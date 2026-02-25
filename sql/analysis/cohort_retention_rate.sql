-- =============================================
-- COHORT RETENTION RATE TABLE
-- Based on fact_orders (delivered only)
-- Ready for BI consumption
-- =============================================

DROP TABLE IF EXISTS cohort_retention_rate;

CREATE TABLE cohort_retention_rate AS

WITH first_purchase AS (
    SELECT
        customer_key,
        MIN(order_date_key) AS first_purchase_date
    FROM fact_orders
    GROUP BY customer_key
),

cohort_base AS (
    SELECT
        f.customer_key,
        DATE(fp.first_purchase_date, 'start of month') AS cohort_month,
        DATE(f.order_date_key, 'start of month') AS activity_month
    FROM fact_orders f
    JOIN first_purchase fp
        ON f.customer_key = fp.customer_key
),

cohort_calculated AS (
    SELECT
        customer_key,
        cohort_month,
        activity_month,
        (
            (CAST(STRFTIME('%Y', activity_month) AS INTEGER) -
             CAST(STRFTIME('%Y', cohort_month) AS INTEGER)) * 12
            +
            (CAST(STRFTIME('%m', activity_month) AS INTEGER) -
             CAST(STRFTIME('%m', cohort_month) AS INTEGER))
        ) AS month_number
    FROM cohort_base
),

cohort_counts AS (
    SELECT
        cohort_month,
        month_number,
        COUNT(DISTINCT customer_key) AS active_customers
    FROM cohort_calculated
    GROUP BY cohort_month, month_number
),

cohort_size AS (
    SELECT
        cohort_month,
        active_customers AS cohort_size
    FROM cohort_counts
    WHERE month_number = 0
)

SELECT
    c.cohort_month,
    c.month_number,
    c.active_customers,
    s.cohort_size,
    ROUND(
        CAST(c.active_customers AS REAL) / s.cohort_size,
        4
    ) AS retention_rate
FROM cohort_counts c
JOIN cohort_size s
    ON c.cohort_month = s.cohort_month
ORDER BY c.cohort_month, c.month_number;