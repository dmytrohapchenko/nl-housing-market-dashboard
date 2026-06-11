USE nl_housing_market;

-- Add readable COROP region names to dim_region without changing fact table grain.
-- Source for the mapping CSV:
-- CBS StatLine table 85819ENG, OData dimension:
-- https://opendata.cbs.nl/ODataApi/OData/85819ENG/Regions

DROP TABLE IF EXISTS corop_region_mapping;

CREATE TABLE corop_region_mapping (
    region_code VARCHAR(20) NOT NULL,
    region_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (region_code)
);

-- The lookup is versioned in data/lookup/corop_region_mapping.csv.
-- This script inserts the same mapping values below so it can be run end to end.
--
-- To load from the CSV instead of using the INSERT block, skip the INSERT block
-- and run the LOAD DATA command below from a MySQL client that permits LOCAL INFILE.
--
-- In MySQL Workbench or the MySQL CLI, enable local infile if needed:
-- SET GLOBAL local_infile = 1;
--
-- Example:
-- LOAD DATA LOCAL INFILE 'data/lookup/corop_region_mapping.csv'
-- INTO TABLE corop_region_mapping
-- CHARACTER SET utf8mb4
-- FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS
-- (region_code, region_name);

INSERT INTO corop_region_mapping (
    region_code,
    region_name
) VALUES
    ('CR01', 'Oost-Groningen'),
    ('CR02', 'Delfzijl en omgeving'),
    ('CR03', 'Overig Groningen'),
    ('CR04', 'Noord-Fryslân'),
    ('CR05', 'Zuidwest-Fryslân'),
    ('CR06', 'Zuidoost-Fryslân'),
    ('CR07', 'Noord-Drenthe'),
    ('CR08', 'Zuidoost-Drenthe'),
    ('CR09', 'Zuidwest-Drenthe'),
    ('CR10', 'Noord-Overijssel'),
    ('CR11', 'Zuidwest-Overijssel'),
    ('CR12', 'Twente'),
    ('CR13', 'Veluwe'),
    ('CR14', 'Achterhoek'),
    ('CR15', 'Arnhem/Nijmegen'),
    ('CR16', 'Zuidwest-Gelderland'),
    ('CR17', 'Utrecht'),
    ('CR18', 'Kop van Noord-Holland'),
    ('CR19', 'Alkmaar en omgeving'),
    ('CR20', 'IJmond'),
    ('CR21', 'Agglomeratie Haarlem'),
    ('CR22', 'Zaanstreek'),
    ('CR23', 'Groot-Amsterdam'),
    ('CR24', 'Het Gooi en Vechtstreek'),
    ('CR25', 'Agglomeratie Leiden en Bollenstreek'),
    ('CR26', 'Agglomeratie ''s-Gravenhage'),
    ('CR27', 'Delft en Westland'),
    ('CR28', 'Oost-Zuid-Holland'),
    ('CR29', 'Groot-Rijnmond'),
    ('CR30', 'Zuidoost-Zuid-Holland'),
    ('CR31', 'Zeeuwsch-Vlaanderen'),
    ('CR32', 'Overig Zeeland'),
    ('CR33', 'West-Noord-Brabant'),
    ('CR34', 'Midden-Noord-Brabant'),
    ('CR35', 'Noordoost-Noord-Brabant'),
    ('CR36', 'Zuidoost-Noord-Brabant'),
    ('CR37', 'Noord-Limburg'),
    ('CR38', 'Midden-Limburg'),
    ('CR39', 'Zuid-Limburg'),
    ('CR40', 'Flevoland');

-- Add region_name to dim_region if it is not already present.
SET @region_name_column_exists = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'dim_region'
      AND column_name = 'region_name'
);

SET @add_region_name_sql = IF(
    @region_name_column_exists = 0,
    'ALTER TABLE dim_region ADD COLUMN region_name VARCHAR(100) NULL AFTER region_code',
    'SELECT ''dim_region.region_name already exists'' AS message'
);

PREPARE add_region_name_stmt FROM @add_region_name_sql;
EXECUTE add_region_name_stmt;
DEALLOCATE PREPARE add_region_name_stmt;

-- Populate readable names while preserving existing region_id values.
UPDATE dim_region AS dr
JOIN corop_region_mapping AS crm
    ON dr.region_code = crm.region_code
SET dr.region_name = crm.region_name;

-- Check for missing mappings before making the column required.
SELECT
    dr.region_code
FROM dim_region AS dr
LEFT JOIN corop_region_mapping AS crm
    ON dr.region_code = crm.region_code
WHERE crm.region_code IS NULL
   OR dr.region_name IS NULL;

-- Once the check above returns no rows, enforce completeness.
ALTER TABLE dim_region
    MODIFY region_name VARCHAR(100) NOT NULL;
