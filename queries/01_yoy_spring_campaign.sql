-- ==============================================================================
# [Portfolio / Unofficial] dhc-health-analytics
-- レベル1: 春季キャンペーン（4月〜6月）の前年同期比（YoY）購買行動比較クエリ
-- 【ビジネス要求】健康食品ECにおける、今年と去年の4月〜6月期間を対象に、
--  「アクティブ購入会員数」「総売上高」「平均客単価」の推移を比較・検証する
-- ==============================================================================

WITH seasonal_raw_data AS (
    SELECT 
        -- 購入タイムスタンプから「年（YYYY）」を抽出
        DATE_FORMAT(purchase_timestamp, '%Y') AS purchase_year,
        order_id,
        user_id,
        price_amount
    FROM 
        dhc_sales_logs
    WHERE 
        -- ターゲットとなる「4月1日 〜 6月30日」を正確にスキャン
        DATE_FORMAT(purchase_timestamp, '%m-%d') BETWEEN '04-01' AND '06-30'
        -- 2025年と2026年の2カ年を対象に指定
        AND purchase_timestamp BETWEEN '2025-01-01' AND '2026-12-31'
)
SELECT 
    purchase_year,
    
    -- 【ファン層の熱量KPI】期間中に実際に購入したユニークなアクティブ会員数
    COUNT(DISTINCT user_id) AS active_purchasing_members,
    
    -- 【総売上高】
    SUM(price_amount) AS total_campaign_revenue,
    
    -- 【購買頻度】期間中の総注文数
    COUNT(DISTINCT order_id) AS total_orders_count,
    
    -- 【ロイヤル客単価KPI】サプリメントECで最重要視される「1注文あたりの平均購入額」
    ROUND(SUM(price_amount) / COUNT(DISTINCT order_id), 0) AS average_order_value,
    
    -- 【会員1人あたりLTV】期間中における、会員1人あたりの平均合計購買金額
    ROUND(SUM(price_amount) / COUNT(DISTINCT user_id), 0) AS revenue_per_member
FROM 
    seasonal_raw_data
GROUP BY 
    purchase_year
ORDER BY 
    purchase_year ASC;
