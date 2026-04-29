-- ================================================================
-- CHAPTER 6: Joining Tables in a Relational Database
-- TRY IT YOURSELF - EXERCISES
-- ================================================================
-- Requires: us_counties_2010 and us_counties_2000 tables


-- ----------------------------------------------------------------
-- Exercise 1:
-- The 2010 census has 3,143 counties and the 2000 census has 3,141.
-- Use a FULL OUTER JOIN to find which counties exist in one table
-- but not the other.
-- Filter using IS NULL to show only the non-matching rows.
-- ----------------------------------------------------------------

-- Counties in 2010 but NOT found in 2000 (new since 2000):
-- SELECT c2010.geo_name AS geo_2010,
--        c2010.state_us_abbreviation AS st,
--        c2000.geo_name AS geo_2000
-- FROM us_counties_2010 c2010
-- FULL OUTER JOIN us_counties_2000 c2000
--     ON c2010.state_fips = c2000.state_fips
--     AND c2010.county_fips = c2000.county_fips
-- WHERE c2000.geo_name IS NULL;

-- Counties in 2000 but NOT found in 2010 (no longer exist in 2010):
-- SELECT c2010.geo_name AS geo_2010,
--        c2000.geo_name AS geo_2000,
--        c2000.state_us_abbreviation AS st
-- FROM us_counties_2010 c2010
-- FULL OUTER JOIN us_counties_2000 c2000
--     ON c2010.state_fips = c2000.state_fips
--     AND c2010.county_fips = c2000.county_fips
-- WHERE c2010.geo_name IS NULL;


-- ----------------------------------------------------------------
-- Exercise 2:
-- Find the median percentage change in population across ALL counties
-- from 2000 to 2010.
-- Nest the percent change formula inside percentile_cont(.5).
-- ----------------------------------------------------------------

-- SELECT percentile_cont(.5)
--     WITHIN GROUP (ORDER BY
--         round(
--             (CAST(c2010.p0010001 AS numeric(8,1)) - c2000.p0010001)
--             / c2000.p0010001 * 100, 1
--         )
--     ) AS median_pct_change
-- FROM us_counties_2010 c2010
-- INNER JOIN us_counties_2000 c2000
--     ON c2010.state_fips = c2000.state_fips
--     AND c2010.county_fips = c2000.county_fips
--     AND c2010.p0010001 <> c2000.p0010001;


-- ----------------------------------------------------------------
-- Exercise 3:
-- Find the county with the GREATEST percentage loss of population
-- between 2000 and 2010.
-- Sort percent change ASC (lowest/most negative value first).
-- Hint: A major hurricane struck the Gulf Coast in 2005.
-- Expected top result: Orleans Parish, Louisiana (Hurricane Katrina).
-- ----------------------------------------------------------------

-- SELECT c2010.geo_name,
--        c2010.state_us_abbreviation AS state,
--        c2010.p0010001 AS pop_2010,
--        c2000.p0010001 AS pop_2000,
--        round(
--            (CAST(c2010.p0010001 AS numeric(8,1)) - c2000.p0010001)
--            / c2000.p0010001 * 100, 1
--        ) AS pct_change
-- FROM us_counties_2010 c2010
-- INNER JOIN us_counties_2000 c2000
--     ON c2010.state_fips = c2000.state_fips
--     AND c2010.county_fips = c2000.county_fips
--     AND c2010.p0010001 <> c2000.p0010001
-- ORDER BY pct_change ASC
-- LIMIT 5;
