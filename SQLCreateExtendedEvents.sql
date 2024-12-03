USE sample_db;

SELECT * FROM employee_info;
SELECT empId, empName, empSalary
FROM employee_info;

INSERT INTO employee_info VALUES (
9, 'Chritsian Dior', 100000, 'Designer', '9899979695', 30, '2024-04-15');

UPDATE employee_info
SET empSalary = 110000
WHERE empId = 9;

DELETE FROM employee_info
WHERE empId = 9;


SELECT eqs.query_hash, est.text
FROM sys.dm_exec_query_stats eqs
CROSS APPLY
sys.dm_exec_sql_text (eqs.sql_handle) est
where est.text LIKE '%SELECT empId, empName, empSalary
FROM employee_info;%'

-- sys.dm_exec_query_stats -> it is a DME
-- sys.dm_exec_sql_text() -> it is  a DMF (Dynamic Management Function) which requires one parameter
-- both are dynamic object
-- we are using APPLY operator which means sys.dm_exec_sql_text() this function is going to be applied 
-- to every record comming out of query 'sys.dm_exec_query_stats' using sql_handle