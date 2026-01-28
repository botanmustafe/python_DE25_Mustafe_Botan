-- Varje gång jag ska ändra i filen använder jag read solution 
-- 
CREATE SCHEMA IF NOT EXISTS staging;

CREATE TABLE
    IF NOT EXISTS staging.employees (
        employee_id INTEGER,
        department VARCHAR,
        employment_year INTEGER
    );

INSERT INTO
    staging.employees (employee_id, department, employment_year)
VALUES
    (1, 'Sales', 2001),
    (2, 'IT', 2002),
    (3, 'Logistics', 2003);