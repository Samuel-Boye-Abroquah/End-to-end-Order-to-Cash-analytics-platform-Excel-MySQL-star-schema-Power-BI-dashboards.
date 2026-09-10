<h1 align="center">
  <br>
  📊 Meridian Office & Tech Supply Co.
  <br>
  <sub>Order-to-Cash Analytics Platform · 2022 – 2025</sub>
  <br>
</h1>

<p align="center">
  <img alt="MySQL" src="https://img.shields.io/badge/MySQL-8.0+-4479A1?style=for-the-badge&logo=mysql&logoColor=white">
  <img alt="Python" src="https://img.shields.io/badge/Python-3.10+-3776AB?style=for-the-badge&logo=python&logoColor=white">
  <img alt="Pandas" src="https://img.shields.io/badge/pandas-2.0+-150458?style=for-the-badge&logo=pandas&logoColor=white">
  <img alt="Power BI" src="https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black">
  <img alt="License" src="https://img.shields.io/badge/license-MIT-green?style=for-the-badge">
</p>

<p align="center">
  <b>An end-to-end analytics pipeline</b> that turns a raw multi-sheet Excel workbook
  into a governed star schema, a live Power BI semantic model, and an executive
  dashboard suite — with full reproducibility from a single command.
</p>

---

## 🧭 Table of Contents

- [Overview](#-overview)
- [Headline Results](#-headline-results)
- [Architecture](#-architecture)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [The Pipeline, Step by Step](#-the-pipeline-step-by-step)
- [Data Model](#-data-model)
- [Power BI Layer](#-power-bi-layer)
- [DAX Measure Library](#-dax-measure-library)
- [Validation & Quality Gates](#-validation--quality-gates)
- [Design Decisions](#-design-decisions)
- [Known Assumptions](#-known-assumptions)
- [Roadmap](#-roadmap)
- [Author](#-author)
- [License](#-license)

---

## 🔎 Overview

**Meridian Office & Tech Supply Co.** is a fictional office-supply and
technology retailer operating across multiple US states. This project
reconstructs its full **Order-to-Cash** analytics platform from a single
source workbook containing four years of transactional data (2022–2025).

The goal: replace ad-hoc spreadsheet reporting with a **reproducible,
governed, and validated** analytics stack that any analyst can rebuild
from scratch.

**What this project delivers:**

| Layer | Deliverable |
| :--- | :--- |
| **Extract** | Python loader that reads every sheet of the workbook into MySQL |
| **Transform** | SQL views that reshape raw tables into a clean star schema |
| **Model** | Power BI semantic model with relationships, hierarchies, and DAX measures |
| **Visualize** | Executive dashboards covering revenue, orders, fulfilment, and product performance |

---

## 📈 Headline Results

Four years of data, fully reconciled against budget:

| Year | Sales | Budget | Variance | Attainment |
| :--- | ---: | ---: | ---: | ---: |
| 2022 | $10,039,905 | $10,220,000 | –$180,095 | 98.2% |
| 2023 | $11,271,243 | $11,350,400 | –$79,157 | 99.3% |
| 2024 | $12,605,794 | $12,892,400 | –$286,606 | 97.8% |
| 2025 | $14,233,698 | $14,474,500 | –$240,802 | 98.3% |
| **Total** | **$48,150,640** | **$48,937,300** | **–$786,660** | **98.4%** |

**Other key figures reproduced by this pipeline:**

- 📦 **≈ 18,550** distinct orders
- 🗓️ **1,461** calendar days of history (2022-01-01 → 2025-12-31)
- 💰 **≈ $44.0M** revenue from *completed* orders
- 📉 **–1.6%** cumulative variance against budget

---

## 🏗 Architecture

```text
┌───────────────────────────┐
│  Excel Workbook (.xlsx)   │   One file, N sheets
│  Meridian_OrderToCash     │   Orders · OrderLines · Products · Customers · security
└──────────────┬────────────┘
               │  pandas.read_excel(sheet_name=None)
               ▼
┌───────────────────────────┐
│  MySQL — Raw Tables       │   orders_2022..2025, orderlines_2022..2025,
│  (staging)                │   products, customers, security
└──────────────┬────────────┘
               │  SQL views (UNION ALL, joins, unpivots)
               ▼
┌───────────────────────────┐
│  MySQL — Star Schema      │   fact_sales · fact_order_process
│  (presentation)           │   dim_products · dim_customers · dim_city · dim_date · sec
└──────────────┬────────────┘
               │  ODBC / MySQL connector
               ▼
┌───────────────────────────┐
│  Power BI Semantic Model  │   Relationships · Hierarchies · DAX measures
└──────────────┬────────────┘
               │
               ▼
┌───────────────────────────┐
│  Executive Dashboards     │   Revenue · Orders · Fulfilment · Products
└───────────────────────────┘
```

---

## 📁 Project Structure

```text
meridian-order-to-cash-analytics/
│
├── README.md                        ← You are here
├── LICENSE
├── .gitignore                       ← Keeps .env, .xlsx, and caches out of git
├── .env.example                     ← Credential template (never commit .env)
├── requirements.txt
├── run_all.sql                      ← Single entry point for the SQL layer
│
├── etl/
│   └── load_excel.py                ← Reads every sheet → MySQL tables
│
├── sql/
│   ├── 00_setup.sql                 ← Schema selection
│   ├── 01_fact_order_process.sql    ← Order-header grain fact
│   ├── 02_fact_sales.sql            ← Order-line grain fact
│   ├── 03_dim_products.sql          ← Product × year dimension
│   ├── 04_dim_customers.sql         ← Customer dimension
│   ├── 05_dim_city.sql              ← City/state geo dimension
│   ├── 06_dim_date.sql              ← Calendar spine + Power BI view
│   ├── 07_sec.sql                   ← Security pass-through view
│   └── 99_validation.sql            ← Seven sanity checks
│
├── powerbi/
│   ├── Meridian_OrderToCash.pbix    ← Semantic model + dashboards
│   └── measures.dax                 ← DAX measure reference (plain text)
│
└── docs/
    ├── data_dictionary.md           ← Column-level documentation
    ├── model_diagram.png            ← Star schema diagram
    └── screenshots/                 ← Dashboard previews
```

---

## 🚀 Getting Started

### Prerequisites

| Tool | Version | Purpose |
| :--- | :--- | :--- |
| **Python** | 3.10+ | Runs the Excel → MySQL loader |
| **MySQL** | 8.0+ | Stores raw tables and star-schema views |
| **Power BI Desktop** | Latest | Opens the semantic model and dashboards |
| **ODBC Driver** | MySQL ODBC 8.0+ | Connects Power BI to MySQL |

### 1. Clone the repository

```bash
git clone https://github.com/<your-username>/meridian-order-to-cash-analytics.git
cd meridian-order-to-cash-analytics
```

### 2. Install Python dependencies

```bash
python -m venv .venv
source .venv/bin/activate        # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

### 3. Configure credentials

```bash
cp .env.example .env
```

Then edit `.env` with your MySQL credentials:

```dotenv
MERIDIAN_DB_USER=your_mysql_user
MERIDIAN_DB_PASSWORD=your_mysql_password
MERIDIAN_DB_HOST=localhost
MERIDIAN_DB_PORT=3306
MERIDIAN_DB_NAME=Meridian_OfficeSupply_OrderToCash_2022_2025
```

> ⚠️ `.env` is **gitignored**. Never commit real credentials.

### 4. Create the target database

```sql
CREATE DATABASE Meridian_OfficeSupply_OrderToCash_2022_2025
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 5. Run the pipeline

```bash
# Extract: Excel → MySQL raw tables
python etl/load_excel.py

# Transform: Raw tables → star schema views + validation
mysql -u "$MERIDIAN_DB_USER" -p "$MERIDIAN_DB_NAME" < run_all.sql
```

### 6. Open Power BI

Launch `powerbi/Meridian_OrderToCash.pbix` and refresh. The model will
pull fresh data through the ODBC connection defined in the file.

---

## 🛠 The Pipeline, Step by Step

### Step 1 — Excel → MySQL (`etl/load_excel.py`)

The workbook is read with `pandas.read_excel(sheet_name=None)`, which
returns every sheet as a DataFrame keyed by sheet name. Each sheet is
written to a MySQL table whose name is the sheet name lowercased with
spaces replaced by underscores.

**Source sheets → target tables:**

| Sheet | Table |
| :--- | :--- |
| `Orders_2022` … `Orders_2025` | `orders_2022` … `orders_2025` |
| `OrderLines_2022` … `OrderLines_2025` | `orderlines_2022` … `orderlines_2025` |
| `Products` | `products` |
| `Customers` | `customers` |
| `security` | `security` |

### Step 2 — Raw tables → Star schema (`sql/*.sql`)

Nine SQL files build the presentation layer. Each is idempotent — safe
to re-run without side effects.

| File | Object | Grain |
| :--- | :--- | :--- |
| `01_fact_order_process.sql` | `fact_order_process` | One row per order |
| `02_fact_sales.sql` | `fact_sales` | One row per order line |
| `03_dim_products.sql` | `dim_products` | One row per product per year |
| `04_dim_customers.sql` | `dim_customers` | One row per customer |
| `05_dim_city.sql` | `dim_city` | One row per city/state |
| `06_dim_date.sql` | `dim_date` (view) + `dim_date_tbl` (table) | One row per day |
| `07_sec.sql` | `sec` | Pass-through of `security` |

### Step 3 — MySQL → Power BI

Power BI connects via the **MySQL ODBC 8.0 driver** and imports the
star-schema views. Relationships are defined on surrogate keys; the
`dim_date` view is marked as the model's official date table.

### Step 4 — Model → Visualizations

Dashboards built on top of the semantic model:

- **Executive Summary** — Revenue, order volume, budget attainment, YoY growth
- **Order Fulfilment** — Confirmation → ship → delivery cycle times
- **Product Performance** — Top categories, margin by subcategory
- **Customer Insights** — Segment mix, retention, payment behaviour
- **Geographic View** — Revenue by state, city, and region
- **AR Aging** — Outstanding receivables by aging bucket

---

## ⭐ Data Model

Classic **star schema** with two fact tables at different grains:

```text
                    ┌─────────────────┐
                    │  dim_customers  │
                    └────────┬────────┘
                             │
┌──────────────┐    ┌────────▼─────────┐    ┌──────────────┐
│ dim_products │────│  fact_sales      │────│  dim_date    │
└──────────────┘    │  (order line)    │    └──────────────┘
                    └────────┬─────────┘
                             │
                    ┌────────▼──────────┐
                    │ fact_order_process│
                    │  (order header)   │
                    └────────┬──────────┘
                             │
                    ┌────────▼─────────┐        ┌──────────────┐
                    │  dim_city        │        │   Budget     │
                    └──────────────────┘        │ (standalone, │
                                                │  date-only)  │
                                                └──────────────┘

                              ┌──────────────┐
                              │   Security   │  (disconnected, RLS only)
                              └──────────────┘
```

### Grain separation matters

`fact_sales` is one row per order **line**. `fact_order_process` is one
row per **order**. Keeping them separate avoids the duplication bug
that shows up when a line-grain table is merged against a header-grain
table in Power Query.

### Slowly-changing prices

`dim_products` uses a **product × year** grain. `product_key` combines
`product_id` and the order year, so a product sold in 2022 joins to its
2022 cost and price, not a later revision. No Type-2 dimension needed.

### Role-playing dates

`dim_date` has **one active relationship** to `fact_order_process`
(`order_date`). Five additional date columns (`order_confirmation_date`,
`ship_date`, `delivery_date`, `invoice_date`, `payment_date`) are
connected via **inactive** relationships, activated per-measure with
`USERELATIONSHIP()`.

---

## 📈 Power BI Layer

**Connection:** MySQL ODBC → Import mode.
**Relationships:** one-to-many, single-direction, from dimensions to facts.
**Date table:** `dim_date[Date]` marked as the model's date table, with
`Year → Quarter → MonthName → Date` hierarchy.

### Relationship map

| From | To | Cardinality | Active |
| :--- | :--- | :--- | :---: |
| `dim_products[product_key]` | `fact_sales[product_key]` | 1 : * | ✅ |
| `dim_customers[customer_id]` | `fact_order_process[customer_id]` | 1 : * | ✅ |
| `dim_city[city_key]` | `dim_customers[city_key]` | 1 : * | ✅ |
| `dim_date[Date]` | `fact_order_process[order_date]` | 1 : * | ✅ |
| `dim_date[Date]` | `fact_order_process[ship_date]` | 1 : * | ❌ |
| `dim_date[Date]` | `fact_order_process[delivery_date]` | 1 : * | ❌ |
| `dim_date[Date]` | `fact_order_process[invoice_date]` | 1 : * | ❌ |
| `dim_date[Date]` | `fact_order_process[payment_date]` | 1 : * | ❌ |
| `dim_date[Date]` | `Budget[date]` | 1 : * | ✅ |
| `Security` | *(none — RLS only)* | — | — |

---

## 🧮 DAX Measure Library

A reference copy of every measure lives in `powerbi/measures.dax`.
Highlights:

```dax
-- Revenue (Completed)
Total Sales =
CALCULATE (
    SUM ( fact_sales[sales] ),
    fact_order_process[order_status] = "Completed"
)

-- Revenue (All Orders, no status filter)
Total Sales All Orders =
SUM ( fact_sales[sales] )

-- Budget + Variance
Budget Revenue   = SUM ( Budget[budget_revenue] )
Budget Variance  = [Total Sales] - [Budget Revenue]
Budget Variance % = DIVIDE ( [Budget Variance], [Budget Revenue] )

-- Order counts
Total Orders     = DISTINCTCOUNT ( fact_sales[order_id] )
Completed Orders =
CALCULATE (
    DISTINCTCOUNT ( fact_sales[order_id] ),
    fact_order_process[order_status] = "Completed"
)

-- AOV (Completed only)
AOV =
DIVIDE ( [Total Sales], [Completed Orders] )

-- Profit
Total Cost =
CALCULATE (
    SUMX ( fact_sales, fact_sales[quantity] * RELATED ( dim_products[unit_cost] ) ),
    fact_order_process[order_status] = "Completed"
)
Total Profit     = [Total Sales] - [Total Cost]
Profit Margin %  = DIVIDE ( [Total Profit], [Total Sales] )

-- YoY
YoY Sales Growth % =
VAR CurrentYear = [Total Sales]
VAR PriorYear   =
    CALCULATE ( [Total Sales], SAMEPERIODLASTYEAR ( dim_date[Date] ) )
RETURN
    DIVIDE ( CurrentYear - PriorYear, PriorYear )

-- Fulfilment (uses an inactive relationship)
Fulfilment Days =
CALCULATE (
    AVERAGEX (
        fact_order_process,
        DATEDIFF ( fact_order_process[order_date],
                   fact_order_process[delivery_date], DAY )
    ),
    USERELATIONSHIP ( dim_date[Date], fact_order_process[delivery_date] )
)
```

---

## ✅ Validation & Quality Gates

Seven checks run automatically as part of `run_all.sql` (via
`99_validation.sql`). Any failure means the pipeline is broken and the
model should not be refreshed.

| # | Check | Expected |
| :- | :--- | :--- |
| 1 | Total transacted revenue (all orders) | ≈ $48,150,640 |
| 2 | Total revenue (completed only) | ≈ $44,000,000 |
| 3 | `fact_order_process` row count = distinct `order_id` | Identical |
| 4 | `dim_date` span | 2022-01-01 → 2025-12-31, 1,461 rows |
| 5 | Orphan products in `fact_sales` | **0** |
| 6 | `sec` row count = `security` row count | Identical |
| 7 | `order_id` collisions across yearly tables | **0 rows** |

Run the validation block independently:

```bash
mysql -u "$MERIDIAN_DB_USER" -p "$MERIDIAN_DB_NAME" < sql/99_validation.sql
```

---

## 🧠 Design Decisions

A few choices that shaped the project, and why:

**Views, not materialized tables.** The star-schema objects are views
over the raw tables. Simpler to refresh, no storage duplication, and
MySQL pushes predicates down to the base indexes so performance stays
good. If refresh time ever becomes a problem, `fact_sales` and
`fact_order_process` can be swapped for physical tables without
changing the Power BI connection.

**`dim_date` is a physical table exposed via a view.** Date spines
shouldn't be computed on every refresh. A precomputed table means no
`CALENDARAUTO()` surprises, no dead years before 2022 or after 2025,
and no scanning cost.

**Product key = `product_id + year`.** A surrogate that changes when
the price changes, so the fact table naturally joins to the correct
year's cost and price. No Type-2 dimension needed.

**Two facts, not one.** Order-header and order-line grains live in
separate facts. Merging them in Power Query is the classic source of
double-counted revenue; keeping them separate means each measure
targets the correct grain explicitly.

**`Security` is disconnected.** It exists to drive RLS via
`USERPRINCIPALNAME()`, not to be a dimension. Any physical relationship
would create ambiguous filter paths and break the RLS design.

**Explicit column lists everywhere except `sec`.** Views that use
`SELECT *` silently change shape when the base table does. Every view
in this repo lists its columns explicitly, except `sec`, which is a
deliberate pass-through and documented as such.

---

## ⚠️ Known Assumptions

1. **`order_id` is globally unique across the four yearly `Orders_` tables.**
   If it isn't, `fact_sales` and `fact_order_process` will double-count.
   Validation query #7 detects this.
2. **`discount_pct` is a fraction** (0.10 = 10%), not a percentage integer.
3. **The order year equals the product's effective year.** `fact_sales`
   builds `product_key` from the order year, so it must match the year
   `dim_products` uses.
4. **`DayOfWeekNo` follows MySQL `DAYOFWEEK`** (1 = Sunday … 7 = Saturday).
   Adjust in DAX if you need Power BI's Monday = 1 convention.
5. **`security` schema is stable.** The `sec` view uses `SELECT *`; if
   the schema changes, update the view or list columns explicitly.
6. **Budget has no category-level relationship.** `Budget[category]`
   is present in the source but is not connected to `dim_products`.
   Budget vs actuals is therefore time-only, not category-level.

---

## 🗺 Roadmap

- [ ] CI workflow that runs `make validate` on every push
- [ ] Incremental load mode for the Python loader (append-only)
- [ ] Data dictionary auto-generated from `information_schema`
- [ ] Power BI deployment pipeline (`.pbix` → Power BI Service)
- [ ] Category-level budget vs actuals (requires `dim_category` view)
- [ ] Row-level security demo with sample user roles
- [ ] Incremental refresh policy on `fact_sales` for large-scale deployments

---

## 👤 Author

**Samuel Boye Abrokwa**
Built as a portfolio project demonstrating end-to-end data pipeline
design, star-schema modelling, and Power BI delivery.

📫 Reach out via [GitHub Issues](https://github.com/<your-username>/meridian-order-to-cash-analytics/issues)
for questions, bugs, or feature requests.

---

## 📜 License

Released under the **MIT License**. See [`LICENSE`](LICENSE) for details.

---

<p align="center">
  <sub>Built with ☕ and a healthy respect for grain separation.</sub>
</p>
