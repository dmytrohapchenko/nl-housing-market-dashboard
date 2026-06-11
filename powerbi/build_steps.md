# Manual Power BI Build Steps

These steps describe how to build or refresh the Power BI report from the completed SQL model. The dashboard v1 exists locally, but final repository completion still depends on adding readable screenshots.

## 1. Import SQL Tables

Import these SQL model tables into Power BI:

- `dim_date`
- `dim_region`
- `fact_housing_market`

Use Import mode unless DirectQuery is specifically required.

## 2. Create Relationships

Open Model view and confirm these relationships:

| From table | From column | To table | To column | Cardinality | Cross-filter direction |
|---|---|---|---|---|---|
| `dim_date` | `date_key` | `fact_housing_market` | `date_key` | One-to-many | Single |
| `dim_region` | `region_id` | `fact_housing_market` | `region_id` | One-to-many | Single |

Confirm that:

- `dim_date` filters `fact_housing_market`.
- `dim_region` filters `fact_housing_market`.
- No many-to-many relationships are required.

## 3. Refresh Region Names

After running `sql/08_region_name_enrichment.sql` and refreshing the model:

- use `dim_region[region_name]` in visuals instead of `dim_region[region_code]`;
- keep `dim_region[region_code]` available for tooltips, filters, or technical checks;
- confirm all visible region labels are readable COROP names.

## 4. Sort Quarter Labels

In Data view:

1. Select `dim_date[year_quarter]`.
2. Select Column tools > Sort by column.
3. Choose `dim_date[year_quarter_sort]`.

This keeps quarterly visuals in chronological order.

## 5. Create DAX Measures

Create the measures listed in `docs/powerbi_measure_plan.md`.

Recommended measures:

- `Latest Date Key`
- `Average House Price Index`
- `Latest House Price Index`
- `Latest YoY %`
- `Latest QoQ %`
- `Latest Sold Dwellings`
- `Latest Average Purchase Price`
- `Total Sold Dwellings`
- `Latest Total Purchase Value`
- `Sold Dwellings Share %`

Recommended location: create the measures in `fact_housing_market`.

## 6. Apply Number Formatting

Use Measure tools to format the measures:

| Measure | Format |
|---|---|
| `Average House Price Index` | Decimal number, 1 decimal place |
| `Latest House Price Index` | Decimal number, 1 decimal place |
| `Latest YoY %` | Percentage, 1 decimal place |
| `Latest QoQ %` | Percentage, 1 decimal place |
| `Latest Sold Dwellings` | Whole number, thousands separator |
| `Total Sold Dwellings` | Whole number, thousands separator |
| `Latest Average Purchase Price` | Currency, 0 decimal places |
| `Latest Total Purchase Value` | Currency, 0 decimal places |
| `Sold Dwellings Share %` | Percentage, 1 decimal place |

The SQL percentage columns are stored as percentage-point values such as `5.25`, so the YoY and QoQ DAX measures in `docs/powerbi_measure_plan.md` divide by 100 before using Power BI's Percentage format.

## 7. Import the Theme

1. Open View > Browse for themes.
2. Select `powerbi/housing_market_theme.json`.
3. Confirm that the report uses a light gray page background, white visual cards, dark blue primary color, and teal secondary color.

## 8. Build the Report Page

Page name: Housing Market Overview

Recommended page size: 16:9.

Visuals:

- five KPI cards in the top row
- House Price Index Trend by Quarter line chart
- Top 10 Regions by YoY House Price Growth bar chart
- Top 10 Regions by Sold Dwellings bar chart
- Latest Quarter Regional Snapshot table
- slicers for `dim_date[year_quarter]` and `dim_region[region_name]`

## 9. Export Final Screenshots

After the report is refreshed and the region labels are readable, export these screenshots to the `screenshots` folder:

- `dashboard_overview.png`
- `model_view.png`
- `kpi_cards.png`
- `regional_comparison.png`
- `latest_quarter_snapshot.png`

Do not create placeholder or fake screenshots.
