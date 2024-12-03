CREATE VIEW vwEmployeesByDepartment
AS
SELECT empId, empName, empSalary, deptName, deptLocation
FROM employee_info
JOIN department_info
ON employee_info.deptId = department_info.deptId;
SELECT * FROM vwEmployeesByDepartment;

-- to see defination of view
sp_helptext vwEmployeesByDepartment; 

--to get column level security
CREATE VIEW vwITDeptEmployees
AS 
SELECT empId, empName, empSalary, deptName, deptLocation
FROM employee_info
JOIN department_info
ON employee_info.deptId = department_info.deptId
WHERE deptName = 'IT';
SELECT * FROM vwITDeptEmployees;

--to get column level security
CREATE  VIEW vwNonConfidentialData  
AS
SELECT empId, empName, deptName, deptLocation
FROM employee_info
JOIN department_info
ON employee_info.deptId = department_info.deptId;
SELECT * FROM vwNonConfidentialData;

-- used to present aggregated data
CREATE VIEW vwSumarizedData
AS
SELECT deptName, COUNT(empId) AS CountOfEmp
FROM employee_info
JOIN department_info
ON employee_info.deptId = department_info.deptId
GROUP BY deptName;
SELECT * FROM vwSumarizedData;