USE nl_housing_market;

-- Source Check 1: Confirm the raw source table has rows loaded.
SELECT
    COUNT(*) AS raw_rows
FROM raw_housing_corop;

-- Source Check 2: Review the raw reporting coverage before staging filters are applied.
SELECT
    MIN(LEFT(period_code_raw, 4)) AS first_year,
    MAX(LEFT(period_code_raw, 4)) AS last_year,
    COUNT(DISTINCT period_code_raw) AS period_count,
    COUNT(DISTINCT region_code_raw) AS region_count
FROM raw_housing_corop;

-- Source Check 3: Confirm the expected portfolio reporting window exists in the raw data.
SELECT
    LEFT(period_code_raw, 4) AS year_num,
    COUNT(DISTINCT period_code_raw) AS quarters_available,
    COUNT(*) AS raw_rows
FROM raw_housing_corop
WHERE CAST(LEFT(period_code_raw, 4) AS UNSIGNED) BETWEEN 2020 AND 2025
GROUP BY
    LEFT(period_code_raw, 4)
ORDER BY
    year_num;

-- Source Check 4: Detect duplicate source records at the intended grain.
-- Expected result: no rows returned.
SELECT
    region_code_raw,
    period_code_raw,
    COUNT(*) AS duplicate_count
FROM raw_housing_corop
GROUP BY
    region_code_raw,
    period_code_raw
HAVING COUNT(*) > 1;

-- Source Check 5: Detect missing key fields needed for the reporting model.
-- Expected result: 0.
SELECT
    COUNT(*) AS rows_with_missing_keys
FROM raw_housing_corop
WHERE TRIM(COALESCE(region_code_raw, '')) = ''
   OR TRIM(COALESCE(period_code_raw, '')) = '';

-- Source Check 6: Detect period codes that cannot be interpreted as year and quarter.
-- Expected result: no rows returned.
SELECT
    period_code_raw,
    COUNT(*) AS row_count
FROM raw_housing_corop
WHERE LEFT(period_code_raw, 4) NOT REGEXP '^[0-9]{4}$'
   OR RIGHT(period_code_raw, 2) NOT REGEXP '^[0-9]{2}$'
   OR CAST(RIGHT(period_code_raw, 2) AS UNSIGNED) NOT BETWEEN 1 AND 4
GROUP BY
    period_code_raw
ORDER BY
    period_code_raw;

-- Source Check 7: Count blank metric values by column before type conversion.
SELECT
    SUM(
        TRIM(COALESCE(price_index_raw, '')) = ''
    ) AS blank_price_index_rows,
    SUM(
        TRIM(COALESCE(sold_dwellings_raw, '')) = ''
    ) AS blank_sold_dwellings_rows,
    SUM(
        TRIM(COALESCE(avg_purchase_price_raw, '')) = ''
    ) AS blank_avg_purchase_price_rows,
    SUM(
        TRIM(COALESCE(total_value_purchase_prices_raw, '')) = ''
    ) AS blank_total_value_rows
FROM raw_housing_corop;

-- Source Check 8: Detect non-numeric values in core reporting metrics.
-- Expected result: no rows returned.
SELECT
    id_raw,
    region_code_raw,
    period_code_raw,
    price_index_raw,
    sold_dwellings_raw,
    avg_purchase_price_raw,
    total_value_purchase_prices_raw
FROM raw_housing_corop
WHERE (
        TRIM(COALESCE(price_index_raw, '')) <> ''
        AND TRIM(price_index_raw) NOT REGEXP '^-?[0-9]+(\\.[0-9]+)?$'
    )
   OR (
        TRIM(COALESCE(sold_dwellings_raw, '')) <> ''
        AND TRIM(sold_dwellings_raw) NOT REGEXP '^-?[0-9]+$'
    )
   OR (
        TRIM(COALESCE(avg_purchase_price_raw, '')) <> ''
        AND TRIM(avg_purchase_price_raw) NOT REGEXP '^-?[0-9]+(\\.[0-9]+)?$'
    )
   OR (
        TRIM(COALESCE(total_value_purchase_prices_raw, '')) <> ''
        AND TRIM(total_value_purchase_prices_raw) NOT REGEXP '^-?[0-9]+(\\.[0-9]+)?$'
    );
