-- ================================================================
-- CHAPTER 4: Importing and Exporting Data
-- TRY IT YOURSELF - EXERCISES
-- Data files directory: E:\school\SQL\Classwork\Book1\data\
-- ================================================================


-- ----------------------------------------------------------------
-- Exercise 1:
-- The movies.txt file uses a colon (:) as the delimiter.
-- The movie title "Mission: Impossible" also contains a colon,
-- so it is wrapped in # signs to protect the colon inside it.
-- Write the WITH options for COPY to handle this format.
--
-- File format preview:
--   id:movie:actor
--   50:#Mission: Impossible#:Tom Cruise
-- ----------------------------------------------------------------

-- CREATE TABLE movies (
--     id integer PRIMARY KEY,
--     movie text NOT NULL,
--     actor varchar(100) NOT NULL
-- );

-- COPY movies
-- FROM 'E:\school\SQL\Classwork\Book1\data\movies.txt'
-- WITH (FORMAT CSV, HEADER, DELIMITER ':', QUOTE '#');

-- Verify:
-- SELECT * FROM movies;


-- ----------------------------------------------------------------
-- Exercise 2:
-- Export the 20 counties with the most housing units.
-- Include only: county name, state abbreviation, and housing unit count.
-- Save to a pipe-delimited text file.
-- ----------------------------------------------------------------

-- COPY (
--     SELECT geo_name,
--            state_us_abbreviation,
--            housing_unit_count_100_percent
--     FROM us_counties_2010
--     ORDER BY housing_unit_count_100_percent DESC
--     LIMIT 20
-- )
-- TO 'E:\school\SQL\Classwork\Book1\data\top20_housing_counties.txt'
-- WITH (FORMAT CSV, HEADER, DELIMITER '|');


-- ----------------------------------------------------------------
-- Exercise 3:
-- Will numeric(3,8) work as a data type for the value 17519.668?
-- Why or why not?
-- Answer: NO. numeric(3,8) means 3 total digits with 8 after the decimal.
-- That is impossible — you cannot have 8 decimal digits inside 3 total digits.
-- PostgreSQL will return an error when creating a column with this type.
-- The correct type for 17519.668 is numeric(8,3):
--   8 total digits, 3 after the decimal point.
-- ----------------------------------------------------------------

-- Correct definition:
-- CREATE TABLE measurement_example (
--     value numeric(8,3)
-- );

-- Wrong definition (will ERROR):
-- CREATE TABLE bad_example (
--     value numeric(3,8)
-- );
-- ^ ERROR: numeric field overflow
