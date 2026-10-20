---Aylık bazda en büyük erişim artışı yaşayan kampanya---
WITH monthly AS (

    SELECT
        DATE_TRUNC('month', fb.ad_date)::date AS month,
        fc.campaign_name,
        SUM(COALESCE(fb.reach, 0)) AS total_reach
    FROM facebook_ads_basic_daily AS fb
    LEFT JOIN facebook_campaign AS fc
        ON fb.campaign_id = fc.campaign_id
    GROUP BY
        DATE_TRUNC('month', fb.ad_date)::date,
        fc.campaign_name

),

growth AS (

    SELECT
        month,
        campaign_name,
        total_reach,
        LAG(total_reach) OVER (
            PARTITION BY campaign_name
            ORDER BY month
        ) AS prev_reach
    FROM monthly

)

SELECT
    month,
    campaign_name,
    ROUND(total_reach - prev_reach, 2) AS growth
FROM growth
WHERE prev_reach IS NOT NULL
ORDER BY growth DESC
LIMIT 1;