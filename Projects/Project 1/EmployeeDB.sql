-- ============================================================
--  EmployeeDB  — Full Project SQL
--  Tables: Department, Roles, Salaries, Overtime_Hours,
--          Employees
--  Includes: DDL, FK constraints, sample data,
--            FK-violation demos, and a LEFT JOIN report query
-- ============================================================


-- ============================================================
-- 1. SCHEMA CREATION  (drop in dependency order first)
-- ============================================================

DROP TABLE IF EXISTS Employees      CASCADE;
DROP TABLE IF EXISTS Overtime_Hours CASCADE;
DROP TABLE IF EXISTS Salaries       CASCADE;
DROP TABLE IF EXISTS Roles          CASCADE;
DROP TABLE IF EXISTS Department     CASCADE;


-- ─── Department ──────────────────────────────────────────────
CREATE TABLE Department (
    depart_id   SERIAL       PRIMARY KEY,
    depart_name VARCHAR(100) NOT NULL,
    depart_city VARCHAR(100) NOT NULL
);

-- ─── Roles ───────────────────────────────────────────────────
CREATE TABLE Roles (
    role_id SERIAL       PRIMARY KEY,
    role    VARCHAR(100) NOT NULL
);

-- ─── Salaries ────────────────────────────────────────────────
CREATE TABLE Salaries (
    salary_id SERIAL         PRIMARY KEY,
    salary_pa NUMERIC(12, 2) NOT NULL CHECK (salary_pa >= 0)
);

-- ─── Overtime_Hours ──────────────────────────────────────────
CREATE TABLE Overtime_Hours (
    overtime_id    SERIAL  PRIMARY KEY,
    overtime_hours NUMERIC(6, 2) NOT NULL CHECK (overtime_hours >= 0)
);

-- ─── Employees ───────────────────────────────────────────────
CREATE TABLE Employees (
    emp_id      SERIAL       PRIMARY KEY,
    first_name  VARCHAR(100) NOT NULL,
    surname     VARCHAR(100) NOT NULL,
    gender      VARCHAR(20)  NOT NULL,
    address     VARCHAR(255),
    email       VARCHAR(255) UNIQUE NOT NULL,
    -- Foreign Keys
    depart_id   INT NOT NULL,
    role_id     INT NOT NULL,
    salary_id   INT NOT NULL,
    overtime_id INT NOT NULL,

    CONSTRAINT fk_department
        FOREIGN KEY (depart_id)   REFERENCES Department(depart_id),
    CONSTRAINT fk_role
        FOREIGN KEY (role_id)     REFERENCES Roles(role_id),
    CONSTRAINT fk_salary
        FOREIGN KEY (salary_id)   REFERENCES Salaries(salary_id),
    CONSTRAINT fk_overtime
        FOREIGN KEY (overtime_id) REFERENCES Overtime_Hours(overtime_id)
);


-- ============================================================
-- 2. SEED DATA
-- ============================================================

-- ─── Department ──────────────────────────────────────────────
INSERT INTO Department (depart_name, depart_city) VALUES
    ('Engineering',       'Cape Town'),
    ('Human Resources',   'Johannesburg'),
    ('Finance',           'Durban'),
    ('Marketing',         'Pretoria'),
    ('Operations',        'Port Elizabeth');

-- ─── Roles ───────────────────────────────────────────────────
INSERT INTO Roles (role) VALUES
    ('Software Engineer'),
    ('HR Manager'),
    ('Financial Analyst'),
    ('Marketing Specialist'),
    ('Operations Coordinator'),
    ('Senior Developer'),
    ('Payroll Officer');

-- ─── Salaries ────────────────────────────────────────────────
INSERT INTO Salaries (salary_pa) VALUES
    (420000.00),
    (380000.00),
    (310000.00),
    (270000.00),
    (510000.00),
    (295000.00),
    (460000.00);

-- ─── Overtime_Hours ──────────────────────────────────────────
INSERT INTO Overtime_Hours (overtime_hours) VALUES
    (12.50),
    (0.00),
    (34.75),
    (8.00),
    (22.00),
    (5.50),
    (18.25);

-- ─── Employees ───────────────────────────────────────────────
INSERT INTO Employees
    (first_name, surname, gender, address, email,
     depart_id, role_id, salary_id, overtime_id)
VALUES
    ('Amahle',  'Dlamini',   'Female', '12 Berea Rd, Durban',          'amahle.dlamini@company.co.za',   2, 2, 2, 2),
    ('Sipho',   'Nkosi',     'Male',   '5 Long St, Cape Town',         'sipho.nkosi@company.co.za',      1, 1, 1, 3),
    ('Thandi',  'Mokoena',   'Female', '88 Jan Smuts Ave, Joburg',     'thandi.mokoena@company.co.za',   3, 3, 3, 1),
    ('Ethan',   'van Wyk',   'Male',   '22 Church St, Pretoria',       'ethan.vanwyk@company.co.za',     4, 4, 4, 4),
    ('Lerato',  'Sithole',   'Female', '7 Settlers Way, Port Eliz',    'lerato.sithole@company.co.za',   5, 5, 6, 5),
    ('Rowan',   'Petersen',  'Male',   '3 Kloof St, Cape Town',        'rowan.petersen@company.co.za',   1, 6, 7, 6),
    ('Naledi',  'Khumalo',   'Female', '45 Noord St, Johannesburg',    'naledi.khumalo@company.co.za',   2, 7, 3, 7),
    ('James',   'Fourie',    'Male',   '101 Marine Dr, Durban',        'james.fourie@company.co.za',     3, 3, 5, 2),
    ('Zanele',  'Mahlangu',  'Female', '18 Voortrekker Rd, Pretoria',  'zanele.mahlangu@company.co.za',  4, 4, 4, 3),
    ('Caden',   'Abrahams',  'Male',   '9 Adderley St, Cape Town',     'caden.abrahams@company.co.za',   1, 1, 1, 1);


-- ============================================================
-- 3. VERIFY DATA
-- ============================================================

SELECT 'Department'     AS tbl, COUNT(*) AS rows FROM Department
UNION ALL
SELECT 'Roles',          COUNT(*) FROM Roles
UNION ALL
SELECT 'Salaries',       COUNT(*) FROM Salaries
UNION ALL
SELECT 'Overtime_Hours', COUNT(*) FROM Overtime_Hours
UNION ALL
SELECT 'Employees',      COUNT(*) FROM Employees;


-- ============================================================
-- 4. DEMONSTRATE FK CONSTRAINTS WORKING
-- ============================================================

-- ── 4a. FK violation on depart_id (dept 99 does not exist) ───
-- Expected: ERROR — insert or update on table "employees"
--           violates foreign key constraint "fk_department"
DO $$
BEGIN
    BEGIN
        INSERT INTO Employees
            (first_name, surname, gender, email,
             depart_id, role_id, salary_id, overtime_id)
        VALUES ('Ghost', 'User', 'Male', 'ghost@test.com',
                99, 1, 1, 1);   -- depart_id 99 does NOT exist
    EXCEPTION WHEN foreign_key_violation THEN
        RAISE NOTICE 'FK DEMO 1 PASSED: Cannot insert employee with non-existent depart_id=99 → %', SQLERRM;
    END;
END $$;

-- ── 4b. FK violation on role_id (role 50 does not exist) ─────
DO $$
BEGIN
    BEGIN
        INSERT INTO Employees
            (first_name, surname, gender, email,
             depart_id, role_id, salary_id, overtime_id)
        VALUES ('Ghost', 'User', 'Male', 'ghost2@test.com',
                1, 50, 1, 1);   -- role_id 50 does NOT exist
    EXCEPTION WHEN foreign_key_violation THEN
        RAISE NOTICE 'FK DEMO 2 PASSED: Cannot insert employee with non-existent role_id=50 → %', SQLERRM;
    END;
END $$;

-- ── 4c. Cannot DELETE a Department that has employees ─────────
DO $$
BEGIN
    BEGIN
        DELETE FROM Department WHERE depart_id = 1;  -- Engineering has employees
    EXCEPTION WHEN foreign_key_violation THEN
        RAISE NOTICE 'FK DEMO 3 PASSED: Cannot delete Department that has linked employees → %', SQLERRM;
    END;
END $$;


-- ============================================================
-- 5. MAIN REPORT QUERY
--    LEFT JOIN — Department name, Job title, Salary, Overtime
-- ============================================================

SELECT
    d.depart_name                          AS "Department",
    r.role                                 AS "Job Title",
    TO_CHAR(s.salary_pa, 'FM R999,999,990.00') AS "Annual Salary",
    o.overtime_hours                       AS "Overtime Hours",
    e.first_name || ' ' || e.surname       AS "Employee"
FROM  Employees       e
LEFT JOIN Department     d ON e.depart_id   = d.depart_id
LEFT JOIN Roles          r ON e.role_id     = r.role_id
LEFT JOIN Salaries       s ON e.salary_id   = s.salary_id
LEFT JOIN Overtime_Hours o ON e.overtime_id = o.overtime_id
ORDER BY d.depart_name, e.surname;


-- ============================================================
-- 6. ADDITIONAL USEFUL QUERIES
-- ============================================================

-- Average salary per department
SELECT
    d.depart_name,
    ROUND(AVG(s.salary_pa), 2) AS avg_salary
FROM  Employees e
JOIN  Department d ON e.depart_id = d.depart_id
JOIN  Salaries   s ON e.salary_id = s.salary_id
GROUP BY d.depart_name
ORDER BY avg_salary DESC;

-- Employees with overtime > 10 hours
SELECT
    e.first_name || ' ' || e.surname AS employee,
    d.depart_name,
    r.role,
    o.overtime_hours
FROM  Employees       e
JOIN  Department     d ON e.depart_id   = d.depart_id
JOIN  Roles          r ON e.role_id     = r.role_id
JOIN  Overtime_Hours o ON e.overtime_id = o.overtime_id
WHERE o.overtime_hours > 10
ORDER BY o.overtime_hours DESC;
