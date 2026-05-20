# nl-housing-market-dashboard

## Overview

This project is a SQL + Power BI reporting case using official Dutch housing market data from CBS. It is designed as a reporting-focused portfolio project for analyzing regional housing market trends and period-over-period KPI changes.

The SQL layer builds a simple dimensional model for quarterly regional housing metrics. A Power BI dashboard is planned as the next step and will be added after SQL validation.

## Business Questions

- How did the house price index change over time?
- Which regions had the strongest YoY house price growth in the latest quarter?
- Which regions had the weakest QoQ house price change in the latest quarter?
- Which regions had the highest number of sold dwellings?
- Which regions are above or below the average house price index?
- What share of national sold dwellings does each region represent?

## Dataset

- Source: CBS
- Dataset: Existing own homes; purchase price indices 2020=100 by region (COROP)
- Grain: one row per region x quarter
- Analysis window: 2020 Q1 to 2025 Q4
- Current region field: `region_code`

## Data Model

The project uses a compact dimensional model for reporting:

- `stg_housing_market`: clean staging layer with typed fields from the raw source.
- `dim_date`: one row per quarter.
- `dim_region`: one row per region.
- `fact_housing_market`: one row per region x quarter.

The date key is calculated as `date_key = year_num * 10 + quarter_num`. The fact table contains dimension keys and housing market metrics only.

## SQL Pipeline

- `00_raw_housing_corop.sql`: creates the raw landing table for the source file.
- `01_source_check.sql`: validates raw source coverage, keys, duplicates, and numeric fields.
- `02_staging_housing.sql`: cleans and converts raw text fields into typed reporting columns.
- `03_dim_date.sql`: creates the quarterly date dimension.
- `04_dim_region.sql`: creates the regional dimension from distinct region codes.
- `05_fact_housing_market.sql`: loads the fact table at region x quarter grain.
- `07_data_quality.sql`: validates the final reporting model.
- `06_kpi_queries.sql`: contains business KPI queries for reporting and Power BI.

## Data Quality Checks

The SQL validation layer includes:

- row count checks
- duplicate grain checks
- invalid negative value checks
- orphan key checks
- dimension uniqueness checks
- reporting period coverage checks

## KPI Queries

The KPI query file includes:

1. Quarterly house price index trend
2. Top 10 regions by YoY house price growth in the latest quarter
3. Bottom 10 regions by QoQ house price change in the latest quarter
4. Top regions by sold dwellings in the latest quarter
5. Regional average purchase price comparison in the latest quarter
6. Regions above or below average house price index in the latest quarter
7. Share of national sold dwellings by region in the latest quarter
8. Latest quarter reporting snapshot

## Power BI Dashboard

Power BI dashboard will be added after SQL validation.

Planned dashboard content:

- KPI cards
- quarterly trend
- regional comparison
- latest quarter snapshot
- top/bottom regions

## Repository Structure

```text
data/
  raw/
docs/
  business_brief.md
  data_notes.md
  kpi_definitions.md
  powerbi_measure_plan.md
sql/
powerbi/
  README.md
screenshots/
  README.md
```

## Status

- SQL pipeline: completed
- data quality checks: completed
- KPI queries: completed
- Power BI dashboard: in progress
- screenshots: to be added
