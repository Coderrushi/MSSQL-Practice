USE sample_db;
GO
CREATE PROCEDURE proc_EmployeeByDeptId 
	AS
	BEGIN
		DECLARE @name VARCHAR(50), @salary INT, @DeptId INT = 10;
		SELECT @name = empName, @salary = empSalary FROM employee_info
		WHERE deptId = @DeptId;
		SELECT @name AS 'NAME', @salary AS 'Salary';
		BEGIN
			PRINT ('DEPARTMENT ID: ' + CAST(@DeptId AS VARCHAR(10)));
		END
	END
GO
EXECUTE dbo.proc_EmployeeByDeptId;
GO