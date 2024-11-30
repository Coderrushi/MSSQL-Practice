Use sample_db;
Select * From employee_info Order By empSalary;
Select * From department_info;

GO --creates new batch
Create Procedure sample_procedure
AS
BEGIN
	Select * 
	From
		employee_info
	ORDER BY
		empSalary;
END;

EXECUTE sample_procedure;
GO

--parametrized store procedure 
--Create a store procedure	that returns all employees whose dept location is Mumbai.
GO
CREATE PROCEDURE proc_findEmpByLocation(@location AS VARCHAR(20))
AS
BEGIN
	SELECT e.empId, e.empName, e.empJob, d.deptLocation FROM employee_info e
	INNER JOIN department_info d
	ON e.deptId = d.deptId;
END;
GO
EXECUTE proc_findEmpByLocation @location = 'Mumbai';

SELECT * FROM sys.sql_modules;