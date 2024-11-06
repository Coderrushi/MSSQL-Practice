USE sample_db;

SELECT * FROM employee_info ORDER BY empSalary DESC;

SELECT empName FROM employee_info ORDER BY empName;

SELECT * FROM employee_info
WHERE empSalary > 30000 AND empSalary < 40000
ORDER BY empName;

SELECT TOP(2)*  --TOP to limit the rows in sql server
FROM employee_info
ORDER BY empSalary DESC;

--find the total salary for departments where each employee’s salary is greater than 30,000
--using where clause
SELECT deptId, SUM(empSalary) AS Total_salary
FROM employee_info
WHERE empSalary > 30000
GROUP BY deptId;
--using having clause
select deptId, sum(empSalary) 
from employee_info
group by deptId
having empSalary > 30000;

--Having clause without Group By clause
Select SUM(empSalary)
From employee_info
Having SUM(empSalary) > 20000;

--TOP clause
Select TOP(3)empSalary, empName
From employee_info
Order By empSalary DESC;

--OFFSET & FETCH clause
Select * 
From employee_info
Order By empId DESC
OFFSET 2 ROWS
FETCH NEXT 1 ROW ONLY;

