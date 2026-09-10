# Meridian Order-to-Cash Analytics

An end-to-end analytics pipeline for a simulated multi-year office & tech supply distributor — **Python → SQL → Data Modeling → Power BI**, from a raw multi-sheet Excel workbook to a governed star schema and a two-page executive dashboard.

---

## Pipeline

![Pipeline](documents/meridian_pipeline.png)

```
Excel Workbook (Orders/OrderLines 2022-2025, Products, Customers, Budget)
Security.csv (general manager + state supervisor RLS assignments)
        │
        ▼  load_excel.py  (Python + pandas + SQLAlchemy)
MySQL — raw tables, one per source sheet, plus Security imported directly
        │
        ▼  SQL views (Bronze → Gold)
Governed star schema: fact_sales, fact_order_process, dim_products,
dim_customers, dim_city, dim_date
        │
        ▼  ODBC
Power BI — DAX measures, Row-Level Security (via Security table), two-page report
```

---

## Repository Structure

```
meridian-order-to-cash-analytics/
├── python/
│   └── load_excel.py              # Excel → MySQL ingestion
├── scripts/
│   ├── 01_fact_order_process.sql
│   ├── 02_fact_sales.sql
│   ├── 03_dim_products.sql
│   ├── 04_dim_customers.sql
│   ├── 05_dim_city.sql
│   ├── 06_dim_date.sql
│   └── 99_validation.sql          # Run before connecting Power BI
├── documents/
│   ├── data_model.png             # Power BI model view
│   ├── are_we_growing_profitably_dashboard.png
│   └── order_fulfillment_&_operations.png
├── LICENSE
└── README.md
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
![Are We Growing Profitably](documents/are_we_growing_profitably_dashboard.png)

**Page 2 — Order Fulfillment & Operations**
![Order Fulfillment & Operations](documents/order_fulfillment_&_operations.png)

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
