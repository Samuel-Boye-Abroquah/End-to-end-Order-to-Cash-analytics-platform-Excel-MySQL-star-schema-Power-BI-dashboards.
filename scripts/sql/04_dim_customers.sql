-- =============================================================================
-- 04_dim_customers.sql
-- Grain: one row per customer.
--
-- Straight pass-through of the Customers source table with columns
-- renamed where needed for model consistency.
-- =============================================================================

DROP VIEW IF EXISTS dim_customers;

CREATE VIEW dim_customers AS
SELECT
    customer_id,
    customer_name,
    segment,
    state,
    city,
    signup_date,
    payment_terms_days
FROM Customers;
