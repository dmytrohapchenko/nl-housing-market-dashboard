# Manual Power BI Build Steps

These steps describe how to manually build the Power BI report in Power BI Desktop from the completed SQL model. They do not indicate that the `.pbix` file has already been created.

## 1. Open Power BI Desktop

1. Open Power BI Desktop.
2. Create a new blank report.
3. Save the file as `nl_housing_market_dashboard.pbix`.

## 2. Import SQL Tables

1. Select **Home > Get data > SQL Server**.
2. Connect to the database that contains the completed SQL model.
3. Import these tables:
   - `dim_date`
   - `dim_region`
   - `fact_housing_market`
4. Use Import mode unless DirectQuery is specifically required.
5. Click **Load**.

## 3. Create Relationships

Open **Model view** and create these relationships:

| From table | From column | To table | To column | Cardinality | Cross-filter direction |
|---|---|---|---|---|---|
| `dim_date` | `date_key` | `fact_housing_market` | `date_key` | One-to-many | Single |
| `dim_region` | `region_id` | `fact_housing_market` | `region_id` | One-to-many | Single |

Confirm that:

- `dim_date` filters `fact_housing_market`.
- `dim_region` filters `fact_housing_market`.
- No many-to-many relationships are required.

## 4. Sort Quarter Labels

1. Open **Data view**.
2. Select `dim_date[year_quarter]`.
3. Select **Column tools > Sort by column**.
4. Choose `dim_date[year_quarter_sort]`.

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

Use **Measure tools** to format the measures:

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

1. Open **View > Browse for themes**.
2. Select `powerbi/housing_market_theme.json`.
3. Confirm that the report uses a light gray page background, white visual cards, dark blue primary color, and teal secondary color.

## 8. Create the Report Page

1. Rename the report page to **Housing Market Overview**.
2. Set page size to 16:9.
3. Add a title text box:
   - Title: Housing Market Overview
   - Optional subtitle: Netherlands housing market by quarter and region

## 9. Add Slicers

Create two slicers:

### Quarter Slicer

- Visual type: Slicer
- Field: `dim_date[year_quarter]`
- Style: Dropdown
- Sort: ascending by `dim_date[year_quarter_sort]`

### Region Slicer

- Visual type: Slicer
- Field: `dim_region[region_code]`
- Style: Dropdown
- Selection: single or multi-select

## 10. Build KPI Cards

Create five Card visuals in the top row:

| Card title | Field |
|---|---|
| Latest House Price Index | `Latest House Price Index` |
| Latest YoY % | `Latest YoY %` |
| Latest QoQ % | `Latest QoQ %` |
| Latest Sold Dwellings | `Latest Sold Dwellings` |
| Latest Average Purchase Price | `Latest Average Purchase Price` |

Formatting:

- White background
- Subtle border or shadow
- Dark blue callout value
- Short clear title
- Consistent card sizes

## 11. Build Line Chart

Create the **House Price Index Trend by Quarter** visual:

- Visual type: Line chart
- X-axis: `dim_date[year_quarter]`
- Y-axis: `Average House Price Index`
- Sort: `dim_date[year_quarter]` ascending
- Title: House Price Index Trend by Quarter

Formatting:

- Use dark blue line color.
- Keep gridlines subtle.
- Show markers only if they improve readability.
- Confirm the x-axis is chronological.

## 12. Build Top 10 YoY Growth Bar Chart

Create the **Top 10 Regions by YoY House Price Growth** visual:

- Visual type: Clustered bar chart
- Y-axis: `dim_region[region_code]`
- X-axis: `Latest YoY %`
- Title: Top 10 Regions by YoY House Price Growth

Apply Top N filter:

1. Open the visual-level filters pane.
2. Add `dim_region[region_code]` if it is not already listed.
3. Change filter type to **Top N**.
4. Set **Show items** to **Top 10**.
5. Set **By value** to `Latest YoY %`.
6. Click **Apply filter**.
7. Sort the visual by `Latest YoY %` descending.

Formatting:

- Use teal bars.
- Format axis as percentage.
- Turn on data labels only if readable.

## 13. Build Top 10 Sold Dwellings Bar Chart

Create the **Top 10 Regions by Sold Dwellings** visual:

- Visual type: Clustered bar chart
- Y-axis: `dim_region[region_code]`
- X-axis: `Latest Sold Dwellings`
- Title: Top 10 Regions by Sold Dwellings

Apply Top N filter:

1. Open the visual-level filters pane.
2. Add `dim_region[region_code]` if it is not already listed.
3. Change filter type to **Top N**.
4. Set **Show items** to **Top 10**.
5. Set **By value** to `Latest Sold Dwellings`.
6. Click **Apply filter**.
7. Sort the visual by `Latest Sold Dwellings` descending.

Formatting:

- Use dark blue bars.
- Format labels as whole numbers.
- Keep category labels readable.

## 14. Build Latest Quarter Regional Snapshot Table

Create the **Latest Quarter Regional Snapshot** table:

- Visual type: Table
- Fields:
  - `dim_region[region_code]`
  - `Latest House Price Index`
  - `Latest YoY %`
  - `Latest QoQ %`
  - `Latest Sold Dwellings`
  - `Latest Average Purchase Price`
  - `Sold Dwellings Share %`
- Title: Latest Quarter Regional Snapshot

Recommended sorting:

- Sort by `Latest Sold Dwellings` descending, or by `Latest YoY %` descending depending on the story you want to emphasize.

Formatting:

- Use readable row height.
- Align numeric columns consistently.
- Keep totals off unless they add value.

## 15. Save the PBIX File

1. Save the file as `nl_housing_market_dashboard.pbix`.
2. Store it outside the repository or in a project location that is intentionally ignored by Git if large binary files should not be committed.

## 16. Export Screenshots

After the report is built manually, export these screenshots to the `screenshots` folder:

- `dashboard_overview.png`
- `model_view.png`
- `kpi_cards.png`
- `regional_comparison.png`
- `latest_quarter_snapshot.png`

Do not create placeholder or fake screenshots.

Recommended screenshot process:

1. Capture the full dashboard page.
2. Capture Model view showing the relationships.
3. Capture the KPI card row.
4. Capture the regional comparison charts.
5. Capture the latest quarter snapshot table.
6. Confirm each image is readable before adding it to the repository.
