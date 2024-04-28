--1. Display employees with their department names
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

--2. Find all projects employee with id 6 is working on
SELECT p.project_name
FROM projects p
JOIN project_assignments pa ON p.project_id = pa.project_id
WHERE pa.employee_id = 6;

--3. Count the number of employees in a particular department
SELECT COUNT(*)
FROM employees
WHERE department_id = 2;

--4. List all employees without a department
SELECT employee_id, first_name, last_name
FROM employees
WHERE department_id IS NULL;

--5. List employees and their managers
SELECT CONCAt(e.first_name, ' ', e.last_name) as employee_name,
       CONCAT(m.first_name, ' ', m.last_name) AS manager_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN employees m ON d.manager_id = m.employee_id
where e.first_name != m.first_name AND e.last_name != m.last_name;

--6. Calculate average salary per department 
WITH AvgSalaries AS (
    SELECT e.department_id, AVG(s.salary) AS avg_salary
    FROM employees e
    JOIN salaries s ON e.employee_id = s.employee_id
    GROUP BY e.department_id
)
SELECT d.department_name, COALESCE(a.avg_salary, 0) AS avg_salary
FROM departments d
LEFT JOIN AvgSalaries a ON d.department_id = a.department_id;

--7. Find the highest earners across departments 
WITH MaxSalary AS (
    SELECT department_id, MAX(salary) AS max_salary
    FROM salaries s
    JOIN employees e ON s.employee_id = e.employee_id
    GROUP BY department_id
)
SELECT CONCAT(e.first_name, ' ', e.last_name) AS employee_name, s.salary, d.department_name
FROM employees e
JOIN salaries s ON e.employee_id = s.employee_id
JOIN MaxSalary ms ON e.department_id = ms.department_id AND s.salary = ms.max_salary
JOIN departments d ON e.department_id = d.department_id
ORDER BY s.salary DESC;


--8. Rank employees within their department by salary
SELECT CONCAT(e.first_name, ' ', e.last_name) AS employee_name, e.department_id, s.salary,
       RANK() OVER (PARTITION BY e.department_id ORDER BY s.salary DESC) as salary_rank
FROM employees e
JOIN salaries s ON e.employee_id = s.employee_id;

--9. Create a procedure to add a new employee
CREATE OR REPLACE PROCEDURE add_employee(
    p_first_name VARCHAR,
    p_last_name VARCHAR,
    p_birth_date DATE,
    p_hire_date DATE,
    p_department_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO employees (first_name, last_name, birth_date, hire_date, department_id)
    VALUES (p_first_name, p_last_name, p_birth_date, p_hire_date, p_department_id);
END;
$$;

CALL add_employee('Wick', 'Ram', '1990-01-01', '2020-01-10', 1);

--10. Create a procedure to delete an employee
CREATE OR REPLACE PROCEDURE delete_employee(p_employee_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
	DELETE FROM project_assignments WHERE employee_id = p_employee_id;
    DELETE FROM salaries WHERE employee_id = p_employee_id;
    DELETE FROM employees WHERE employee_id = p_employee_id;
END;
$$;

CALL delete_employee(9);







