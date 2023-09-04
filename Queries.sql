/* Tool used - MySQL Workbench
    Author - Anju Saini */

/* We have total of 8 tables for Analysis */

SELECT * FROM Employees;
SELECT * FROM Departments;
SELECT * FROM Jobs;
SELECT * FROM Job_History;
SELECT * FROM Locations;
SELECT * FROM Countries;
SELECT * FROM Regions; 
SELECT * FROM Job_Grade;

/* Number of records present in each table */

SELECT "Employees" AS Table_name, COUNT(*) AS Number_of_rows FROM Employees
UNION ALL 
SELECT "Departments" AS Table_name, COUNT(*) AS Number_of_rows FROM Departments
UNION ALL 
SELECT "Jobs" AS Table_name, COUNT(*) AS Number_of_rows FROM Jobs
UNION ALL 
SELECT "Job_history" AS Table_name, COUNT(*) AS Number_of_rows FROM Job_History
UNION ALL 
SELECT "Locations" AS Table_name, COUNT(*) AS Number_of_rows FROM Locations
UNION ALL 
SELECT "Countries" AS Table_name, COUNT(*) AS Number_of_rows FROM Countries
UNION ALL 
SELECT "Regions" AS Table_name, COUNT(*) AS Number_of_rows FROM Regions
UNION ALL 
SELECT "Job_grade" AS Table_name, COUNT(*) AS Number_of_rows FROM Job_Grade;


/* Q1: Retrieve a list of employees with their manager's name. */
 
 SELECT 
 CONCAT(e.first_name, " ", e.last_name) AS Employee_name,
 CONCAT(m.first_name," ", m.last_name) AS Manager_name
 FROM Employees e 
 JOIN Employees m 
 ON e.manager_id = m.employee_id
 ORDER BY Employee_name;
 
 /* Q2: Find employees who have a higher salary than their manager */
 
 SELECT
 e.employee_id,
 CONCAT(e.first_name, " ", e.last_name) AS Emp_name
 FROM Employees e 
 JOIN Employees m 
 ON e.manager_id = m.employee_id 
 WHERE e.salary > m.salary
 ORDER BY Emp_name;
 
 /* Q3. Write a CTE to find the department with the highest number of employees.*/
 
 WITH CTE AS (
 SELECT
 d.department_name,
 COUNT(e.employee_id) AS Total_employees,
 DENSE_RANK() OVER (ORDER BY COUNT(e.employee_id) DESC) AS rnk
 FROM Employees e
 JOIN Departments d
 ON d.department_id = e.department_id
 GROUP BY d.department_name
 ) 
     SELECT 
     department_name 
     FROM CTE 
     WHERE rnk = 1;
     
/* Q4. Write a query to get the names (first_name, last_name), salary, PF of all the employees (PF is calculated as 15% of salary). */

SELECT 
CONCAT(first_name," ", last_name) AS Emp_name,
salary AS Salary,
salary * 0.15 AS PF
FROM Employees 
ORDER BY Emp_name; 

/* Q4. Write a query to find the name (first_name, last_name) and the salary of the employees who have a higher salary 
       than the employee whose last_name='Bull'. */

SELECT 
CONCAT(first_name," ", last_name) AS Emp_name,
salary 
FROM Employees
WHERE salary > (SELECT 
                salary
                FROM Employees 
                WHERE last_name = "Bull");

/* Q5. Write a query to find the name (first_name, last_name) of the employees who have a manager working in a US-based department. */

SELECT 
e.first_name,
e.last_name
FROM Employees e
JOIN Employees m 
ON e.manager_id = m.employee_id
JOIN Departments d 
ON m.department_id = d.department_id
JOIN Locations l 
ON d.location_id = l.location_id  
WHERE (l.country_id) = "US";

/* Q6.  Write a query to find the name (first_name, last_name), and salary of the employees whose salary is 
  greater than their department's average salary.*/

WITH CTE AS(
SELECT
first_name,
last_name, 
department_id,
AVG(salary) OVER (PARTITION BY department_id) AS avg_sal,
salary 
FROM employees
) 
    SELECT 
    first_name,
    last_name,
    salary
    FROM CTE 
    WHERE salary > avg_sal;

/* Q7. Write a query to find the name (first_name, last_name), and salary of the employees who earn more than 
       the average salary and work in any of the IT departments. */

 SELECT 
   first_name,
   last_name,
   salary
   FROM employees e 
   JOIN departments d 
   ON e.department_id = d.department_id
   WHERE salary > (SELECT AVG(salary) FROM employees) 
   AND d.department_name LIKE "IT%";

/* Q8.  Write a query to find the name (first_name, last_name), and salary of the employees who earn the same salary as 
        the minimum salary for all departments. */

   WITH CTE AS( 
   SELECT 
   first_name,
   last_name,
   department_id,
   salary,
   MIN(salary) OVER (PARTITION BY department_id) AS min_sal
   FROM employees
   ) 
        SELECT 
        first_name,
        last_name,
        salary
        FROM CTE 
        WHERE salary = min_sal;

/* Q9. Write a query to retrieve the names of managers who have a minimum of five employees reporting directly to them. 
       The list of managers should be sorted in alphabetical order */

  WITH CTE AS(
  SELECT
  manager_id,
  COUNT(manager_id) AS emp_rep_cnt
  FROM Employees  
  GROUP BY manager_id
  HAVING COUNT(manager_id) >=5
  ) 
      SELECT 
      CONCAT(e.first_name, " ", e.last_name) AS Manager_name
      FROM Employees e 
      JOIN CTE c 
      ON e.employee_id = c.manager_id
      ORDER BY Manager_name ASC;

/* Q10. A company's executives are interested in seeing who earns the most money in each of the company's departments. 
        A high earner in a department is an employee who has a salary in the top three unique salaries for that department.
        Write a solution to find the employees who are high earners in each of the departments. Return the result table in any order. */

 WITH CTE AS(
 SELECT 
 CONCAT(e.first_name, " ", e.last_name) AS Employee,
 d.department_name AS Department,
 e.salary AS Salary,
 DENSE_RANK() OVER(PARTITION BY e.department_id ORDER BY e.salary DESC) AS rnk
 FROM Employees e 
 JOIN Departments d 
 ON e.department_id = d.department_id
) 
   SELECT 
   Department,
   Employee,
   Salary 
   FROM CTE 
   WHERE rnk IN (1,2,3)
   ORDER BY Salary DESC;







