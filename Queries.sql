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


