-- ================================================================
-- CHAPTER 17: Maintaining Your Database
-- MAIN CODE
-- ================================================================
-- Run these inside psql connected to the analysis database:
--   \c analysis
-- ================================================================


-- ================================================================
-- LISTING 17-1: Create a table to test vacuuming
-- ================================================================

CREATE TABLE vacuum_test (
    integer_column integer
);


-- ================================================================
-- LISTING 17-2: Check the size of vacuum_test
-- ================================================================
-- Run this after each step to track size changes.

SELECT pg_size_pretty(
    pg_total_relation_size('vacuum_test')
);
-- Expected: 0 bytes (empty table)

-- Alternatively, from psql command line (not inside SQL):
-- \dt+ vacuum_test


-- ================================================================
-- LISTING 17-3: Insert 500,000 rows into vacuum_test
-- ================================================================

INSERT INTO vacuum_test
SELECT * FROM generate_series(1, 500000);

-- Re-run Listing 17-2 after this.
-- Expected size: ~17 MB


-- ================================================================
-- LISTING 17-4: Update all rows (causes dead rows / table bloat)
-- ================================================================

UPDATE vacuum_test
SET integer_column = integer_column + 1;

-- Re-run Listing 17-2 after this.
-- Expected size: ~35 MB (doubled due to dead rows)


-- ================================================================
-- LISTING 17-5: Check autovacuum statistics for vacuum_test
-- ================================================================
-- Wait at least 1 minute after the UPDATE before running this,
-- so autovacuum has time to fire.

SELECT relname,
       last_vacuum,
       last_autovacuum,
       vacuum_count,
       autovacuum_count
FROM pg_stat_all_tables
WHERE relname = 'vacuum_test';


-- ================================================================
-- LISTING 17-6: Run VACUUM manually
-- ================================================================
-- VACUUM marks dead rows as reusable but does NOT shrink table on disk.

VACUUM vacuum_test;

-- Re-run Listing 17-5 to confirm last_vacuum is now populated.
-- Re-run Listing 17-2 — size will still be ~35 MB (VACUUM doesn't shrink).


-- ================================================================
-- LISTING 17-7: Run VACUUM FULL to reclaim disk space
-- ================================================================
-- VACUUM FULL rewrites the table and actually shrinks it on disk.
-- NOTE: Locks the table — no other operations can run during this.

VACUUM FULL vacuum_test;

-- Re-run Listing 17-2 after this.
-- Expected: back to ~17 MB


-- ================================================================
-- LISTING 17-8: Find location of postgresql.conf
-- ================================================================

SHOW config_file;

-- Copy the path shown, then open the file in a text editor (not Word).
-- On Windows it will be somewhere inside E:\Postegre\data\postgresql.conf


-- ================================================================
-- LISTING 17-9: Sample settings to look for inside postgresql.conf
-- ================================================================
-- These are NOT SQL — they are lines inside the postgresql.conf file.
-- Open the file and search for each setting name.

-- datestyle = 'iso, mdy'
-- timezone = 'Africa/Johannesburg'        <-- change this to match your zone
-- default_text_search_config = 'pg_catalog.english'

-- After editing postgresql.conf, reload settings from CMD:
--   pg_ctl reload -D "E:\Postegre\data"


-- ================================================================
-- BONUS: Useful maintenance queries
-- ================================================================

-- Check sizes of ALL tables in the analysis database:
SELECT relname AS table_name,
       pg_size_pretty(pg_total_relation_size(relid)) AS total_size
FROM pg_stat_user_tables
ORDER BY pg_total_relation_size(relid) DESC;

-- Run ANALYZE manually (updates query planner statistics):
ANALYZE vacuum_test;

-- Run VACUUM on the entire database (omit table name):
-- VACUUM;

-- Run VACUUM VERBOSE for detailed output:
-- VACUUM VERBOSE vacuum_test;


-- ================================================================
-- CLEANUP: Drop the test table when done
-- ================================================================

DROP TABLE vacuum_test;