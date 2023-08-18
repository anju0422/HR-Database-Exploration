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


