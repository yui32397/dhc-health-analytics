-- ==============================================================================
-- レベル2: 2026年度 四半期（Q1〜Q4）別 会員アクティブ率・平均購買額 推移クエリ
-- 【ビジネス要求】経営陣向けダッシュボードにマウントするため、今年（2026年）の
--  四半期ごとの「登録会員数」「実購買会員数」「購買率（%）」「平均客単価」を算出する
-- ==============================================================================

WITH quarterly_sales_summary AS (
    SELECT 
        -- 購入日を四半期（Q1, Q2, Q3, Q4）にクレンジング（分類）
        CASE 
            WHEN DATE_FORMAT(purchase_timestamp, '%m') BETWEEN '01' AND '03' THEN '2026_Q1'
            WHEN DATE_FORMAT(purchase_timestamp, '%m') BETWEEN '04' AND '06' THEN '2026_Q2'
            WHEN DATE_FORMAT(purchase_timestamp, '%m') BETWEEN '07' AND '09' THEN '2026_Q3'
            ELSE '2026_Q4'
        END AS target_quarter,
        order_id,
        user_id,
        price_amount
    FROM 
        dhc_sales_logs
    WHERE 
        -- 2026年通年の購買データをスコープに指定
        purchase_timestamp BETWEEN '2026-01-01' AND '2026-12-31'
),
total_members_count AS (
    -- 分母となる、2026年時点でデータベースに存在する全登録会員数を取得（マスターテーブルより）
    SELECT 
        COUNT(DISTINCT user_id) AS grand_total_members 
    FROM 
        dhc_user_master
)
SELECT 
    s.target_quarter,
    
    -- 【分母】全登録会員数
    m.grand_total_members,
    
    -- 【分子】その四半期に実際に購入したユニークな実購買会員数
    COUNT(DISTINCT s.user_id) AS actual_buying_members,
    
    -- 【会員アクティブ率KPI】全会員のうち、その四半期に何％が稼働（リピート）したか
    ROUND((COUNT(DISTINCT s.user_id) * 100.0) / m.grand_total_members, 2) AS membership_activity_rate_pct,
    
    -- 【総売上高】
    SUM(s.price_amount) AS quarterly_total_revenue,
    
    -- 【四半期・客単価KPI】購入者がその四半期に費やした平均購入金額
    ROUND(SUM(s.price_amount) / COUNT(DISTINCT s.order_id), 0) AS average_spend_per_order
FROM 
    quarterly_sales_summary AS s
CROSS JOIN 
    total_members_count AS m
GROUP BY 
    s.target_quarter, 
    m.grand_total_members
ORDER BY 
    s.target_quarter ASC;
