-- ================================================================
-- CHAPTER 7: Table Design That Works for You
-- TRY IT YOURSELF - EXERCISES
-- ================================================================


-- ----------------------------------------------------------------
-- Starting tables (as given in the book):
-- CREATE TABLE albums (
--     album_id bigserial,
--     album_catalog_code varchar(100),
--     album_title text,
--     album_artist text,
--     album_release_date date,
--     album_genre varchar(40),
--     album_description text
-- );
-- CREATE TABLE songs (
--     song_id bigserial,
--     song_title text,
--     song_artist text,
--     album_id bigint
-- );
-- ----------------------------------------------------------------


-- ----------------------------------------------------------------
-- Exercise 1:
-- Rewrite both CREATE TABLE statements to add:
--   - A primary key for each table
--   - A foreign key linking songs to albums
--   - Appropriate constraints (NOT NULL, UNIQUE)
-- ----------------------------------------------------------------

-- CREATE TABLE albums (
--     album_id bigserial,
--     album_catalog_code varchar(100) NOT NULL,
--     album_title text NOT NULL,
--     album_artist text NOT NULL,
--     album_release_date date,
--     album_genre varchar(40),
--     album_description text,
--     CONSTRAINT album_id_key PRIMARY KEY (album_id),
--     CONSTRAINT album_catalog_unique UNIQUE (album_catalog_code)
-- );

-- Reasoning:
-- album_id: surrogate primary key (bigserial auto-counts).
-- album_catalog_code: UNIQUE because each album has one catalog code.
-- album_title and album_artist: NOT NULL because every album must have both.
-- album_release_date: nullable — sometimes not known at time of entry.

-- CREATE TABLE songs (
--     song_id bigserial,
--     song_title text NOT NULL,
--     song_artist text NOT NULL,
--     album_id bigint REFERENCES albums (album_id) ON DELETE CASCADE,
--     CONSTRAINT song_id_key PRIMARY KEY (song_id)
-- );

-- Reasoning:
-- song_id: surrogate primary key.
-- album_id: FOREIGN KEY references albums — prevents orphan songs.
-- ON DELETE CASCADE: if the album is deleted, its songs are deleted too.
-- song_title and song_artist: NOT NULL — every song must have both.


-- ----------------------------------------------------------------
-- Exercise 2:
-- Could album_catalog_code serve as a natural primary key?
-- Answer: ONLY if ALL three conditions are true:
--   1. Every album always has a catalog code (no NULLs ever).
--   2. Each catalog code is guaranteed to be globally unique.
--   3. The code never changes once assigned.
-- In practice, catalog codes can be reissued or changed by labels,
-- so a surrogate key (album_id) is the safer and more reliable choice.
-- ----------------------------------------------------------------


-- ----------------------------------------------------------------
-- Exercise 3:
-- Which columns in albums and songs are good candidates for indexes?
-- Add an index to each one.
-- Rule: Index columns used frequently in WHERE clauses or JOIN conditions.
-- ----------------------------------------------------------------

-- albums table:
-- CREATE INDEX album_title_idx ON albums (album_title);
-- Reason: Users search for albums by title.

-- CREATE INDEX album_artist_idx ON albums (album_artist);
-- Reason: Users search and group by artist name.

-- songs table:
-- CREATE INDEX song_title_idx ON songs (song_title);
-- Reason: Users search for songs by title.

-- CREATE INDEX songs_album_id_idx ON songs (album_id);
-- Reason: album_id is the foreign key used in every JOIN between tables.
-- PostgreSQL does NOT automatically index foreign keys.

-- Note: Primary keys already have indexes created automatically.
-- Note: The UNIQUE constraint on album_catalog_code also creates an index.
