-- ================================================================
-- CHAPTER 3: Understanding Data Types
-- TRY IT YOURSELF - EXERCISES
-- ================================================================


-- ----------------------------------------------------------------
-- Exercise 1:
-- Your company tracks mileage for drivers to a tenth of a mile.
-- The max value ever recorded is 999.9 miles in a single day.
-- What data type would you use for the miles_driven column?
-- Answer: numeric(5,1) — 5 total digits, 1 after the decimal.
-- This handles 0.0 through 9999.9 with room to spare.
-- ----------------------------------------------------------------

-- CREATE TABLE driver_mileage (
--     driver_id bigserial,
--     trip_date date,
--     miles_driven numeric(5,1)
-- );


-- ----------------------------------------------------------------
-- Exercise 2:
-- A table needs to store driver first and last names.
-- What data types would you choose? Should they be one column or two?
-- Answer: varchar(50) for each, in SEPARATE columns.
-- Reason: Separate columns allow sorting by last name, searching
-- by first name, and displaying in any order (Last, First vs First Last).
-- One combined column makes any of that much harder.
-- ----------------------------------------------------------------

-- CREATE TABLE drivers (
--     driver_id bigserial,
--     first_name varchar(50),
--     last_name varchar(50)
-- );


-- ----------------------------------------------------------------
-- Exercise 3:
-- Try to CAST the malformed date string '4//2017' to a timestamp.
-- What happens?
-- Answer: PostgreSQL returns an ERROR.
-- Dates must follow a valid format. '4//2017' has no recognized structure.
-- ----------------------------------------------------------------

-- SELECT CAST('4//2017' AS timestamp);
-- ^ ERROR: invalid input syntax for type timestamp: "4//2017"
