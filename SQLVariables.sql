declare @myName varchar(20)
set @myName = 'Hrushikesh'
print @myName

USE sample_db;
SELECT * FROM employee_info;
SELECT * FROM department_info;
--Storing query result into  a variable
GO
DECLARE @employee_count INT;
SET @employee_count = (
	SELECT 
		COUNT(*)
	FROM 
		employee_info
);
GO
PRINT('Employee count: '+ CAST(@employee_count AS VARCHAR(10)));
GO


