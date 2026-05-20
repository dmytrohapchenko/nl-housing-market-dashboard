USE nl_housing_market;

-- KPI Query 1: Quarterly house price trend.
-- Shows the national average house price index by quarter.
SELECT
    d.year_quarter,
    d.year_quarter_sort,
    ROUND(AVG(f.house_price_index), 2) AS avg_house_price_index,
    ROUND(AVG(f.price_index_qoq_pct), 2) AS avg_qoq_change_pct,
    ROUND(AVG(f.price_index_yoy_pct), 2) AS avg_yoy_growth_pct
FROM fact_housing_market AS f
JOIN dim_date AS d
    ON f.date_key = d.date_key
JOIN dim_region AS r
    ON f.region_id = r.region_id
GROUP BY
    d.year_quarter,
    d.year_quarter_sort
ORDER BY d.year_quarter_sort;

-- KPI Query 2: Top 10 regions by year-over-year growth in the latest quarter.
SELECT
    d.year_quarter,
    r.region_code,
    f.house_price_index,
    f.price_index_yoy_pct
FROM fact_housing_market AS f
JOIN dim_date AS d
    ON f.date_key = d.date_key
JOIN dim_region AS r
    ON f.region_id = r.region_id
WHERE f.date_key = (
    SELECT MAX(date_key)
    FROM fact_housing_market
)
ORDER BY
    f.price_index_yoy_pct DESC,
    r.region_code
LIMIT 10;

-- KPI Query 3: Bottom 10 regions by quarter-over-quarter change in the latest quarter.
SELECT
    d.year_quarter,
    r.region_code,
    f.house_price_index,
    f.price_index_qoq_pct
FROM fact_housing_market AS f
JOIN dim_date AS d
    ON f.date_key = d.date_key
JOIN dim_region AS r
    ON f.region_id = r.region_id
WHERE f.date_key = (
    SELECT MAX(date_key)
    FROM fact_housing_market
)
ORDER BY
    f.price_index_qoq_pct ASC,
    r.region_code
LIMIT 10;

-- KPI Query 4: Top regions by sold dwellings in the latest quarter.
SELECT
    d.year_quarter,
    r.region_code,
    f.sold_dwellings,
    f.sold_dwellings_qoq_pct,
    f.sold_dwellings_yoy_pct
FROM fact_housing_market AS f
JOIN dim_date AS d
    ON f.date_key = d.date_key
JOIN dim_region AS r
    ON f.region_id = r.region_id
WHERE f.date_key = (
    SELECT MAX(date_key)
    FROM fact_housing_market
)
ORDER BY
    f.sold_dwellings DESC,
    r.region_code
LIMIT 10;

-- KPI Query 5: Regional average purchase price comparison in the latest quarter.
SELECT
    d.year_quarter,
    r.region_code,
    f.average_purchase_price,
    ROUND(latest_avg.national_avg_purchase_price, 2) AS national_avg_purchase_price,
    ROUND(f.average_purchase_price - latest_avg.national_avg_purchase_price, 2) AS difference_from_average
FROM fact_housing_market AS f
JOIN dim_date AS d
    ON f.date_key = d.date_key
JOIN dim_region AS r
    ON f.region_id = r.region_id
JOIN (
    SELECT
        date_key,
        AVG(average_purchase_price) AS national_avg_purchase_price
    FROM fact_housing_market
    WHERE date_key = (
        SELECT MAX(date_key)
        FROM fact_housing_market
    )
    GROUP BY date_key
) AS latest_avg
    ON f.date_key = latest_avg.date_key
ORDER BY
    difference_from_average DESC,
    r.region_code;

-- KPI Query 6: Regions above or below the average house price index in the latest quarter.
SELECT
    d.year_quarter,
    r.region_code,
    f.house_price_index,
    ROUND(latest_avg.national_avg_house_price_index, 2) AS national_avg_house_price_index,
    CASE
        WHEN f.house_price_index >= latest_avg.national_avg_house_price_index THEN 'Above average'
        ELSE 'Below average'
    END AS price_index_position
FROM fact_housing_market AS f
JOIN dim_date AS d
    ON f.date_key = d.date_key
JOIN dim_region AS r
    ON f.region_id = r.region_id
JOIN (
    SELECT
        date_key,
        AVG(house_price_index) AS national_avg_house_price_index
    FROM fact_housing_market
    WHERE date_key = (
        SELECT MAX(date_key)
        FROM fact_housing_market
    )
    GROUP BY date_key
) AS latest_avg
    ON f.date_key = latest_avg.date_key
ORDER BY
    f.house_price_index DESC,
    r.region_code;

-- KPI Query 7: Share of national sold dwellings by region in the latest quarter.
SELECT
    d.year_quarter,
    r.region_code,
    f.sold_dwellings,
    ROUND(
        100 * f.sold_dwellings / NULLIF(latest_total.national_sold_dwellings, 0),
        2
    ) AS share_of_national_sold_dwellings_pct
FROM fact_housing_market AS f
JOIN dim_date AS d
    ON f.date_key = d.date_key
JOIN dim_region AS r
    ON f.region_id = r.region_id
JOIN (
    SELECT
        date_key,
        SUM(sold_dwellings) AS national_sold_dwellings
    FROM fact_housing_market
    WHERE date_key = (
        SELECT MAX(date_key)
        FROM fact_housing_market
    )
    GROUP BY date_key
) AS latest_total
    ON f.date_key = latest_total.date_key
ORDER BY
    share_of_national_sold_dwellings_pct DESC,
    r.region_code;

-- KPI Query 8: Latest quarter reporting snapshot.
SELECT
    d.year_quarter,
    COUNT(DISTINCT r.region_id) AS region_count,
    ROUND(AVG(f.house_price_index), 2) AS avg_house_price_index,
    ROUND(AVG(f.price_index_qoq_pct), 2) AS avg_qoq_change_pct,
    ROUND(AVG(f.price_index_yoy_pct), 2) AS avg_yoy_growth_pct,
    SUM(f.sold_dwellings) AS total_sold_dwellings,
    ROUND(AVG(f.average_purchase_price), 2) AS avg_purchase_price,
    SUM(f.total_purchase_value) AS total_purchase_value
FROM fact_housing_market AS f
JOIN dim_date AS d
    ON f.date_key = d.date_key
JOIN dim_region AS r
    ON f.region_id = r.region_id
WHERE f.date_key = (
    SELECT MAX(date_key)
    FROM fact_housing_market
)
GROUP BY
    d.year_quarter,
    d.year_quarter_sort
ORDER BY d.year_quarter_sort;
