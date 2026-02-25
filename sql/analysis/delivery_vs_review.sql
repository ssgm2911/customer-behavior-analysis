/*
Business Question:
Does delivery delay impact customer satisfaction?
*/

SELECT
    CASE
        WHEN f.delivery_days <= 3 THEN 'Fast Delivery'
        WHEN f.delivery_days BETWEEN 4 AND 7 THEN 'Standard Delivery'
        ELSE 'Delayed Delivery'
    END AS delivery_speed_group,

    ROUND(AVG(f.review_score), 2) AS avg_review_score,
    COUNT(*) AS total_orders

FROM fact_orders f

GROUP BY delivery_speed_group
ORDER BY avg_review_score DESC;