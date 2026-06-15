# Power BI Dashboard Specification

## Page Names

- Page 1: Dutch Housing Market Overview
- Page 2: Regional Performance Snapshot

## Dashboard Purpose

This two-page Power BI dashboard summarizes Dutch housing market trends by quarter and region. It is designed to show latest market conditions, price growth, sales activity, and regional differences using the completed SQL dimensional model.

## Target User

The target user is a junior data analyst, recruiter, hiring manager, or portfolio reviewer who wants to quickly understand:

- whether house prices are rising or falling
- which regions show the strongest yearly price growth
- where sales activity is highest
- how the latest quarter compares across regions

## Final Layout

Use two clean report pages with a compact portfolio-ready layout.

Recommended page size: 16:9.

Page 1: Dutch Housing Market Overview

- KPI cards
- House Price Index Trend by Quarter line chart
- Top 5 Regions by YoY Growth bar chart
- Top 5 Regions by Sold Dwellings bar chart
- slicers for quarter and region

Page 2: Regional Performance Snapshot

- latest quarter regional comparison table
- regional performance details using readable `region_name` labels
- supporting slicers where useful

## KPI Card List

Create five KPI cards:

- Latest House Price Index
- Latest YoY %
- Latest QoQ %
- Latest Sold Dwellings
- Latest Average Purchase Price

## Visual List

### KPI Cards

- Visual type: Card
- Measures:
  - `Latest House Price Index`
  - `Latest YoY %`
  - `Latest QoQ %`
  - `Latest Sold Dwellings`
  - `Latest Average Purchase Price`

### House Price Index Trend by Quarter

- Visual type: Line chart
- X-axis: `dim_date[year_quarter]`
- Y-axis: `Average House Price Index`
- Sort: `dim_date[year_quarter]` ascending by `dim_date[year_quarter_sort]`
- Purpose: Show the quarterly trend in house price index.

### Top 5 Regions by YoY Growth

- Visual type: Clustered bar chart
- Y-axis: `dim_region[region_name]`
- X-axis: `Latest YoY %`
- Filter: Top 5 by `Latest YoY %`
- Sort: `Latest YoY %` descending
- Purpose: Identify regions with the strongest latest year-over-year price growth.

### Top 5 Regions by Sold Dwellings

- Visual type: Clustered bar chart
- Y-axis: `dim_region[region_name]`
- X-axis: `Latest Sold Dwellings`
- Filter: Top 5 by `Latest Sold Dwellings`
- Sort: `Latest Sold Dwellings` descending
- Purpose: Identify regions with the highest latest-quarter sales activity.

### Latest Quarter Regional Snapshot

- Visual type: Table
- Columns:
  - `dim_region[region_name]`
  - `dim_region[region_code]`
  - `Latest House Price Index`
  - `Latest YoY %`
  - `Latest QoQ %`
  - `Latest Sold Dwellings`
  - `Latest Average Purchase Price`
  - `Sold Dwellings Share %`
- Purpose: Provide a detailed latest-quarter regional comparison.

## Slicer List

Create these slicers:

- `dim_date[year_quarter]`
- `dim_region[region_name]`

Recommended settings:

- Use dropdown slicers to save space.
- Allow single or multiple region selection.
- Keep the quarter slicer visible and easy to reset.

## Formatting Rules

- Use the custom theme file: `powerbi/housing_market_theme.json`.
- Use a light gray page background.
- Use white visual backgrounds.
- Use dark blue for primary chart elements.
- Use teal for secondary chart elements where needed.
- Use muted gray for labels and supporting text.
- Avoid dark theme styling.
- Avoid excessive colors.
- Keep visual titles short and business-friendly.
- Format percentages with one decimal place.
- Format house price index with one decimal place.
- Format sold dwellings as whole numbers with thousands separators.
- Format purchase price and purchase value as currency with thousands separators.
- Turn on data labels for bar charts only when labels remain readable.
- Keep chart gridlines subtle or disabled.
- Align cards and visuals consistently.

## Screenshot Checklist

The final dashboard screenshots are:

- `dashboard_overview.png`
- `model_view.png`
- `kpi_cards.png`
- `regional_comparison.png`
- `regional_performance_snapshot.png`

Before adding screenshots, verify:

- All five KPI cards display values.
- The line chart is sorted by quarter in chronological order.
- Top 5 bar charts are filtered and sorted correctly.
- The table uses latest-quarter measures.
- Slicers work for `year_quarter` and `region_name`.
- No placeholder or fake screenshots are included.
