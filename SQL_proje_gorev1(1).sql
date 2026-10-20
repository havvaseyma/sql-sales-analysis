---Google ve Facebook için günlük harcama metriklerinin ortalama, maksimum ve minimum değerleri---
WITH all_ads AS (

    SELECT
        ad_date,
        spend,
        'Facebook' AS platform
    FROM facebook_ads_basic_daily

    UNION ALL

    SELECT
        ad_date,
        spend,
        'Google' AS platform
    FROM google_ads_basic_daily

),

daily_spend AS (

    SELECT
        platform,
        ad_date,
        SUM(COALESCE(spend, 0)) AS total_spend
    FROM all_ads
    GROUP BY
        platform,
        ad_date

)

SELECT
    platform,
    ROUND(AVG(total_spend), 2) AS avg_spend,
    ROUND(MAX(total_spend)::numeric, 2) AS max_spend,
    ROUND(MIN(total_spend)::numeric, 2) AS min_spend
FROM daily_spend
GROUP BY platform;