USE sample_db;
GO
ALTER PROCEDURE dbo.sample_procedure
AS
BEGIN 
	SELECT empId, empName, empSalary
	FROM employee_info
	ORDER BY empSalary;
END;
GO
EXECUTE dbo.sample_procedure;
EXECUTE dbo.proc_findEmpByLocation @location = 'Pune';