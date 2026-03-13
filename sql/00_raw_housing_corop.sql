USE nl_housing_market

DROP TABLE IF EXISTS raw_housing_corop;

CREATE TABLE raw_housing_corop (
                                   id_raw VARCHAR(20),
                                   region_code_raw VARCHAR(20),
                                   period_code_raw VARCHAR(20),
                                   price_index_raw VARCHAR(50),
                                   price_index_ci_lower_raw VARCHAR(50),
                                   price_index_ci_upper_raw VARCHAR(50),
                                   price_index_prev_period_pct_raw VARCHAR(50),
                                   price_index_yoy_pct_raw VARCHAR(50),
                                   sold_dwellings_raw VARCHAR(50),
                                   sold_dwellings_prev_period_pct_raw VARCHAR(50),
                                   sold_dwellings_yoy_pct_raw VARCHAR(50),
                                   avg_purchase_price_raw VARCHAR(50),
                                   total_value_purchase_prices_raw VARCHAR(50)
);