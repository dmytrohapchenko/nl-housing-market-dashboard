# Power BI Dashboard

## Dashboard Goal

The completed Power BI dashboard presents a clear overview of Dutch housing market trends by region and quarter. It helps users compare house price index movement, sales activity, and latest-quarter regional performance from the SQL dimensional model.

## Dashboard File

- `nl_housing_market_dashboard.pbix`

## Supporting Assets

- `housing_market_theme.json` - custom light Power BI theme
- `dashboard_spec.md` - final dashboard layout, visuals, slicers, formatting rules, and screenshot checklist
- `../docs/powerbi_measure_plan.md` - DAX measure plan used for the report

## Model

The report uses these SQL model tables:

- `dim_date`
- `dim_region`
- `fact_housing_market`

Relationships:

- `dim_date[date_key]` filters `fact_housing_market[date_key]`
- `dim_region[region_id]` filters `fact_housing_market[region_id]`

## Dashboard Page

Page name: Housing Market Overview

Visuals:

- KPI cards for latest price index, YoY change, QoQ change, sold dwellings, and average purchase price
- quarterly house price index trend
- top 10 regions by YoY house price growth
- top 10 regions by sold dwellings
- latest-quarter regional snapshot table
- slicers for quarter and region

## Screenshots

Dashboard screenshot files were not present in this checkout. When added, the expected screenshot filenames are listed in `../screenshots/README.md`.
