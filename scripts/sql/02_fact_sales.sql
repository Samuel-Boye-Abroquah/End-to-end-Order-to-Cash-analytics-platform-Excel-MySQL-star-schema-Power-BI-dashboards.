-- =============================================================================
-- 02_fact_sales.sql
-- Grain: one row per order line (line-item grain).
--
-- Combines the four yearly OrderLines_ tables, joins each line back to its
-- order to obtain the order's year, and derives product_key in the same
-- format dim_products uses (product_id + '-' + year).
--
-- sales is the actual transacted amount:
--     quantity * unit_price * (1 - discount_pct)
-- never a catalog/list price.
--
-- Assumption: discount_pct is a fraction (0.10 = 10%).
-- Assumption: order_date's year == the product's effective year.
-- =============================================================================

DROP VIEW IF EXISTS fact_sales;

CREATE VIEW fact_sales AS
SELECT
    ol.order_id,
    ol.line_number,
    ol.product_id,
    CONCAT(ol.product_id, '-', YEAR(o.order_date)) AS product_key,
    ol.quantity,
    ol.unit_price,
    ol.discount_pct,
    ROUND(ol.quantity * ol.unit_price * (1 - ol.discount_pct), 2) AS sales
FROM (
    SELECT order_id, line_number, product_id, quantity, unit_price, discount_pct
    FROM OrderLines_2022

    UNION ALL

    SELECT order_id, line_number, product_id, quantity, unit_price, discount_pct
    FROM OrderLines_2023

    UNION ALL

    SELECT order_id, line_number, product_id, quantity, unit_price, discount_pct
    FROM OrderLines_2024

    UNION ALL

    SELECT order_id, line_number, product_id, quantity, unit_price, discount_pct
    FROM OrderLines_2025
) AS ol
INNER JOIN (
    SELECT order_id, order_date FROM Orders_2022
    UNION ALL
    SELECT order_id, order_date FROM Orders_2023
    UNION ALL
    SELECT order_id, order_date FROM Orders_2024
    UNION ALL
    SELECT order_id, order_date FROM Orders_2025
) AS o
    ON ol.order_id = o.order_id;
