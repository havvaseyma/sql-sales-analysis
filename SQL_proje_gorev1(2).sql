---Toplam ROMI (Google ve Facebook dahil) açısından en yüksek 5 günü sırala (azalan şekilde tarih ve değer)---
WITH all_ads AS (

    SELECT
        ad_date,
        spend,
        value
    FROM facebook_ads_basic_daily

    UNION ALL

    SELECT
        ad_date,
        spend,
        value
    FROM google_ads_basic_daily

),

daily AS (

    SELECT
        ad_date,
        SUM(COALESCE(spend, 0)) AS total_spend,
        SUM(COALESCE(value, 0)) AS total_value
    FROM all_ads
    GROUP BY ad_date

)

SELECT
    ad_date,
    ROUND(
        ((total_value - total_spend) / NULLIF(total_spend, 0)) * 100,
        2
    ) AS romi
FROM daily
WHERE total_spend > 0
ORDER BY romi DESC NULLS LAST
LIMIT 5;