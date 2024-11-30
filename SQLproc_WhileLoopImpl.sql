USE sample_db;

SELECT * FROM employee_info;
GO
CREATE PROCEDURE proc_WhileLoopImpl
	AS
	BEGIN
			WHILE(SELECT MIN(empSalary) FROM employee_info) < 90000
			BEGIN
					UPDATE employee_info SET empSalary = empSalary + 10000;
					PRINT 'All Salaries are updated..';

					SELECT * FROM employee_info;

					IF(SELECT MIN(empSalary) FROM employee_info) >= 90000
						PRINT'Salary is greater than or equal to 90000';
						BREAK;
			END
	END
GO
EXECUTE proc_WhileLoopImpl;
GO