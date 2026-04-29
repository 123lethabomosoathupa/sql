-- ================================================================
-- CHAPTER 10: Statistical Functions in SQL
-- TRY IT YOURSELF - EXERCISES
-- ================================================================
-- Requires: acs_2011_2015_stats and fbi_crime_data_2015 tables
-- Also uses: pls_fy2014_pupld14a from Chapter 8 (bonus exercise)


-- ----------------------------------------------------------------
-- Exercise 1:
-- Calculate the correlation between pct_masters_higher and
-- median_hh_income.
-- Is the r value higher or lower than for pct_bachelors_higher (~0.68)?
-- Why does this make sense?
-- ----------------------------------------------------------------

-- SELECT round(
--     corr(median_hh_income, pct_masters_higher)::numeric, 2
-- ) AS masters_income_r
-- FROM acs_2011_2015_stats;

-- Expected result: approximately 0.70 (slightly higher than bachelor's ~0.68)
-- Reason: A master's degree leads to higher earning potential than a
-- bachelor's degree alone, so the relationship between income and
-- this higher level of education is marginally stronger.

-- Compare both in one query:
-- SELECT
--     round(corr(median_hh_income, pct_bachelors_higher)::numeric, 2)
--         AS bachelors_income_r,
--     round(corr(median_hh_income, pct_masters_higher)::numeric, 2)
--         AS masters_income_r
-- FROM acs_2011_2015_stats;


-- ----------------------------------------------------------------
-- Exercise 2a:
-- Which U.S. cities with 500,000+ people had the highest
-- motor vehicle theft rate per 1,000 residents in 2015?
-- ----------------------------------------------------------------

-- SELECT city,
--        st,
--        population,
--        motor_vehicle_theft,
--        round(
--            (motor_vehicle_theft::numeric / population) * 1000, 1
--        ) AS vehicle_theft_per_1000
-- FROM fbi_crime_data_2015
-- WHERE population >= 500000
-- ORDER BY vehicle_theft_per_1000 DESC;


-- ----------------------------------------------------------------
-- Exercise 2b:
-- Which U.S. cities with 500,000+ people had the highest
-- violent crime rate per 1,000 residents in 2015?
-- ----------------------------------------------------------------

-- SELECT city,
--        st,
--        population,
--        violent_crime,
--        round(
--            (violent_crime::numeric / population) * 1000, 1
--        ) AS violent_crime_per_1000
-- FROM fbi_crime_data_2015
-- WHERE population >= 500000
-- ORDER BY violent_crime_per_1000 DESC;


-- ----------------------------------------------------------------
-- Exercise 3 (BONUS):
-- Using the 2014 library data, rank agencies that serve 250,000+
-- people by their visit rate per 1,000 population.
-- Use rank() as a window function.
-- Exclude negative visit counts.
-- ----------------------------------------------------------------

-- SELECT libname,
--        stabr,
--        city,
--        popu_lsa,
--        visits,
--        round(
--            (visits::numeric / popu_lsa) * 1000, 1
--        ) AS visits_per_1000,
--        rank() OVER (
--            ORDER BY (visits::numeric / popu_lsa) DESC
--        ) AS rank
-- FROM pls_fy2014_pupld14a
-- WHERE popu_lsa >= 250000
--   AND visits  >= 0
-- ORDER BY visits_per_1000 DESC;
