---Haftalık en yüksek toplam value'ya sahip kampanya---
SELECT
    DATE_TRUNC('week', fb.ad_date)::date AS week_start,
    fc.campaign_name,
    ROUND(SUM(COALESCE(fb.value, 0)), 2) AS total_value
FROM facebook_ads_basic_daily AS fb
LEFT JOIN facebook_campaign AS fc
    ON fb.campaign_id = fc.campaign_id
GROUP BY
    DATE_TRUNC('week', fb.ad_date)::date,
    fc.campaign_name
ORDER BY total_value DESC
LIMIT 1;