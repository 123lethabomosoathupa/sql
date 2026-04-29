-- ================================================================
-- CHAPTER 1: Try It Yourself Exercises
-- ================================================================


-- Exercise 1: Create a zoo database with two related tables.

-- CREATE TABLE animal_types (
--     animal_type_id bigserial,
--     common_name varchar(100),
--     scientific_name varchar(150),
--     conservation_status varchar(50)
-- );

-- CREATE TABLE animals (
--     animal_id bigserial,
--     animal_type_id integer,
--     name varchar(100),
--     gender varchar(10),
--     birth_date date,
--     enclosure varchar(50)
-- );


-- Exercise 2: Insert data, then intentionally break it with a missing comma.

-- Correct inserts:
-- INSERT INTO animal_types (common_name, scientific_name, conservation_status)
-- VALUES ('African Elephant', 'Loxodonta africana', 'Vulnerable'),
--        ('Nile Crocodile', 'Crocodylus niloticus', 'Least Concern'),
--        ('Cheetah', 'Acinonyx jubatus', 'Vulnerable');

-- INSERT INTO animals (animal_type_id, name, gender, birth_date, enclosure)
-- VALUES (1, 'Tembo', 'Female', '2010-03-15', 'Savanna Habitat'),
--        (2, 'Scales', 'Male', '2008-07-20', 'Reptile House'),
--        (3, 'Dash', 'Male', '2015-11-02', 'Big Cat Country');

-- Intentional error (missing comma after 'Male'):
-- INSERT INTO animals (animal_type_id, name, gender, birth_date, enclosure)
-- VALUES (3, 'Dash', 'Male' '2015-11-02', 'Big Cat Country');
-- ^ ERROR: syntax error at or near "'2015-11-02'"

-- View data:
-- SELECT * FROM animal_types;
-- SELECT * FROM animals;
