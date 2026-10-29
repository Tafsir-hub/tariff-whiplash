USE tariff_whiplash;
-- Note: Census country codes include totals and regional groupings.
-- Individual countries use 4-digit codes starting 1-7; check the code list and adjust this filter.

-- 1. Timeline: total monthly imports
SELECT period, SUM(gen_val) / 1e9 AS imports_bn
FROM imports_country
WHERE cty_code REGEXP '^[1-7][0-9]{3}$'
GROUP BY period ORDER BY period;

-- 2. Sourcing shift: each country's share of monthly imports
WITH monthly AS (
    SELECT period, cty_name, SUM(gen_val) AS val
    FROM imports_country
    WHERE cty_code REGEXP '^[1-7][0-9]{3}$'
    GROUP BY period, cty_name
)
SELECT period, cty_name, val,
       ROUND(100 * val / SUM(val) OVER (PARTITION BY period), 2) AS share_pct
FROM monthly
ORDER BY period, val DESC;

-- 3. Products: change by HS chapter, 2024 vs. 2026 (same months)
SELECT hs2, hs2_desc,
       SUM(CASE WHEN period LIKE '2024-%' THEN gen_val END) / 1e9 AS y2024_bn,
       SUM(CASE WHEN period LIKE '2026-%' THEN gen_val END) / 1e9 AS y2026_bn
FROM imports_country
WHERE cty_code REGEXP '^[1-7][0-9]{3}$'
  AND RIGHT(period, 2) <= (SELECT RIGHT(MAX(period), 2) FROM imports_country WHERE period LIKE '2026-%')
GROUP BY hs2, hs2_desc
ORDER BY (y2026_bn - y2024_bn);

-- 4. Effective duty rate by country and month (duty / consumption value)
SELECT period, cty_name,
       ROUND(100 * SUM(cal_duty) / NULLIF(SUM(con_val), 0), 2) AS eff_duty_pct
FROM imports_country
WHERE cty_code REGEXP '^[1-7][0-9]{3}$'
GROUP BY period, cty_name
HAVING SUM(con_val) > 1e9
ORDER BY cty_name, period;

-- 5. Ports: containerized import value by port and month
SELECT period, port_name, SUM(cnt_val) / 1e9 AS container_val_bn
FROM imports_port
GROUP BY period, port_name
ORDER BY period, container_val_bn DESC;

-- 6. Pull-forward check: month-over-month change in total imports
WITH totals AS (
    SELECT period, SUM(gen_val) AS val
    FROM imports_country WHERE cty_code REGEXP '^[1-7][0-9]{3}$'
    GROUP BY period
)
SELECT period, val / 1e9 AS imports_bn,
       ROUND(100 * (val - LAG(val) OVER (ORDER BY period)) / LAG(val) OVER (ORDER BY period), 1) AS mom_pct
FROM totals ORDER BY period;
