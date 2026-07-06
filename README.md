# dhc-health-analytics
[Descriptionに入力する文章] 【非公式】健康食品・サプリメントECを想定した、四半期会員アクティブ率・前年同期比購買KPI分析用のD2C特化型SQLクエリ集（疑似データ想定）
# [Portfolio / Unofficial] dhc-health-analytics
### 健康食品・サプリメントECを想定した、四半期会員アクティブ率・前年同期比購買KPI分析用のD2C特化型SQLクエリ集（技術実証用 / 疑似データ）

![Unofficial](https://img.shields.io/badge/Status-Unofficial%20/%20Portfolio-red?style=for-the-badge)
![Data](https://img.shields.io/badge/Data-Simulated%20/%20Dummy-orange?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

---

## ⚠️ 免責事項 / Disclaimer (必ずお読みください)

*   **非公式プロジェクト (Unofficial Project)**: 本プロジェクトおよび本リポジトリに含まれるすべてのクエリ、仕様書、およびインサイトは、**株式会社ディーエイチシー（DHC）公式およびその他の実在する企業とは一切関係がありません。** 
*   **ダミーデータ想定 (Simulated/Dummy Data)**: 本プロジェクトで使用・想定されているすべてのデータ構造（登録会員数、売上、客単価、四半期別の購買率等）は、実際の企業の内部データや機密情報に基づくものではなく、一般に公開されている健康食品・D2C通販市場のトレンドや業界ベンチマークをベースに、**SQLのデータ抽出・集計スキルを実証（ポートフォリオ）するためにゼロから設計された「完全な疑似データ（ダミーデータ）」**です。
*   **商標・知的財産権 (Trademarks)**: 「DHC」およびそれに関連する名称・ロゴは、株式会社ディーエイチシーの登録商標です。本プロジェクトは、学術・技術ポートフォリオの目的においてのみこれらをシミュレーションの対象として引用しており、商業的意図、商標の侵害、またはブランドの流用を目的とするものではありません。

---

## 📂 プロジェクトのファイル構成

健康食品・化粧品といった「リピート通販（D2C）」の実務を想定したディレクトリ構成を採用し、会員の定着度やキャンペーンの投資対効果（LTV）を可視化するためのクエリを独立管理しています。

```text
dhc-health-analytics/
├── LICENSE                         # MIT License（権利関係をクリアにした法的防壁）
├── requirements.txt                # 依存関係を担保するハコ
├── README.md                       # 本ドキュメント（日本人向けに特化した全体仕様書）
└── queries/                         # クエリ格納フォルダ
    ├── 01_yoy_spring_campaign.sql   # レベル1: 春季キャンペーン（4月〜6月）の前年同期比（YoY）購買行動比較
    └── 02_quarterly_membership_kpi.sql # レベル2: 2026年度 四半期（Q1〜Q4）別 会員アクティブ率・平均購買額 推移
