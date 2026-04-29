-- ================================================================
-- CHAPTER 2: Try It Yourself Exercises
-- ================================================================


-- Exercise 1: Schools A-Z, teachers by last name A-Z within each school.

-- SELECT school, last_name, first_name
-- FROM teachers
-- ORDER BY school ASC, last_name ASC;


-- Exercise 2: Find the teacher whose first name starts with S earning > $40,000.

-- SELECT first_name, last_name, salary
-- FROM teachers
-- WHERE first_name LIKE 'S%'
-- AND salary > 40000;


-- Exercise 3: Teachers hired since Jan 1 2010, highest to lowest salary.

-- SELECT first_name, last_name, hire_date, salary
-- FROM teachers
-- WHERE hire_date >= '2010-01-01'
-- ORDER BY salary DESC;
