---En uzun kesintisiz gösterime sahip adset_name---
WITH adset_days AS (

    SELECT DISTINCT
        fb.ad_date,
        fa.adset_name
    FROM facebook_ads_basic_daily AS fb
    LEFT JOIN facebook_adset AS fa
        ON fb.adset_id = fa.adset_id

),

numbered AS (

    SELECT
        adset_name,
        ad_date,
        ROW_NUMBER() OVER (
            PARTITION BY adset_name
            ORDER BY ad_date
        ) AS rn
    FROM adset_days

),

groups_data AS (

    SELECT
        adset_name,
        ad_date,
        ad_date - (rn * INTERVAL '1 day') AS grp
    FROM numbered

)

SELECT
    adset_name,
    MIN(ad_date) AS start_date,
    MAX(ad_date) AS end_date,
    COUNT(*) AS duration_days
FROM groups_data
GROUP BY
    adset_name,
    grp
ORDER BY duration_days DESC
LIMIT 1;