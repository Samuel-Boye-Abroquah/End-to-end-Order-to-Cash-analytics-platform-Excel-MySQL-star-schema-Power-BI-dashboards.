-- =============================================================================
-- 03_dim_products.sql
-- Grain: one row per product per year.
--
-- Unpivots the four yearly cost/price column pairs into rows. Each row
-- carries that year's unit_cost and unit_price.
--
-- product_key matches fact_sales.product_key exactly. Cost and price are
-- NEVER part of the key — only product_id + product_year.
--
-- Column is named `product_year` rather than `year` to avoid friction
-- with the YEAR() reserved function in downstream SQL.
-- =============================================================================

DROP VIEW IF EXISTS dim_products;

CREATE VIEW dim_products AS
SELECT
    CONCAT(product_id, '-', 2022) AS product_key,
    product_id,
    product_name,
    category,
    subcategory,
    2022               AS product_year,
    unit_cost_2022     AS unit_cost,
    unit_price_2022    AS unit_price
FROM Products

UNION ALL

SELECT
    CONCAT(product_id, '-', 2023),
    product_id,
    product_name,
    category,
    subcategory,
    2023,
    unit_cost_2023,
    unit_price_2023
FROM Products

UNION ALL

SELECT
    CONCAT(product_id, '-', 2024),
    product_id,
    product_name,
    category,
    subcategory,
    2024,
    unit_cost_2024,
    unit_price_2024
FROM Products

UNION ALL

SELECT
    CONCAT(product_id, '-', 2025),
    product_id,
    product_name,
    category,
    subcategory,
    2025,
    unit_cost_2025,
    unit_price_2025
FROM Products;
