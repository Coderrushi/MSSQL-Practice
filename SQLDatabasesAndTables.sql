Select * from employee_info;

EXEC sp_helpdb; -- to see all available databases

EXEC sp_help 'employee_info'; --to see the structure of table

use payroll_service;

--to see available tables in database
SELECT name AS TableName 
FROM sys.tables;