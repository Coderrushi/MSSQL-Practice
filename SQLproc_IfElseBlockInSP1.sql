GO
USE sample_db;
GO
	CREATE PROCEDURE proc_IfElseBlockInSP
	AS
	BEGIN
		DECLARE @salary DECIMAL(10,2);
		SELECT @salary = AVG(empSalary) FROM employee_info
		SELECT @salary AS 'AVG_SALARY'
		IF @salary > 25000
			BEGIN
				PRINT'Average Salary is greater than 25000'
			END
	END
GO
EXECUTE dbo.proc_IfElseBlockInSP;
GO


GO
	CREATE PROCEDURE proc_IfElseBlockInSP1
	AS
	BEGIN
		DECLARE @salary DECIMAL(10,2);
		SELECT @salary = AVG(empSalary) FROM employee_info
		SELECT @salary AS 'AVG_SALARY'
		IF @salary > 25000
			BEGIN
				PRINT'Average Salary is greater than 25000'
			END
	   ELSE
			BEGIN
				PRINT'Average Salary is less than 25000'
			END
	END
GO
EXECUTE proc_IfElseBlockInSP1;
GO