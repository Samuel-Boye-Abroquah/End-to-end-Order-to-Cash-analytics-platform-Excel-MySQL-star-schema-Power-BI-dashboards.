-- =============================================================================
-- 05_dim_city.sql
-- Grain: one row per distinct (city, state) pair.
--
-- Surrogate key city_key is assigned deterministically by ordering on
-- (state, city).
-- =============================================================================

DROP VIEW IF EXISTS dim_city;

CREATE VIEW dim_city AS
SELECT
    ROW_NUMBER() OVER (ORDER BY state, city) AS city_key,
    city,
    state
FROM (
    SELECT DISTINCT city, state
    FROM Customers
) AS c;
