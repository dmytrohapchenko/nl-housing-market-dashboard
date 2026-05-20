USE nl_housing_market;

DROP TABLE IF EXISTS fact_housing_market;

CREATE TABLE fact_housing_market (
                                     date_key INT NOT NULL,
                                     region_id INT NOT NULL,

                                     house_price_index DECIMAL(10, 2),
                                     price_index_ci_lower DECIMAL(10, 2),
                                     price_index_ci_upper DECIMAL(10, 2),
                                     price_index_qoq_pct DECIMAL(6, 2),
                                     price_index_yoy_pct DECIMAL(6, 2),

                                     sold_dwellings INT,
                                     sold_dwellings_qoq_pct DECIMAL(6, 2),
                                     sold_dwellings_yoy_pct DECIMAL(6, 2),

                                     average_purchase_price DECIMAL(12, 2),
                                     total_purchase_value DECIMAL(18, 2),

                                     PRIMARY KEY (date_key, region_id),

                                     FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
                                     FOREIGN KEY (region_id) REFERENCES dim_region(region_id)
);

INSERT INTO fact_housing_market (
    date_key,
    region_id,
    house_price_index,
    price_index_ci_lower,
    price_index_ci_upper,
    price_index_qoq_pct,
    price_index_yoy_pct,
    sold_dwellings,
    sold_dwellings_qoq_pct,
    sold_dwellings_yoy_pct,
    average_purchase_price,
    total_purchase_value
)
SELECT
    dd.date_key,
    dr.region_id,
    stg.house_price_index,
    stg.price_index_ci_lower,
    stg.price_index_ci_upper,
    stg.price_index_qoq_pct,
    stg.price_index_yoy_pct,
    stg.sold_dwellings,
    stg.sold_dwellings_qoq_pct,
    stg.sold_dwellings_yoy_pct,
    stg.average_purchase_price,
    stg.total_purchase_value
FROM stg_housing_market AS stg

         JOIN dim_date AS dd
              ON stg.year_num = dd.year_num
                  AND stg.quarter_num = dd.quarter_num

         JOIN dim_region AS dr
              ON stg.region_code = dr.region_code;