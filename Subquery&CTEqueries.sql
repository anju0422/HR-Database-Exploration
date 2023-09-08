/* Toolused - MySQL
   Author - Anju Saini */

--  We have total of 8 tables for analysis 

SELECT * FROM Employees;
SELECT * FROM Departments;
SELECT * FROM Jobs;
SELECT * FROM Job_History;
SELECT * FROM Locations;
SELECT * FROM Countries;
SELECT * FROM Regions; 
SELECT * FROM Job_Grade;


/* Q1. Write a query to find the name (first_name, last_name) and the salary of the employees who have a higher 
       salary than the employee whose last_name='Bull'. */

SELECT 
CONCAT(first_name," ", last_name) AS name,
salary
FROM Employees
WHERE salary > (SELECT
                salary
                FROM Employees
                WHERE last_name LIKE "%Bull");

/* Q2.  Write a query to find the name (first_name, last_name) of all employees who works in the IT department. */

    SELECT
    CONCAT(first_name, " ", last_name) AS name
    FROM Employees  
    WHERE department_id IN (SELECT department_id FROM Departments WHERE department_name = "IT");

/* Q3. Write a query to find the name (first_name, last_name) of the employees who have a manager and 
       worked in a USA based department. */

SELECT
CONCAT(e.first_name, " ", e.last_name) AS name
FROM Employees e
JOIN Employees m 
ON e.manager_id = m.employee_id
WHERE m.department_id IN ( SELECT
                           department_id
                           FROM Departments d
                           JOIN Locations l 
                           ON d.location_id = l.location_id 
                           WHERE l.country_id = "US");
                           











