-- KPI Query 1: Quarterly house price index trend by region

SELECT
    d.year_quarter,
    d.year_quarter_sort,

    sum(f.house_price_index) / count(f.house_price_index) as avg_house_price_index

FROM nl_housing_market.fact_housing_market f
         JOIN nl_housing_market.dim_date d ON f.date_key = d.date_key
         JOIN nl_housing_market.dim_region r ON f.region_id = r.region_id

GROUP BY d.year_quarter, d.year_quarter_sort
ORDER BY d.year_quarter_sort

-- KPI Query 2: Top 10 regions by year-over-year house price growth in the latest quarter

SELECT
    *
FROM nl_housing_market.fact_housing_market f
        JOIN nl_housing_market.dim_date d ON f.date_key = d.date_key
        JOIN nl_housing_market.dim_region r ON f.region_id = r.region_id
GROUP BY d.year_quarter, d.year_quarter_sort
HAVING d.year_quarter_sort = MAX(d.year_quarter_sort)
-- KPI Query 3: Bottom 10 regions by quarter-over-quarter price change

-- KPI Query 4: Regions with the highest sold dwellings in the latest quarter

-- KPI Query 5: Regional average purchase price comparison

-- KPI Query 6: Regions above and below the national average house price index

-- KPI Query 7: Share of national sold dwellings by region

-- KPI Query 8: Latest quarter reporting snapshot