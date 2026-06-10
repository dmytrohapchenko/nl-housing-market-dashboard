# Power BI Measure Plan

This file lists planned beginner-friendly DAX measures for the Power BI dashboard. The measures are based on the dimensional model tables `dim_date`, `dim_region`, and `fact_housing_market`.

The measures are intended for a manual Power BI Desktop build. They should be reviewed after import to confirm that numeric and percentage formats match the imported SQL data types.

## Latest Date Key

- Purpose: Identifies the latest available reporting quarter in the current filter context.
- DAX draft:

```DAX
Latest Date Key =
MAX ( fact_housing_market[date_key] )
```

## Latest House Price Index

- Purpose: Shows the average house price index for the latest quarter.
- DAX draft:

```DAX
Latest House Price Index =
VAR LatestDateKey = [Latest Date Key]
RETURN
    CALCULATE (
        AVERAGE ( fact_housing_market[house_price_index] ),
        fact_housing_market[date_key] = LatestDateKey
    )
```

## Average House Price Index

- Purpose: Calculates the average house price index for the current report filter context.
- DAX draft:

```DAX
Average House Price Index =
AVERAGE ( fact_housing_market[house_price_index] )
```

## Latest YoY %

- Purpose: Shows the average year-over-year house price index change for the latest quarter.
- DAX draft:

```DAX
Latest YoY % =
VAR LatestDateKey = [Latest Date Key]
RETURN
    DIVIDE (
        CALCULATE (
            AVERAGE ( fact_housing_market[price_index_yoy_pct] ),
            fact_housing_market[date_key] = LatestDateKey
        ),
        100
    )
```

## Latest QoQ %

- Purpose: Shows the average quarter-over-quarter house price index change for the latest quarter.
- DAX draft:

```DAX
Latest QoQ % =
VAR LatestDateKey = [Latest Date Key]
RETURN
    DIVIDE (
        CALCULATE (
            AVERAGE ( fact_housing_market[price_index_qoq_pct] ),
            fact_housing_market[date_key] = LatestDateKey
        ),
        100
    )
```

## Latest Sold Dwellings

- Purpose: Shows total sold dwellings in the latest quarter.
- DAX draft:

```DAX
Latest Sold Dwellings =
VAR LatestDateKey = [Latest Date Key]
RETURN
    CALCULATE (
        SUM ( fact_housing_market[sold_dwellings] ),
        fact_housing_market[date_key] = LatestDateKey
    )
```

## Latest Average Purchase Price

- Purpose: Shows the average purchase price for the latest quarter.
- DAX draft:

```DAX
Latest Average Purchase Price =
VAR LatestDateKey = [Latest Date Key]
RETURN
    CALCULATE (
        AVERAGE ( fact_housing_market[average_purchase_price] ),
        fact_housing_market[date_key] = LatestDateKey
    )
```

## Latest Total Purchase Value

- Purpose: Shows total purchase value in the latest quarter.
- DAX draft:

```DAX
Latest Total Purchase Value =
VAR LatestDateKey = [Latest Date Key]
RETURN
    CALCULATE (
        SUM ( fact_housing_market[total_purchase_value] ),
        fact_housing_market[date_key] = LatestDateKey
    )
```

## Total Sold Dwellings

- Purpose: Sums sold dwellings for the current report filter context.
- DAX draft:

```DAX
Total Sold Dwellings =
SUM ( fact_housing_market[sold_dwellings] )
```

## Sold Dwellings Share %

- Purpose: Shows a region's share of sold dwellings compared with the selected regional total.
- DAX draft:

```DAX
Sold Dwellings Share % =
DIVIDE (
    [Total Sold Dwellings],
    CALCULATE (
        [Total Sold Dwellings],
        ALLSELECTED ( dim_region )
    )
)
```

## Formatting Notes

Recommended Power BI formats:

- `Average House Price Index`: decimal number, 1 decimal place
- `Latest House Price Index`: decimal number, 1 decimal place
- `Latest YoY %`: percentage, 1 decimal place
- `Latest QoQ %`: percentage, 1 decimal place
- `Latest Sold Dwellings`: whole number, thousands separator
- `Total Sold Dwellings`: whole number, thousands separator
- `Latest Average Purchase Price`: currency, 0 decimal places
- `Latest Total Purchase Value`: currency, 0 decimal places
- `Sold Dwellings Share %`: percentage, 1 decimal place

The SQL percentage fields are stored as percentage-point values such as `5.25`, so the YoY and QoQ measures divide by 100 before applying Power BI's Percentage format.
