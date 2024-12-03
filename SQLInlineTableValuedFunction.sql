CREATE FUNCTION getAllEmployees(@salary DECIMAL)
RETURNS TABLE
AS
RETURN 
	SELECT * FROM employee_info WHERE empSalary = @salary;

SELECT * FROM dbo.getAllEmployees(95010);

SELECT * FROM employee_info;