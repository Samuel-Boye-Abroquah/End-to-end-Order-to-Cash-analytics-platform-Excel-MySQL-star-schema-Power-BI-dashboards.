-- =============================================================================
-- 04_dim_customers.sql
-- Grain: one row per customer.
--
-- Exposes the state in two forms side by side:
--   state_initials  -> two-letter code   ("KY")
--   state           -> full state name   ("Kentucky")
--
-- The abbreviation -> full-name mapping is written once, in a subquery,
-- so it isn't duplicated across the two output columns.
-- =============================================================================

DROP VIEW IF EXISTS dim_customers;

CREATE VIEW dim_customers AS
SELECT
    customer_id,
    customer_name,
    segment,
    LOWER(TRIM(state_raw))  AS state_initials,
    CASE UPPER(TRIM(state_raw))
        WHEN 'AL' THEN 'Alabama'
        WHEN 'AK' THEN 'Alaska'
        WHEN 'AZ' THEN 'Arizona'
        WHEN 'AR' THEN 'Arkansas'
        WHEN 'CA' THEN 'California'
        WHEN 'CO' THEN 'Colorado'
        WHEN 'CT' THEN 'Connecticut'
        WHEN 'DE' THEN 'Delaware'
        WHEN 'FL' THEN 'Florida'
        WHEN 'GA' THEN 'Georgia'
        WHEN 'HI' THEN 'Hawaii'
        WHEN 'ID' THEN 'Idaho'
        WHEN 'IL' THEN 'Illinois'
        WHEN 'IN' THEN 'Indiana'
        WHEN 'IA' THEN 'Iowa'
        WHEN 'KS' THEN 'Kansas'
        WHEN 'KY' THEN 'Kentucky'
        WHEN 'LA' THEN 'Louisiana'
        WHEN 'ME' THEN 'Maine'
        WHEN 'MD' THEN 'Maryland'
        WHEN 'MA' THEN 'Massachusetts'
        WHEN 'MI' THEN 'Michigan'
        WHEN 'MN' THEN 'Minnesota'
        WHEN 'MS' THEN 'Mississippi'
        WHEN 'MO' THEN 'Missouri'
        WHEN 'MT' THEN 'Montana'
        WHEN 'NE' THEN 'Nebraska'
        WHEN 'NV' THEN 'Nevada'
        WHEN 'NH' THEN 'New Hampshire'
        WHEN 'NJ' THEN 'New Jersey'
        WHEN 'NM' THEN 'New Mexico'
        WHEN 'NY' THEN 'New York'
        WHEN 'NC' THEN 'North Carolina'
        WHEN 'ND' THEN 'North Dakota'
        WHEN 'OH' THEN 'Ohio'
        WHEN 'OK' THEN 'Oklahoma'
        WHEN 'OR' THEN 'Oregon'
        WHEN 'PA' THEN 'Pennsylvania'
        WHEN 'RI' THEN 'Rhode Island'
        WHEN 'SC' THEN 'South Carolina'
        WHEN 'SD' THEN 'South Dakota'
        WHEN 'TN' THEN 'Tennessee'
        WHEN 'TX' THEN 'Texas'
        WHEN 'UT' THEN 'Utah'
        WHEN 'VT' THEN 'Vermont'
        WHEN 'VA' THEN 'Virginia'
        WHEN 'WA' THEN 'Washington'
        WHEN 'WV' THEN 'West Virginia'
        WHEN 'WI' THEN 'Wisconsin'
        WHEN 'WY' THEN 'Wyoming'
        ELSE TRIM(state_raw)
    END AS state,
    city,
    signup_date,
    payment_terms_days
FROM (
    SELECT
        customer_id,
        customer_name,
        segment,
        state       AS state_raw,
        city,
        signup_date,
        payment_terms_days
    FROM Customers
) AS c;
