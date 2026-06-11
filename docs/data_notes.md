# Data Notes

## Source

The project uses official Dutch housing market data from CBS.

Dataset: Existing own homes; purchase price indices 2020=100 by region (COROP).

## Grain

The reporting grain is one row per region x quarter. This grain is preserved in `fact_housing_market`.

## Analysis Window

The SQL pipeline filters the reporting period to 2020 Q1 through 2025 Q4.

## Period Parsing Logic

The raw period code is parsed into:

- `year_num`: first four characters of the period code
- `quarter_num`: last two characters of the period code
- `year_quarter`: formatted as `YYYY-Qn`
- `date_key`: calculated as `year_num * 10 + quarter_num`

## Region Name Enrichment

The original CBS dataset contains a COROP `region_code` field, such as `CR01` or `CR23`. These codes are useful for technical checks, but they are not readable enough for dashboard labels.

Readable `region_name` values are added through the lookup file `data/lookup/corop_region_mapping.csv`. The lookup is loaded by `sql/08_region_name_enrichment.sql`, which adds `region_name` to `dim_region` while preserving the existing region x quarter fact table grain.

Power BI should use `dim_region[region_name]` in charts, tables, and slicers for readability. `dim_region[region_code]` remains available for tooltips and technical validation.

Mapping source: CBS StatLine table `85819ENG`, OData `Regions` dimension (`https://opendata.cbs.nl/ODataApi/OData/85819ENG/Regions`).

## Main Metrics

- house price index
- price index QoQ %
- price index YoY %
- sold dwellings
- sold dwellings QoQ %
- sold dwellings YoY %
- average purchase price
- total purchase value

## Important Assumptions

- Each region x quarter should appear once in the final fact table.
- Blank raw metric values are converted to `NULL` in staging.
- The latest quarter is identified using the maximum `date_key` in `fact_housing_market`.
- National averages and totals are calculated across all available regions for the selected quarter.
