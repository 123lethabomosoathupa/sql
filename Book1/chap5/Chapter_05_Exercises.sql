-- ================================================================
-- CHAPTER 5: Basic Math and Stats with SQL
-- TRY IT YOURSELF - EXERCISES
-- ================================================================


-- ----------------------------------------------------------------
-- Exercise 1:
-- Calculate the area of a circle with radius 5 inches.
-- Formula: area = pi * r^2
-- No parentheses needed here because ^ (exponent) takes precedence
-- over * (multiplication) following standard order of operations.
-- ----------------------------------------------------------------

-- SELECT 3.14159 * 5 ^ 2 AS circle_area;

-- Or using pi() function:
-- SELECT pi() * 5 ^ 2 AS circle_area;


-- ----------------------------------------------------------------
-- Exercise 2:
-- Find the New York county with the highest percentage of the
-- population identifying as "American Indian/Alaska Native Alone"
-- (column p0010005).
-- ----------------------------------------------------------------

-- SELECT geo_name,
--        state_us_abbreviation AS st,
--        p0010001 AS total_population,
--        p0010005 AS native_alone,
--        (CAST(p0010005 AS numeric(8,1)) / p0010001) * 100 AS pct_native
-- FROM us_counties_2010
-- WHERE state_us_abbreviation = 'NY'
-- ORDER BY pct_native DESC;


-- ----------------------------------------------------------------
-- Exercise 3:
-- Was the 2010 median county population higher in California or New York?
-- ----------------------------------------------------------------

-- SELECT state_us_abbreviation AS st,
--        percentile_cont(.5) WITHIN GROUP (ORDER BY p0010001) AS median_pop
-- FROM us_counties_2010
-- WHERE state_us_abbreviation IN ('CA', 'NY')
-- GROUP BY state_us_abbreviation
-- ORDER BY median_pop DESC;
