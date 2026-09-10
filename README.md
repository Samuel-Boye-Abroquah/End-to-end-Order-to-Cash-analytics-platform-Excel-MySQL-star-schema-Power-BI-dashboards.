# Meridian Order-to-Cash Analytics

An end-to-end analytics pipeline for a simulated multi-year office & tech supply distributor — **Python → SQL → Data Modeling → Power BI**, from a raw multi-sheet Excel workbook to a governed star schema and a two-page executive dashboard.

---

## Pipeline

![Pipeline](Documents/meridian_pipeline.png)

---

## 📂 Repository Structure

```
End-to-End-Order-to-Cash-Analytics-Platform/
│
├── Dataset/
│   ├── Meridian_OfficeSupply_OrderToCash_2022-2025.xlsx
│   └── security.csv
│
├── python/
│   └── load_excel.py                 # Excel-to-MySQL ingestion script
│
├── sql/
│   ├── 01_fact_order_process.sql     # Order fulfillment fact table
│   ├── 02_fact_sales.sql             # Sales fact table
│   ├── 03_dim_products.sql           # Product dimension
│   ├── 04_dim_customers.sql          # Customer dimension
│   ├── 05_dim_city.sql               # City dimension
│   ├── 06_dim_date.sql               # Date dimension
│   └── 99_validation.sql            # Data quality and validation checks
│
├── Documents/
│   ├── data_model.png               # Star schema data model
│   ├── meridian_pipeline.png        # End-to-end data pipeline
│   ├── are-we-growing-profitably-dashboard.png
│   └── order-fulfillment-operations-dashboard.png
│
├── README.md
└── LICENSE
```

---

## Data Model

![Data Model](documents/data_model.png)

- **`fact_sales`** — line-item grain, one row per order line
- **`fact_order_process`** — order grain, an accumulating-snapshot fact table tracking the full order → confirmation → ship → deliver → invoice → payment lifecycle
- **`dim_products`** — one row per product per year (yearly cost/price unpivoted; price is never part of the product's identity key)
- **`dim_customers`**, **`dim_city`** — customer and geography dimensions
- **`dim_date`** — materialized calendar table, explicit 2022–2025 range (not `CALENDARAUTO()`)

Row-Level Security is applied dynamically via a `Security` table (imported directly from CSV — a general manager scoped to all states, and individual supervisors each scoped to their own state), matched against the logged-in user's email.

`fact_order_process`'s status column is aliased to `status` at the SQL source (from the raw `order_status` column) — so the field name is consistent from the database straight through to every DAX measure, with no silent rename happening only inside Power BI.

---

## Validation

`scripts/99_validation.sql` runs 7 sanity checks — row counts, revenue totals against known reference figures, orphan-key checks, and an order-ID collision check across the yearly source tables. **Run this before connecting Power BI** — it's the difference between trusting the model and hoping it's right.

---

## Dashboard

**Page 1 — Are We Growing Profitably?**
![Are We Growing Profitably](Documents/are-we-growing-profitably-dashboard.png)

**Page 2 — Order Fulfillment & Operations**
![Order Fulfillment & Operations](Documents/order-fulfillment-and-operations-dashboard.png)

---

## Tools & Technologies

| Layer | Tools |
|---|---|
| Ingestion | Python (pandas, SQLAlchemy) |
| Database | MySQL 8 |
| Modeling | SQL views, surrogate keys, recursive CTEs |
| Reporting | Power BI (DAX, dynamic Row-Level Security, ODBC) |

---

## How to Run

1. Edit `python/load_excel.py` with your own MySQL credentials (never commit real credentials).
2. Run `python load_excel.py` to load the raw workbook into MySQL.
3. Run `scripts/01` through `scripts/06` in order to build the star schema.
4. Run `scripts/99_validation.sql` — confirm every check passes before proceeding.
5. Connect Power BI Desktop via ODBC and build measures/report on top of the views.

---

## About

Built by **Samuel Boye Abroquah** — Quality Assurance & Data Analytics professional.

[LinkedIn](https://linkedin.com/in/Samuel-Boye-Abroquah)
