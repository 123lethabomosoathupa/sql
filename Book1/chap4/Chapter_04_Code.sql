-- ================================================================
-- CHAPTER 4: Importing and Exporting Data
-- MAIN CODE
-- ================================================================


-- ----------------------------------------------------------------
-- Basic COPY Import Syntax
-- ----------------------------------------------------------------

-- COPY table_name
-- FROM 'E:\school\SQL\Classwork\Book1\chap4.cvs'
-- WITH (FORMAT CSV, HEADER);


-- ----------------------------------------------------------------
-- Create the us_counties_2010 Table (abbreviated)
-- Download the full version at: https://www.nostarch.com/practicalSQL/
-- ----------------------------------------------------------------

-- CREATE TABLE us_counties_2010 (
--     geo_name varchar(90),
--     state_us_abbreviation varchar(2),
--     summary_level varchar(3),
--     region smallint,
--     division smallint,
--     state_fips varchar(2),
--     county_fips varchar(3),
--     area_land bigint,
--     area_water bigint,
--     population_count_100_percent integer,
--     housing_unit_count_100_percent integer,
--     internal_point_lat numeric(10,7),
--     internal_point_lon numeric(10,7),
--     p0010001 integer,
--     p0010002 integer,
--     p0010003 integer,
--     p0010004 integer,
--     p0010005 integer,
--     -- snip: full table has 91 columns --
--     h0010001 integer,
--     h0010002 integer,
--     h0010003 integer
-- );


-- ----------------------------------------------------------------
-- Import Census Data using COPY
-- ----------------------------------------------------------------

-- COPY us_counties_2010
-- FROM 'E:\school\SQL\Classwork\Book1\us_counties_2010.csv'
-- WITH (FORMAT CSV, HEADER);


-- ----------------------------------------------------------------
-- Inspect Imported Data
-- ----------------------------------------------------------------

-- View all rows:
-- SELECT * FROM us_counties_2010;

-- Check top 3 counties with the largest land area:
-- SELECT geo_name, state_us_abbreviation, area_land
-- FROM us_counties_2010
-- ORDER BY area_land DESC
-- LIMIT 3;

-- Check top 5 easternmost counties by longitude:
-- SELECT geo_name, state_us_abbreviation, internal_point_lon
-- FROM us_counties_2010
-- ORDER BY internal_point_lon DESC
-- LIMIT 5;


-- ----------------------------------------------------------------
-- Create the supervisor_salaries Table
-- ----------------------------------------------------------------

-- CREATE TABLE supervisor_salaries (
--     town varchar(30),
--     county varchar(30),
--     supervisor varchar(30),
--     start_date date,
--     salary money,
--     benefits money
-- );


-- ----------------------------------------------------------------
-- Import a Subset of Columns (CSV has only 3 of the 6 columns)
-- ----------------------------------------------------------------

-- COPY supervisor_salaries (town, supervisor, salary)
-- FROM ''E:\school\SQL\Classwork\Book1\supervisor_salaries.csv'
-- WITH (FORMAT CSV, HEADER);


-- ----------------------------------------------------------------
-- Add a Default Value During Import Using a Temporary Table
-- ----------------------------------------------------------------

-- Step 1: Clear previous data:
-- DELETE FROM supervisor_salaries;

-- Step 2: Create a temporary table that mirrors the main table:
-- CREATE TEMPORARY TABLE supervisor_salaries_temp (LIKE supervisor_salaries);

-- Step 3: Import CSV into the temporary table:
-- COPY supervisor_salaries_temp (town, supervisor, salary)
-- FROM 'C:\YourDirectory\supervisor_salaries.csv'
-- WITH (FORMAT CSV, HEADER);

-- Step 4: Copy from temp table to main table, adding a county value:
-- INSERT INTO supervisor_salaries (town, county, supervisor, salary)
-- SELECT town, 'Some County', supervisor, salary
-- FROM supervisor_salaries_temp;

-- Step 5: Remove the temporary table:
-- DROP TABLE supervisor_salaries_temp;


-- ----------------------------------------------------------------
-- Export Data with COPY
-- ----------------------------------------------------------------

-- Export the entire table to a pipe-delimited file:
-- COPY us_counties_2010
-- TO ''E:\school\SQL\Classwork\Book1\us_counties_export.txt'
-- WITH (FORMAT CSV, HEADER, DELIMITER '|');

-- Export only selected columns:
-- COPY us_counties_2010 (geo_name, internal_point_lat, internal_point_lon)
-- TO 'E:\school\SQL\Classwork\Book1\us_counties_latlon_export.txt'
-- WITH (FORMAT CSV, HEADER, DELIMITER '|');

-- Export only the results of a query:
-- COPY (
--     SELECT geo_name, state_us_abbreviation
--     FROM us_counties_2010
--     WHERE geo_name ILIKE '%mill%'
-- )
-- TO 'C:\YourDirectory\us_counties_mill_export.txt'
-- WITH (FORMAT CSV, HEADER, DELIMITER '|');
