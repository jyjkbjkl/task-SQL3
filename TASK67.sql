
-- 1. Create database
CREATE DATABASE CompanyDB;
GO

-- 2. Use database
USE CompanyDB;
GO

-- 3. Create schema
CREATE SCHEMA Sales;
GO

-- 4. Create sequence 
CREATE SEQUENCE Sales.employee_seq
    START WITH 1
    INCREMENT BY 1;
GO

-- 5. Create employees table
CREATE TABLE Salesemployees (
    employee_id INT PRIMARY KEY DEFAULT NEXT VALUE FOR Sales.employee_seq,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    salary DECIMAL(10, 2),
    hire_date DATE
);
GO

-- 6. Insert mock data
INSERT INTO Sales.employees (first_name, last_name, salary, hire_date) VALUES
('ahmed', 'mohamed', 52000.00, '2020-05-15'),
('reem', 'mohamed', 48000.00, '2019-03-20'),
('mohamed', 'ahmed', 61000.00, '2021-07-10'),
('eslam', 'khaled', 45000.00, NULL),
('ali', 'ebrahem', 57000.00, '2020-12-01');
GO

-- 7. Queries
SELECT * FROM Sales.employees;
SELECT first_name, last_name FROM Sales.employees;
SELECT first_name + ' ' + last_name AS full_name FROM Sales.employees;
SELECT AVG(salary) AS average_salary FROM Sales.employees;
SELECT * FROM Sales.employees WHERE salary > 50000;
SELECT * FROM Sales.employees WHERE YEAR(hire_date) = 2020;
SELECT * FROM Sales.employees WHERE last_name LIKE 'S%';
SELECT TOP 10 * FROM Sales.employees ORDER BY salary DESC;
SELECT * FROM Sales.employees WHERE salary BETWEEN 40000 AND 60000;
SELECT * FROM Sales.employees WHERE first_name LIKE '%man%' OR last_name LIKE '%man%';
SELECT * FROM Sales.employees WHERE hire_date IS NULL;
SELECT * FROM Sales.employees WHERE salary IN (40000, 45000, 50000);
SELECT * FROM Sales.employees WHERE hire_date BETWEEN '2020-01-01' AND '2021-01-01';
SELECT * FROM Sales.employees ORDER BY salary DESC;
SELECT TOP 5 * FROM Sales.employees ORDER BY last_name ASC;
SELECT * FROM Sales.employees WHERE salary > 55000 AND YEAR(hire_date) = 2020;
SELECT * FROM Sales.employees WHERE first_name IN ('ahmed', 'reem');
SELECT * FROM Sales.employees WHERE salary <= 55000 AND hire_date > '2022-01-01';
SELECT * FROM Sales.employees WHERE salary > (SELECT AVG(salary) FROM Sales.employees);
SELECT * FROM (
  SELECT *, ROW_NUMBER() OVER (ORDER BY salary DESC) AS rn FROM Sales.employees
) AS ranked WHERE rn BETWEEN 3 AND 7;
SELECT * FROM Sales.employees WHERE hire_date > '2021-01-01' ORDER BY first_name ASC;
SELECT * FROM Sales.employees WHERE salary > 50000 AND last_name NOT LIKE 'A%';
SELECT * FROM Sales.employees WHERE salary IS NOT NULL;
SELECT * FROM Sales.employees WHERE (first_name LIKE '%e%' OR first_name LIKE '%i%' OR last_name LIKE '%e%' OR last_name LIKE '%i%') AND salary > 45000;
GO

-- 8. Create departments table
CREATE TABLE Sales.departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    manager_id INT FOREIGN KEY REFERENCES Sales.employees(employee_id)
);
GO

-- 9. Add department_id to employees
ALTER TABLE Sales.employees ADD department_id INT;
ALTER TABLE Sales.employees ADD CONSTRAINT FK_Employee_Department FOREIGN KEY (department_id) REFERENCES Sales.departments(department_id);
GO

-- 10. Join queries
SELECT e.*, d.department_name FROM Sales.employees e INNER JOIN Sales.departments d ON e.department_id = d.department_id;
SELECT e.* FROM Sales.employees e LEFT JOIN Sales.departments d ON e.department_id = d.department_id WHERE d.department_id IS NULL;
SELECT d.department_name, COUNT(e.employee_id) AS employee_count FROM Sales.departments d LEFT JOIN Sales.employees e ON d.department_id = e.department_id GROUP BY d.department_name;
SELECT d.department_name, e.first_name, e.last_name, e.salary FROM Sales.departments d JOIN Sales.employees e ON d.department_id = e.department_id WHERE e.salary = (
  SELECT MAX(salary) FROM Sales.employees WHERE department_id = d.department_id
);
SELECT d.department_name, AVG(e.salary) AS avg_salary FROM Sales.departments d JOIN Sales.employees e ON d.department_id = e.department_id GROUP BY d.department_name;
GO

-- 11. Insert new employee
INSERT INTO Sales.employees (first_name, last_name, salary, hire_date, department_id) VALUES ('mohamed', 'eslam', 47000.00, '2023-03-15', 1);
GO

-- 12. Update salaries
UPDATE Sales.employees SET salary = 46000 WHERE salary < 45000;
GO

-- 13. Delete employees with NULL hire_date
DELETE FROM Sales.employees WHERE hire_date IS NULL;
GO

-- 14. Create index
CREATE INDEX idx_salary ON Sales.employees (salary);
GO
