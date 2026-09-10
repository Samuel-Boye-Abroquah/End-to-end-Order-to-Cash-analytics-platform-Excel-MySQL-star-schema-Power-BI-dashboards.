-- =============================================================================
-- 01_fact_order_process.sql
-- Grain: one row per order (header grain).
--
-- Built by UNION ALL-ing the four yearly Orders_ tables. Because each
-- source table is already one row per order, the union preserves that
-- grain — no duplication risk, unlike a merge against OrderLines.
-- =============================================================================
USE meridian_officesupply_ordertocash_2022_2025;
DROP VIEW IF EXISTS fact_order_process;

CREATE VIEW fact_order_process AS

SELECT
    order_id,
    customer_id,
    order_date,
    order_confirmation_date,
    ship_date,
    delivery_date,
    invoice_date,
    payment_date,
    payment_method,
    shipping_state,
    order_status AS status,
    payment_status
FROM Orders_2022

UNION ALL

SELECT
    order_id,
    customer_id,
    order_date,
    order_confirmation_date,
    ship_date,
    delivery_date,
    invoice_date,
    payment_date,
    payment_method,
    shipping_state,
    order_status AS status,
    payment_status
FROM Orders_2023

UNION ALL

SELECT
    order_id,
    customer_id,
    order_date,
    order_confirmation_date,
    ship_date,
    delivery_date,
    invoice_date,
    payment_date,
    payment_method,
    shipping_state,
    order_status AS status,
    payment_status
FROM Orders_2024

UNION ALL

SELECT
    order_id,
    customer_id,
    order_date,
    order_confirmation_date,
    ship_date,
    delivery_date,
    invoice_date,
    payment_date,
    payment_method,
    shipping_state,
    order_status AS status,
    payment_status
FROM Orders_2025;
