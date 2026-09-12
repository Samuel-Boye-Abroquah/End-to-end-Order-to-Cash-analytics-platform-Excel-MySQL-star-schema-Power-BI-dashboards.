-- =============================================================================
-- 99_validation.sql
-- Seven sanity checks. Run after all objects are created, before
-- connecting Power BI. Every check documents its expected result.
--
-- If a check returns something unexpected, STOP and resolve it. Do not
-- connect Power BI to a schema that hasn't passed validation.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. Total transacted revenue, ALL orders. Expect ≈ 48,150,000.
-- -----------------------------------------------------------------------------
SELECT ROUND(SUM(sales), 2) AS total_sales_all_orders
FROM fact_sales;

-- -----------------------------------------------------------------------------
-- 2. Revenue from COMPLETED orders only. Expect ≈ 44,000,000.
-- -----------------------------------------------------------------------------
SELECT ROUND(SUM(fs.sales), 2) AS total_sales_completed
FROM fact_sales AS fs
INNER JOIN fact_order_process AS fop
    ON fs.order_id = fop.order_id
WHERE fop.status = 'Completed';

-- -----------------------------------------------------------------------------
-- 3. fact_order_process row-count sanity. Expect ~18,550 rows and the two
--    counts to be IDENTICAL. A gap means order_id is duplicated.
-- -----------------------------------------------------------------------------
SELECT
    COUNT(*)                  AS total_orders,
    COUNT(DISTINCT order_id)  AS distinct_orders
FROM fact_order_process;

-- -----------------------------------------------------------------------------
-- 4. dim_date span. Expect 2022-01-01 / 2025-12-31 / 1461.
-- -----------------------------------------------------------------------------
SELECT
    MIN(`Date`)  AS first_date,
    MAX(`Date`)  AS last_date,
    COUNT(*)     AS total_days
FROM dim_date;

-- -----------------------------------------------------------------------------
-- 5. Orphan-product check. Expect 0.
-- -----------------------------------------------------------------------------
SELECT COUNT(*) AS orphan_product_rows
FROM fact_sales AS fs
LEFT JOIN dim_products AS dp
    ON fs.product_key = dp.product_key
WHERE dp.product_key IS NULL;

-- -----------------------------------------------------------------------------
-- 6. Order ID collision check across the four yearly Orders_ tables.
--    Expect ZERO rows. Any row returned means an order_id appears in more
--    than one yearly table, which double-counts fact_sales and
--    fact_order_process. Fix before using the model.
-- -----------------------------------------------------------------------------
SELECT
    order_id,
    COUNT(*) AS occurrences
FROM (
    SELECT order_id FROM Orders_2022
    UNION ALL
    SELECT order_id FROM Orders_2023
    UNION ALL
    SELECT order_id FROM Orders_2024
    UNION ALL
    SELECT order_id FROM Orders_2025
) AS t
GROUP BY order_id
HAVING COUNT(*) > 1;

-- -----------------------------------------------------------------------------
-- 7. Security table sanity check. Expect the two counts to be IDENTICAL —
--    a gap means the same email is assigned more than once, which would
--    make Row-Level Security ambiguous for that user.
-- -----------------------------------------------------------------------------
SELECT COUNT(*) AS total_security_rows, COUNT(DISTINCT Email) AS distinct_emails
FROM Security;

