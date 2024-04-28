--1. PROJECTS table

CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE
);

--2. DEPARTMENTS table

CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    manager_id INT
);

--3. EMPLOYEES table

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE NOT NULL,
    hire_date DATE NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE SET NULL
);

--Add Foreign Key to Departments Table

ALTER TABLE departments
ADD CONSTRAINT fk_manager 
	FOREIGN KEY (manager_id) REFERENCES employees(employee_id) ON DELETE SET NULL;
	
--4. SALARIES TABLE

CREATE TABLE salaries (
    employee_id INT,
    salary DECIMAL(10, 2) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    PRIMARY KEY (employee_id, from_date),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

--5. PROJECT_ASSIGNMENTS table

CREATE TABLE project_assignments (
    project_id INT,
    employee_id INT,
    assignment_date DATE NOT NULL,
    PRIMARY KEY (project_id, employee_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id) ON DELETE CASCADE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

