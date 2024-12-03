USE sample_db;

SELECT  * FROM employee_info;

SELECT * FROM employee_info FOR XML PATH;

SELECT * FROM employee_info FOR XML PATH ('EmployeeData'), ROOT('Employees');

SELECT [empId] AS "@employeeId", 
			[empName], 
			[empSalary], 
			[empJob],
			[empPhone],
			[deptId],
			[JoiningDate]
FROM employee_info
FOR XML PATH ('EmployeeData'), ROOT('Employees');

SELECT STUFF((SELECT ', ' + empName FROM employee_info FOR XML PATH('')), 1, 1, '');
