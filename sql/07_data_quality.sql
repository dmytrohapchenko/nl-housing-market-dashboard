USE nl_housing_market;

-- Check 1: Count rows in staging to establish the expected load volume for the final fact table.
SELECT
    COUNT(*) AS staging_rows
FROM stg_housing_market;

-- Check 2: Count rows in the fact table to confirm that all staged records were loaded.
SELECT
    COUNT(*) AS fact_rows
FROM fact_housing_market;

-- Check 3: Detect duplicate records at the fact table grain (one row per region and quarter).
-- Expected result: no rows returned.
SELECT
    date_key,
    region_id,
    COUNT(*) AS cnt
FROM fact_housing_market
GROUP BY
    date_key,
    region_id
HAVING COUNT(*) > 1;

-- Check 4: Detect invalid negative values in metrics that must not be below zero.
-- Expected result: 0.
SELECT
    COUNT(*) AS invalid_negative_rows
FROM fact_housing_market
WHERE house_price_index < 0
   OR price_index_ci_lower < 0
   OR price_index_ci_upper < 0
   OR sold_dwellings < 0
   OR average_purchase_price < 0
   OR total_purchase_value < 0;

-- Check 5: Detect orphan foreign keys in the fact table that do not match dimension records.
-- Expected result: 0.
SELECT
    COUNT(*) AS orphan_rows
FROM fact_housing_market AS f
LEFT JOIN dim_date AS d
    ON f.date_key = d.date_key
LEFT JOIN dim_region AS r
    ON f.region_id = r.region_id
WHERE d.date_key IS NULL
   OR r.region_id IS NULL;

-- Check 6: Verify that each year-quarter appears only once in the date dimension.
-- Expected result: no rows returned.
SELECT
    year_num,
    quarter_num,
    COUNT(*) AS cnt
FROM dim_date
GROUP BY
    year_num,
    quarter_num
HAVING COUNT(*) > 1;

-- Check 7: Verify that each region code appears only once in the region dimension.
-- Expected result: no rows returned.
SELECT
    region_code,
    COUNT(*) AS cnt
FROM dim_region
GROUP BY
    region_code
HAVING COUNT(*) > 1;

-- Check 8: Confirm that the fact table covers the full expected reporting period.
-- Expected result: min_period = 20201 and max_period = 20254.
SELECT
    MIN(d.year_quarter_sort) AS min_period,
    MAX(d.year_quarter_sort) AS max_period
FROM fact_housing_market AS f
JOIN dim_date AS d
    ON f.date_key = d.date_key;
