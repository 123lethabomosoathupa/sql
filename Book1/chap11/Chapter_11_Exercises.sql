-- ================================================================
-- CHAPTER 11: Working with Dates and Times
-- TRY IT YOURSELF - EXERCISES
-- ================================================================
-- Requires: nyc_yellow_taxi_trips_2016_06_01 table from Chapter 11
-- SET timezone TO 'US/Eastern'; before running taxi queries


-- ----------------------------------------------------------------
-- Exercise 1:
-- Calculate how long each taxi ride lasted using the pickup and
-- drop-off timestamps. Sort from longest duration to shortest.
-- Inspect the extremes — very long or negative durations are
-- likely data entry errors worth flagging.
-- ----------------------------------------------------------------

-- SET timezone TO 'US/Eastern';

-- SELECT trip_id,
--        tpep_pickup_datetime,
--        tpep_dropoff_datetime,
--        tpep_dropoff_datetime - tpep_pickup_datetime AS trip_duration
-- FROM nyc_yellow_taxi_trips_2016_06_01
-- ORDER BY trip_duration DESC;

-- Also check the shortest (possibly negative) at the other end:
-- SELECT trip_id,
--        tpep_pickup_datetime,
--        tpep_dropoff_datetime,
--        tpep_dropoff_datetime - tpep_pickup_datetime AS trip_duration
-- FROM nyc_yellow_taxi_trips_2016_06_01
-- ORDER BY trip_duration ASC;


-- ----------------------------------------------------------------
-- Exercise 2:
-- At the exact moment New Year's 2100 arrives in New York City,
-- what date and time is it in the following cities?
--   London, Johannesburg, Moscow, Melbourne
-- Use AT TIME ZONE to convert the timestamp.
-- ----------------------------------------------------------------

-- SELECT
--     '2100-01-01 00:00:00' AT TIME ZONE 'US/Eastern'
--         AS "New York midnight",
--     '2100-01-01 00:00:00' AT TIME ZONE 'US/Eastern'
--         AT TIME ZONE 'Europe/London'
--         AS "London",
--     '2100-01-01 00:00:00' AT TIME ZONE 'US/Eastern'
--         AT TIME ZONE 'Africa/Johannesburg'
--         AS "Johannesburg",
--     '2100-01-01 00:00:00' AT TIME ZONE 'US/Eastern'
--         AT TIME ZONE 'Europe/Moscow'
--         AS "Moscow",
--     '2100-01-01 00:00:00' AT TIME ZONE 'US/Eastern'
--         AT TIME ZONE 'Australia/Melbourne'
--         AS "Melbourne";

-- Note: Results depend on daylight saving time rules at that future date.
-- New York is UTC-5 in winter. Johannesburg is UTC+2 = 7 hours ahead.


-- ----------------------------------------------------------------
-- Exercise 3 (BONUS):
-- Using the taxi data, calculate:
--   1. Correlation (r) and r-squared between trip duration and total fare
--   2. Correlation (r) and r-squared between trip distance and total fare
-- Limit to rides of 3 hours or less to exclude outliers.
-- Convert duration to seconds using date_part('epoch', ...) before
-- passing it to corr() (corr() requires numeric input, not interval).
-- ----------------------------------------------------------------

-- SET timezone TO 'US/Eastern';

-- SELECT
--     round(
--         corr(
--             total_amount,
--             date_part('epoch', tpep_dropoff_datetime - tpep_pickup_datetime)
--         )::numeric, 3
--     ) AS trip_time_total_r,
--
--     round(
--         regr_r2(
--             total_amount,
--             date_part('epoch', tpep_dropoff_datetime - tpep_pickup_datetime)
--         )::numeric, 3
--     ) AS trip_time_total_r2,
--
--     round(
--         corr(total_amount, trip_distance)::numeric, 3
--     ) AS trip_dist_total_r,
--
--     round(
--         regr_r2(total_amount, trip_distance)::numeric, 3
--     ) AS trip_dist_total_r2
-- FROM nyc_yellow_taxi_trips_2016_06_01
-- WHERE (tpep_dropoff_datetime - tpep_pickup_datetime)
--       <= '3 hours'::interval;

-- Expected: Both duration and distance correlate positively with fare.
-- Distance is likely the stronger predictor (higher r) since fares
-- in NYC are largely distance-based.
