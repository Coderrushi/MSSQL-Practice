UPDATE employee_info 
SET empSalary = empSalary + 2000;

SELECT * FROM employee_info;

UPDATE employee_info 
SET empJob = 'Tester'
WHERE empId = 3;
SELECT * FROM employee_info;

DELETE FROM employee_info
WHERE empName = 'Shane';

DELETE FROM employee_info; --to delete all rows