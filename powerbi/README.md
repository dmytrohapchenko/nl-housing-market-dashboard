# Power BI Preparation

## Dashboard Goal

The Power BI dashboard will present a clear overview of Dutch housing market trends by region and quarter. It should help users compare house price index movement, sales activity, and latest-quarter regional performance.

## Tables to Import

Import these SQL model tables into Power BI:

- `dim_date`
- `dim_region`
- `fact_housing_market`

## Relationships

Create these relationships in the Power BI model:

- `fact_housing_market[date_key]` -> `dim_date[date_key]`
- `fact_housing_market[region_id]` -> `dim_region[region_id]`

Recommended relationship direction: one-to-many from each dimension table to the fact table.

## Suggested Dashboard Page

Page name: Housing Market Overview

## Planned Visuals

- KPI cards
- quarterly house price index trend
- regional comparison
- top regions by sold dwellings
- latest quarter snapshot table
- slicers by `year_quarter` and `region_code`

## Screenshots

Screenshots will be added after the Power BI dashboard is created.
