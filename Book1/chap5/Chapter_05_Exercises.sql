-- ================================================================
-- CHAPTER 5: Basic Math and Stats with SQL
-- TRY IT YOURSELF - EXERCISES
-- ================================================================
-- Requires: us_counties_2010 table from Chapter 4


-- ----------------------------------------------------------------
-- Exercise 1:
-- Calculate the area of a circle with radius 5 inches.
-- Formula: area = pi * r^2
-- Use pi() for precision. No parentheses needed — ^ runs before *
-- following standard order of operations.
-- ----------------------------------------------------------------

-- SELECT pi() * 5 ^ 2 AS circle_area;
-- Expected result: 78.5398163397448...


-- ----------------------------------------------------------------
-- Exercise 2:
-- Find the New York county with the highest percentage of the
-- population identifying as "American Indian/Alaska Native Alone"
-- (Census column: p0010005).
-- Filter to only NY state. Sort highest percentage first.
-- ----------------------------------------------------------------

-- SELECT geo_name,
--        state_us_abbreviation AS st,
--        p0010001 AS total_population,
--        p0010005 AS native_alone,
--        (CAST(p0010005 AS numeric(8,1)) / p0010001) * 100 AS pct_native
-- FROM us_counties_2010
-- WHERE state_us_abbreviation = 'NY'
-- ORDER BY pct_native DESC;

-- Expected top result: Franklin County (home to Akwesasne/St. Regis Mohawk reservation)


-- ----------------------------------------------------------------
-- Exercise 3:
-- Was the median county population higher in California or New York in 2010?
-- Use percentile_cont(.5) grouped by state.
-- Filter to only CA and NY.
-- ----------------------------------------------------------------

-- SELECT state_us_abbreviation AS st,
--        percentile_cont(.5)
--            WITHIN GROUP (ORDER BY p0010001) AS median_pop
-- FROM us_counties_2010
-- WHERE state_us_abbreviation IN ('CA', 'NY')
-- GROUP BY state_us_abbreviation
-- ORDER BY median_pop DESC;

-- Expected: California counties have a significantly higher median
-- population than New York counties.
