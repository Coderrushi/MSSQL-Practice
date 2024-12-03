--create a sp for finding nth max. salary from the table if value is negative it should throw an error.
USE sample_db;
Select * from employee_info
GO
CREATE OR ALTER PROCEDURE proc_FindingNthMaxSalary
	@n INT
AS
	BEGIN 
		IF @n <= 0
		BEGIN
			RAISERROR('Invalid Input', 16, 1);
			RETURN;
		END

		BEGIN TRY
		    SELECT * FROM employee_info WHERE empSalary = (
			SELECT DISTINCT empSalary
			FROM employee_info
			ORDER BY empSalary DESC
			OFFSET(@n - 1) ROWS
			FETCH NEXT 1 ROWS ONLY);
		END TRY

		BEGIN CATCH
			RAISERROR('Error Occurred..', 16, 1);
		END CATCH
	END 
GO
EXEC proc_FindingNthMaxSalary @n = 3;
GO
