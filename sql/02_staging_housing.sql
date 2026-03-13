-- Database initialization
USE nl_housing_market;

-- 1. Deleting an old table if it exists
DROP TABLE IF EXISTS stg_housing_market;

-- 2. Creating a hard structure of the table
CREATE TABLE stg_housing_market (
                                    region_code VARCHAR(100),
                                    year_num SMALLINT,
                                    quarter_num TINYINT,
                                    year_quarter CHAR(7),

                                    house_price_index DECIMAL(10, 2),
                                    price_index_ci_lower DECIMAL(10, 2),
                                    price_index_ci_upper DECIMAL(10, 2),
                                    price_index_qoq_pct DECIMAL(6, 2),
                                    price_index_yoy_pct DECIMAL(6, 2),

                                    sold_dwellings INT,
                                    sold_dwellings_qoq_pct DECIMAL(6, 2),
                                    sold_dwellings_yoy_pct DECIMAL(6, 2),

                                    average_purchase_price DECIMAL(12, 2),
                                    total_purchase_value DECIMAL(18, 2)
);

INSERT INTO stg_housing_market
SELECT
    -- Dimensions
    TRIM(region_code_raw) AS region_code,

    -- Parsing Year and Quarter to Numeric Format
    CAST(LEFT(period_code_raw, 4) AS SIGNED) AS year_num,
    CAST(RIGHT(period_code_raw, 2) AS SIGNED) AS quarter_num,
    CONCAT(LEFT(period_code_raw, 4), '-Q', RIGHT(period_code_raw, 1)) AS year_quarter,

    -- Absolute Metrics
    CAST(NULLIF(TRIM(price_index_raw), '') AS DECIMAL(10, 2)) AS house_price_index,
    CAST(NULLIF(TRIM(price_index_ci_lower_raw), '') AS DECIMAL(10, 2)) AS price_index_ci_lower,
    CAST(NULLIF(TRIM(price_index_ci_upper_raw), '') AS DECIMAL(10, 2)) AS price_index_ci_upper,

    -- Percentages
    CAST(NULLIF(TRIM(price_index_prev_period_pct_raw), '') AS DECIMAL(6, 2)) AS price_index_qoq_pct,
    CAST(NULLIF(TRIM(price_index_yoy_pct_raw), '') AS DECIMAL(6, 2)) AS price_index_yoy_pct,

    -- Sold Dwellings
    CAST(NULLIF(TRIM(sold_dwellings_raw), '') AS SIGNED) AS sold_dwellings,
    CAST(NULLIF(TRIM(sold_dwellings_prev_period_pct_raw), '') AS DECIMAL(6, 2)) AS sold_dwellings_qoq_pct,
    CAST(NULLIF(TRIM(sold_dwellings_yoy_pct_raw), '') AS DECIMAL(6, 2)) AS sold_dwellings_yoy_pct,

    -- Financials
    CAST(NULLIF(TRIM(avg_purchase_price_raw), '') AS DECIMAL(12, 2)) AS average_purchase_price,
    CAST(NULLIF(TRIM(total_value_purchase_prices_raw), '') AS DECIMAL(18, 2)) AS total_purchase_value

FROM raw_housing_corop

-- Filters out "Analytical Window" (from 2020 to 2025 year)
WHERE CAST(LEFT(period_code_raw, 4) AS SIGNED) BETWEEN 2020 AND 2025;