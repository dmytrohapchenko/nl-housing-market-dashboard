# KPI Definitions

## House Price Index

- Definition: Indexed measure of existing own-home purchase prices, where 2020 equals 100.
- Source field or calculation: `fact_housing_market.house_price_index`
- Business use: Tracks price level changes over time and supports regional price comparison.

## Price Index QoQ %

- Definition: Quarter-over-quarter percentage change in the house price index.
- Source field or calculation: `fact_housing_market.price_index_qoq_pct`
- Business use: Shows short-term price movement compared with the previous quarter.

## Price Index YoY %

- Definition: Year-over-year percentage change in the house price index.
- Source field or calculation: `fact_housing_market.price_index_yoy_pct`
- Business use: Shows annual price growth and helps identify high-growth regions.

## Sold Dwellings

- Definition: Number of existing own homes sold in a region during a quarter.
- Source field or calculation: `fact_housing_market.sold_dwellings`
- Business use: Measures transaction volume and market activity by region.

## Sold Dwellings QoQ %

- Definition: Quarter-over-quarter percentage change in sold dwellings.
- Source field or calculation: `fact_housing_market.sold_dwellings_qoq_pct`
- Business use: Shows short-term changes in regional sales activity.

## Sold Dwellings YoY %

- Definition: Year-over-year percentage change in sold dwellings.
- Source field or calculation: `fact_housing_market.sold_dwellings_yoy_pct`
- Business use: Shows annual changes in market activity.

## Average Purchase Price

- Definition: Average purchase price of sold existing own homes in a region and quarter.
- Source field or calculation: `fact_housing_market.average_purchase_price`
- Business use: Compares price levels across regions in the latest quarter.

## Total Purchase Value

- Definition: Total value of purchase prices for sold existing own homes in a region and quarter.
- Source field or calculation: `fact_housing_market.total_purchase_value`
- Business use: Indicates total transaction value and relative market size.

## Sold Dwellings Share %

- Definition: Region's share of total sold dwellings in the latest quarter.
- Source field or calculation: `100 * sold_dwellings / total_sold_dwellings`
- Business use: Shows each region's contribution to national transaction volume.

## Difference from Average

- Definition: Difference between a regional metric and the national average for the same quarter.
- Source field or calculation: `regional_value - national_average`
- Business use: Identifies regions above or below the national benchmark.
