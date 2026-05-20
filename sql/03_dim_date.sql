USE nl_housing_market;

DROP TABLE IF EXISTS dim_date;

CREATE TABLE dim_date(
    date_key INT NOT NULL,
    year_num INT NOT NULL,
    quarter_num INT NOT NULL,
    year_quarter VARCHAR(10) NOT NULL,
    year_quarter_sort INT NOT NULL,
    PRIMARY KEY (date_key)
);


INSERT INTO dim_date (
                      date_key,
                      year_num,
                      quarter_num,
                      year_quarter,
                      year_quarter_sort
)
SELECT DISTINCT
    year_num * 10 + quarter_num AS date_key,
    year_num,
    quarter_num,
    year_quarter,
    year_num * 10 + quarter_num AS year_quarter_sort

from stg_housing_market;