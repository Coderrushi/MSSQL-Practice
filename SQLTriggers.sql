USE sample_db;
SELECT * FROM employee_info;

CREATE TRIGGER tr_message
ON employee_info
AFTER INSERT
AS 
	BEGIN
		PRINT 'Welcomw to our company..!';
	END;

ALTER TRIGGER tr_message
ON employee_info
AFTER INSERT
AS 
	BEGIN
		PRINT 'Welcome to our company..!';
	END;

INSERT INTO employee_info VALUES (6,'Kylie Jenner', 100000, 'Analyst', '9897969594', 20, '2024-05-14');
INSERT INTO employee_info VALUES (7,'Shane Warne', 90000, 'Tester', '8988878685', 20, '2024-06-20');

CREATE TABLE Employee_Audit_Test
(
	emp_id INT IDENTITY,
	Audit_Action TEXT
)

EXEC SP_RENAME 'Employee_Audit_Test.emp_id',  'empId', 'COLUMN';
EXEC SP_HELP 'Employee_Audit_Test';
EXEC SP_HELP 'employee_info';

CREATE OR ALTER TRIGGER tr_AfterInsert_Employee
ON employee_info
AFTER INSERT
AS 
	BEGIN
		DECLARE @Id INT
		SELECT TOP 1 @Id = empId  FROM inserted
		INSERT INTO Employee_Audit_Test (Audit_Action)
		VALUES('New employee with id= '+CAST(@Id AS VARCHAR(10)) + ' is added at '+ CAST(GETDATE() AS VARCHAR(20)))
	END;

CREATE OR ALTER TRIGGER tr_AfterDelete_Employee
ON employee_info
AFTER DELETE
AS 
	BEGIN
		DECLARE @Id INT
		SELECT @Id = empId  FROM deleted
		INSERT INTO Employee_Audit_Test 
		VALUES('An existing employee with id= '+CAST(@Id AS VARCHAR(10)) + ' is deleted at '+ CAST(GETDATE() AS VARCHAR(20)))
	END;

CREATE OR ALTER TRIGGER tr_AfterUpdate_Employee
ON employee_info
AFTER UPDATE
AS 
	BEGIN
		DECLARE @Id INT
		SELECT @Id = empId  FROM inserted
		INSERT INTO Employee_Audit_Test 
		VALUES('Information of an existing employee with id= '+CAST(@Id AS VARCHAR(10)) + ' is updated at '+ CAST(GETDATE() AS VARCHAR(20)))
	END;

SELECT * FROM employee_info;
INSERT INTO employee_info VALUES (8,'Mike Rollins', 105000, 'Developer', '7978777675', 10, '2024-03-20');
SELECT * FROM Employee_Audit_Test;
INSERT INTO employee_info VALUES (9,'Chris Adams', 105000, 'Developer', '6968676665', 10, '2024-03-20');
INSERT INTO employee_info VALUES (10,'Diana Fox', 105000, 'Developer', '5958575655', 10, '2024-03-20');
INSERT INTO employee_info VALUES (9,'Peter Watson', 90000, 'Tester', '4948474645', 20, '2024-06-20');

DELETE  FROM employee_info WHERE empId = 10;
DELETE  FROM employee_info WHERE empId = 120;
SELECT * FROM Employee_Audit_Test;

UPDATE employee_info SET empName = 'Diana Foxx' WHERE empId = 81;
UPDATE employee_info SET empName = 'Chris Adams' WHERE empId = 7;
SELECT * FROM Employee_Audit_Test;

EXEC SP_RENAME 'tr_Delete_Employee', 'tr_AfterDelete_Employee';
EXEC SP_RENAME 'tr_Insert_Employee', 'tr_AfterInsert_Employee';
EXEC SP_RENAME 'tr_Update_Employee', 'tr_AfterUpdate_Employee';