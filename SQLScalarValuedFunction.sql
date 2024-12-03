USE sample_db;
SELECT * FROM employee_info;
--create a function to get employee salary by passing employee name.
CREATE FUNCTION func_CalculateSalary(@name AS VARCHAR(50))
RETURNS DECIMAL
	BEGIN
		DECLARE @sal AS DECIMAL(10,2)
		SELECT @sal = empSalary FROM employee_info
			WHERE empName = @name;
		RETURN @sal
	END;

SELECT dbo.func_CalculateSalary('Jane Smith') AS Salary;
SELECT * FROM employee_info;