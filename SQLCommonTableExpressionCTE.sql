use sample_db;
select * from employee_info;
select * from department_info;

WITH cte_EmployeeCount(deptId, totalEmps)
AS
(
	SELECT  deptId, COUNT(*) AS totalEmps
	FROM employee_info
	GROUP BY deptId
)
SELECT DISTINCT deptName, totalEmps
FROM department_info d
JOIN cte_EmployeeCount e
ON d.deptId = e.deptId
ORDER BY totalEmps;

--creating more than one cte using single WITH clause
WITH cte_EmployeesCountBy_HR_IT_Dept(deptName, Total)
AS
(	
	SELECT deptName, COUNT(empId) AS Total
	FROM employee_info e
	JOIN department_info d ON e.deptId = d.deptId
	WHERE deptName IN('HR', 'IT')
	GROUP BY deptName
),
cte_EmployeesCountBy_IT_QA_Dept(deptName, Total)
AS
(
	SELECT deptName, COUNT(empId) AS Total
	FROM employee_info e
	JOIN department_info d ON e.deptId = d.deptId
	WHERE deptName IN('IT', 'Quality Analysis')
	GROUP BY deptName
)
SELECT * FROM cte_EmployeesCountBy_HR_IT_Dept
UNION
SELECT * FROM cte_EmployeesCountBy_IT_QA_Dept
