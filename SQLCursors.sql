USE sample_db;

DECLARE @emp_id int, @emp_name VARCHAR(20);

PRINT '------ EMPLOYEE DETAILS ------';

DECLARE emp_cursor CURSOR FOR
SELECT empId, empName
FROM employee_info
ORDER BY empId;

OPEN emp_cursor

FETCH NEXT FROM emp_cursor
INTO @emp_id, @emp_name

PRINT 'Employee ID     Employee_name';
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT '     ' + CAST(@emp_id AS VARCHAR(20)) + '          ' +
				@emp_name
	FETCH NEXT FROM emp_cursor INTO @emp_id, @emp_name
END
CLOSE emp_cursor
DEALLOCATE emp_cursor


