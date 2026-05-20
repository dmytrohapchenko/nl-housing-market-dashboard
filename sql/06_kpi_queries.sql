USE nl_housing_market;

-- KPI Query 1: Quarterly house price index trend.
-- Output grain: one row per quarter.
SELECT
    d.year_quarter,
    d.year_quarter_sort,
    ROUND(AVG(f.house_price_index), 2) AS avg_house_price_index
FROM fact_housing_market AS f
JOIN dim_date AS d
    ON f.date_key = d.date_key
JOIN dim_region AS r
    ON f.region_id = r.region_id
GROUP BY
    d.year_quarter,
    d.year_quarter_sort
ORDER BY
    d.year_quarter_sort ASC;

-- KPI Query 2: Top 10 regions by YoY house price growth in the latest quarter.
-- Output grain: one row per region.
WITH latest_quarter AS (
    SELECT
        MAX(date_key) AS date_key
    FROM fact_housing_market
)
SELECT
    r.region_code,
    d.year_quarter,
    f.house_price_index,
    f.price_index_yoy_pct
FROM fact_housing_market AS f
JOIN latest_quarter AS lq
    ON f.date_key = lq.date_key
JOIN dim_date AS d
    ON f.date_key = d.date_key
JOIN dim_region AS r
    ON f.region_id = r.region_id
ORDER BY
    f.price_index_yoy_pct DESC
LIMIT 10;

-- KPI Query 3: Bottom 10 regions by QoQ house price change in the latest quarter.
-- Output grain: one row per region.
WITH latest_quarter AS (
    SELECT
        MAX(date_key) AS date_key
    FROM fact_housing_market
)
SELECT
    r.region_code,
    d.year_quarter,
    f.house_price_index,
    f.price_index_qoq_pct
FROM fact_housing_market AS f
JOIN latest_quarter AS lq
    ON f.date_key = lq.date_key
JOIN dim_date AS d
    ON f.date_key = d.date_key
JOIN dim_region AS r
    ON f.region_id = r.region_id
ORDER BY
    f.price_index_qoq_pct ASC
LIMIT 10;

-- KPI Query 4: Top regions by sold dwellings in the latest quarter.
-- Output grain: one row per region.
WITH latest_quarter AS (
    SELECT
        MAX(date_key) AS date_key
    FROM fact_housing_market
)
SELECT
    r.region_code,
    d.year_quarter,
    f.sold_dwellings
FROM fact_housing_market AS f
JOIN latest_quarter AS lq
    ON f.date_key = lq.date_key
JOIN dim_date AS d
    ON f.date_key = d.date_key
JOIN dim_region AS r
    ON f.region_id = r.region_id
ORDER BY
    f.sold_dwellings DESC
LIMIT 10;

-- KPI Query 5: Regional average purchase price comparison in the latest quarter.
-- Output grain: one row per region.
WITH latest_quarter AS (
    SELECT
        MAX(date_key) AS date_key
    FROM fact_housing_market
),
national_average AS (
    SELECT
        f.date_key,
        AVG(f.average_purchase_price) AS national_avg_purchase_price
    FROM fact_housing_market AS f
    JOIN latest_quarter AS lq
        ON f.date_key = lq.date_key
    GROUP BY
        f.date_key
)
SELECT
    r.region_code,
    d.year_quarter,
    f.average_purchase_price,
    ROUND(na.national_avg_purchase_price, 2) AS national_avg_purchase_price,
    ROUND(f.average_purchase_price - na.national_avg_purchase_price, 2) AS difference_from_average
FROM fact_housing_market AS f
JOIN latest_quarter AS lq
    ON f.date_key = lq.date_key
JOIN national_average AS na
    ON f.date_key = na.date_key
JOIN dim_date AS d
    ON f.date_key = d.date_key
JOIN dim_region AS r
    ON f.region_id = r.region_id
ORDER BY
    difference_from_average DESC
LIMIT 20;

-- KPI Query 6: Regions above or below average house price index in the latest quarter.
-- Output grain: one row per region.
WITH latest_quarter AS (
    SELECT
        MAX(date_key) AS date_key
    FROM fact_housing_market
),
average_index AS (
    SELECT
        f.date_key,
        AVG(f.house_price_index) AS average_house_price_index
    FROM fact_housing_market AS f
    JOIN latest_quarter AS lq
        ON f.date_key = lq.date_key
    GROUP BY
        f.date_key
)
SELECT
    r.region_code,
    d.year_quarter,
    f.house_price_index,
    ROUND(ai.average_house_price_index, 2) AS average_house_price_index,
    ROUND(f.house_price_index - ai.average_house_price_index, 2) AS difference_from_average,
    CASE
        WHEN f.house_price_index >= ai.average_house_price_index THEN 'Above average'
        ELSE 'Below average'
    END AS market_position
FROM fact_housing_market AS f
JOIN latest_quarter AS lq
    ON f.date_key = lq.date_key
JOIN average_index AS ai
    ON f.date_key = ai.date_key
JOIN dim_date AS d
    ON f.date_key = d.date_key
JOIN dim_region AS r
    ON f.region_id = r.region_id
ORDER BY
    difference_from_average DESC;

-- KPI Query 7: Share of national sold dwellings by region in the latest quarter.
-- Output grain: one row per region.
WITH latest_quarter AS (
    SELECT
        MAX(date_key) AS date_key
    FROM fact_housing_market
),
national_total AS (
    SELECT
        f.date_key,
        SUM(f.sold_dwellings) AS total_sold_dwellings
    FROM fact_housing_market AS f
    JOIN latest_quarter AS lq
        ON f.date_key = lq.date_key
    GROUP BY
        f.date_key
)
SELECT
    r.region_code,
    d.year_quarter,
    f.sold_dwellings,
    nt.total_sold_dwellings,
    ROUND(
        100 * f.sold_dwellings / NULLIF(nt.total_sold_dwellings, 0),
        2
    ) AS sold_dwellings_share_pct
FROM fact_housing_market AS f
JOIN latest_quarter AS lq
    ON f.date_key = lq.date_key
JOIN national_total AS nt
    ON f.date_key = nt.date_key
JOIN dim_date AS d
    ON f.date_key = d.date_key
JOIN dim_region AS r
    ON f.region_id = r.region_id
ORDER BY
    sold_dwellings_share_pct DESC;

-- KPI Query 8: Latest quarter reporting snapshot.
-- Output grain: one row per region.
WITH latest_quarter AS (
    SELECT
        MAX(date_key) AS date_key
    FROM fact_housing_market
)
SELECT
    r.region_code,
    d.year_quarter,
    f.house_price_index,
    f.price_index_qoq_pct,
    f.price_index_yoy_pct,
    f.sold_dwellings,
    f.sold_dwellings_qoq_pct,
    f.sold_dwellings_yoy_pct,
    f.average_purchase_price,
    f.total_purchase_value
FROM fact_housing_market AS f
JOIN latest_quarter AS lq
    ON f.date_key = lq.date_key
JOIN dim_date AS d
    ON f.date_key = d.date_key
JOIN dim_region AS r
    ON f.region_id = r.region_id
ORDER BY
    f.house_price_index DESC;
