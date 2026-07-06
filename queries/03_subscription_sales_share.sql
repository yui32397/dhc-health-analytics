-- ==============================================================================
-- レベル3: 定期購入（サブスク）vs 都度購入（スポット）売上構成比 抽出クエリ
-- 【ビジネス要求】Looker Studioの円グラフや100%積み上げ棒グラフにマウントするため、
--  購入スタイルごとの「総売上高」「注文数」および「定期購入の売上シェア（%）」を算出する
-- ==============================================================================

WITH purchase_style_summary AS (
    SELECT 
        -- 購入タイプをフラグ（1: 定期購入、0: 都度購入）でグループ化
        CASE 
            WHEN is_subscription = 1 THEN '定期購入（サブスク）'
            ELSE '都度購入（スポット）'
        END AS purchase_style,
        
        -- スタイルごとの総売上高と総注文数を集計
        SUM(price_amount) AS style_revenue,
        COUNT(DISTINCT order_id) AS style_orders
    FROM 
        dhc_sales_logs
    WHERE 
        -- 2026年度の最新データを対象に指定
        purchase_timestamp BETWEEN '2026-01-01' AND '2026-12-31'
    GROUP BY 
        1
),
total_revenue_summary AS (
    -- 構成比（シェア）を計算するため、全体の総売上高を1行で取得
    SELECT 
        SUM(price_amount) AS grand_total_revenue 
    FROM 
        dhc_sales_logs
    WHERE 
        purchase_timestamp BETWEEN '2026-01-01' AND '2026-12-31'
)
SELECT 
    p.purchase_style,
    p.style_revenue,
    p.style_orders,
    -- 【定期売上シェアKPI】（各スタイルの売上 / 全体の総売上）× 100 で構成比（%）を計算
    ROUND((p.style_revenue * 100.0) / t.grand_total_revenue, 2) AS revenue_share_percentage
FROM 
    purchase_style_summary AS p
CROSS JOIN 
    total_revenue_summary AS t
ORDER BY 
    p.style_revenue DESC; -- 売上シェアが高い順にソート
