-- Tariff Whiplash: MySQL schema
CREATE DATABASE IF NOT EXISTS tariff_whiplash;
USE tariff_whiplash;

-- Monthly imports by country and HS chapter
CREATE TABLE IF NOT EXISTS imports_country (
    cty_code      VARCHAR(4),
    cty_name      VARCHAR(100),
    hs2           VARCHAR(2),
    hs2_desc      VARCHAR(100),
    gen_val       BIGINT,   -- general imports value (USD)
    con_val       BIGINT,   -- imports for consumption value (USD)
    cal_duty      BIGINT,   -- calculated duty (USD)
    period        CHAR(7),  -- YYYY-MM
    INDEX (period), INDEX (cty_code), INDEX (hs2)
);

-- Monthly imports by U.S. port and HS chapter
CREATE TABLE IF NOT EXISTS imports_port (
    port          VARCHAR(4),
    port_name     VARCHAR(100),
    hs2           VARCHAR(2),
    gen_val       BIGINT,
    cnt_val       BIGINT,   -- containerized vessel value (USD)
    cnt_wgt       BIGINT,   -- containerized vessel weight (kg)
    period        CHAR(7),
    INDEX (period), INDEX (port)
);

-- Policy events for annotations
CREATE TABLE IF NOT EXISTS policy_events (
    event_date DATE,
    event      VARCHAR(255),
    scope      VARCHAR(100),
    status     VARCHAR(20),
    source     VARCHAR(255)
);

-- Load CSVs (enable local_infile, adjust paths to your machine).
-- Column order must match the CSV header written by fetch_census.py; check it first.
-- LOAD DATA LOCAL INFILE 'data/raw/imports_country_hs2.csv' INTO TABLE imports_country
--   FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 LINES
--   (cty_code, cty_name, hs2, hs2_desc, gen_val, con_val, cal_duty, @skip, period);
