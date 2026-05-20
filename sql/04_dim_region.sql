USE nl_housing_market;

DROP TABLE IF EXISTS dim_region;

CREATE TABLE dim_region (
                            region_id INT NOT NULL,
                            region_code VARCHAR(20) NOT NULL,
                            PRIMARY KEY (region_id),
                            UNIQUE (region_code)
);

INSERT INTO dim_region (
    region_id,
    region_code
)
SELECT
    CAST(ROW_NUMBER() OVER (ORDER BY region_code) AS SIGNED) AS region_id,
    region_code
FROM (
         SELECT DISTINCT region_code
         FROM stg_housing_market
         WHERE region_code IS NOT NULL
     ) AS unique_regions;