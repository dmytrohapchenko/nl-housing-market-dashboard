# Power BI Measure Plan

This file lists planned beginner-friendly DAX measures for the Power BI dashboard. The measures are based on the dimensional model tables `dim_date`, `dim_region`, and `fact_housing_market`.

## Latest Date Key

- Purpose: Identifies the latest available reporting quarter in the fact table.
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

## Latest YoY %

- Purpose: Shows the average year-over-year house price index change for the latest quarter.
- DAX draft:

```DAX
Latest YoY % =
VAR LatestDateKey = [Latest Date Key]
RETURN
    CALCULATE (
        AVERAGE ( fact_housing_market[price_index_yoy_pct] ),
        fact_housing_market[date_key] = LatestDateKey
    )
```

## Latest QoQ %

- Purpose: Shows the average quarter-over-quarter house price index change for the latest quarter.
- DAX draft:

```DAX
Latest QoQ % =
VAR LatestDateKey = [Latest Date Key]
RETURN
    CALCULATE (
        AVERAGE ( fact_housing_market[price_index_qoq_pct] ),
        fact_housing_market[date_key] = LatestDateKey
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

## Total Sold Dwellings

- Purpose: Sums sold dwellings for the current report filter context.
- DAX draft:

```DAX
Total Sold Dwellings =
SUM ( fact_housing_market[sold_dwellings] )
```

## Average House Price Index

- Purpose: Calculates the average house price index for the current report filter context.
- DAX draft:

```DAX
Average House Price Index =
AVERAGE ( fact_housing_market[house_price_index] )
```

## Sold Dwellings Share %

- Purpose: Shows a region's share of sold dwellings compared with the selected total.
- DAX draft:

```DAX
Sold Dwellings Share % =
DIVIDE (
    [Total Sold Dwellings],
    CALCULATE (
        [Total Sold Dwellings],
        ALL ( dim_region )
    )
)
```
