-- =============================================
-- DELIVERY DELAY BUCKETS VS REVIEW SCORE
-- =============================================

SELECT
    CASE 
        WHEN delivery_delay_days < -6 THEN 'Early (7+ days)'
        WHEN delivery_delay_days BETWEEN -6 AND -1 THEN 'Early (1-6 days)'
        WHEN delivery_delay_days < 1 AND delivery_delay_days > -1 THEN 'On Time'
        WHEN delivery_delay_days >= 1 AND delivery_delay_days < 4 THEN 'Late (1-3 days)'
        WHEN delivery_delay_days BETWEEN 4 AND 7 THEN 'Late (4-7 days)'
        WHEN delivery_delay_days > 7 THEN 'Late (7+ days)'
        ELSE 'Unknown'
    END AS delay_bucket,

    ROUND(AVG(review_score), 2) AS avg_review_score,
    COUNT(*) AS total_orders

FROM fact_orders
WHERE review_score IS NOT NULL 

GROUP BY delay_bucket
ORDER BY avg_review_score DESC;