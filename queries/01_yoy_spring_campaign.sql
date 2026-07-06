-- ==============================================================================
# [Portfolio / Unofficial] real-estate-analytics
-- レベル1: 物件詳細ビューから内見申し込みへの成約率（CVR）分析クエリ（店舗・マーケ向け）
-- 【ビジネス要求】不動産ポータルにおいて、間取り・築年数セグメントごとに、
--  「総閲覧数」「内見申込数」「成約率（CVR %）」を算出し、優良物件の傾向を可視化する
-- ==============================================================================

WITH property_logs AS (
    SELECT 
        log.property_id,
        prop.layout_type, -- '1K', '1LDK', '2LDK' など
        -- 【築年数のクレンジング】築年数（age）に応じてセグメント化
        CASE 
            WHEN prop.building_age < 5 THEN 'A_新築・築浅(5年未満)'
            WHEN prop.building_age < 15 THEN 'B_中堅(5-15年未満)'
            ELSE 'C_ベテラン(15年以上)'
        END AS age_segment,
        log.is_viewed,
        log.is_applied -- 内見申し込みフラグ (1 = 申込あり, 0 = なし)
    FROM 
        real_estate_property_logs AS log
    LEFT JOIN 
        property_master AS prop
    ON 
        log.property_id = prop.property_id
    WHERE 
        log.action_timestamp >= '2026-01-01'
)
SELECT 
    layout_type,
    age_segment,
    -- 【閲覧ハコ】総PV数
    SUM(is_viewed) AS total_page_views,
    -- 【申込ハコ】総内見申し込み数
    SUM(is_applied) AS total_applications,
    -- 【成約率KPI】（内見申込数 / 総PV数）× 100 で物件ごとのCVR（%）を自動算出
    CASE 
        WHEN SUM(is_viewed) = 0 THEN 0.00
        ELSE ROUND((SUM(is_applied) * 100.0) / SUM(is_viewed), 2)
    END AS view_to_apply_cvr_percentage
FROM 
    property_logs
GROUP BY 
    layout_type,
    age_segment
ORDER BY 
    view_to_apply_cvr_percentage DESC;
