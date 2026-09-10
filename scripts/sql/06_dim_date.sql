-- =============================================================================
-- 06_dim_date.sql
-- Grain: one row per calendar day, 2022-01-01 through 2025-12-31.
--
-- Built as a physical table (dim_date_tbl) so the date spine is
-- materialized once, then exposed via a pass-through VIEW named
-- dim_date — the name Power BI connects to.
--
-- This replaces CALENDARAUTO(), which scans the whole model and can
-- introduce dead years before or after the actual data range.
--
-- DayOfWeekNo follows MySQL's DAYOFWEEK: 1 = Sunday … 7 = Saturday.
-- =============================================================================

-- Recursion depth must cover the full date range. 2022-01-01 through
-- 2025-12-31 is 1,461 days; MySQL's default of 1,000 is not enough.
-- SET SESSION is placed here (not in 00_setup.sql) so this file works
-- standalone, even when executed statement-by-statement in a new
-- connection per statement (e.g. MySQL Workbench's single-statement
-- Execute button).
SET SESSION cte_max_recursion_depth = 5000;

-- Tear down any prior version so this script is idempotent.
DROP VIEW  IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_date_tbl;

-- ---------------------------------------------------------------------------
-- Physical date spine
-- ---------------------------------------------------------------------------
CREATE TABLE dim_date_tbl (
    `Date`      DATE         NOT NULL,
    `Year`      INT          NOT NULL,
    MonthNo     INT          NOT NULL,
    MonthName   VARCHAR(10)  NOT NULL,
    Quarter     VARCHAR(2)   NOT NULL,
    DayOfWeekNo INT          NOT NULL,
    DayName     VARCHAR(10)  NOT NULL,
    PRIMARY KEY (`Date`)
) ENGINE = InnoDB;

INSERT INTO dim_date_tbl (
    `Date`, `Year`, MonthNo, MonthName, Quarter, DayOfWeekNo, DayName
)
WITH RECURSIVE seq AS (
    SELECT DATE('2022-01-01') AS d
    UNION ALL
    SELECT d + INTERVAL 1 DAY
    FROM seq
    WHERE d < '2025-12-31'
)
SELECT
    d,
    YEAR(d),
    MONTH(d),
    MONTHNAME(d),
    CONCAT('Q', QUARTER(d)),
    DAYOFWEEK(d),
    DAYNAME(d)
FROM seq;

-- ---------------------------------------------------------------------------
-- Power BI-facing view
-- ---------------------------------------------------------------------------
CREATE VIEW dim_date AS
SELECT
    `Date`,
    `Year`,
    MonthNo,
    MonthName,
    Quarter,
    DayOfWeekNo,
    DayName
FROM dim_date_tbl;
