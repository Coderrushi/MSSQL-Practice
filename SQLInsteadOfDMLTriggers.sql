USE demo_db;

CREATE TABLE Department
(
  ID INT PRIMARY KEY,
  Name VARCHAR(50)
)

INSERT INTO Department VALUES(1, 'IT')
INSERT INTO Department VALUES(2, 'HR')
INSERT INTO Department VALUES(3, 'Sales')

CREATE TABLE Employee
(
  ID INT PRIMARY KEY,
  Name VARCHAR(50),
  Gender VARCHAR(50),
  DOB DATETIME,
  Salary DECIMAL(18,2),
  DeptID INT
)

INSERT INTO Employee VALUES(1, 'Pranaya', 'Male','1996-02-29 10:53:27.060', 25000, 1)
INSERT INTO Employee VALUES(2, 'Priyanka', 'Female','1995-05-25 10:53:27.060', 30000, 2)
INSERT INTO Employee VALUES(3, 'Anurag', 'Male','1995-04-19 10:53:27.060',40000, 2)
INSERT INTO Employee VALUES(4, 'Preety', 'Female','1996-03-17 10:53:27.060', 35000, 3)
INSERT INTO Employee VALUES(5, 'Sambit', 'Male','1997-01-15 10:53:27.060', 27000, 1)
INSERT INTO Employee VALUES(6, 'Hina', 'Female','1995-07-12 10:53:27.060', 33000, 2)

CREATE VIEW vwEmployeeDetails
AS
SELECT emp.ID, emp.Name, Gender, Salary, dept.Name AS Department
FROM Employee emp
INNER JOIN Department dept
ON emp.DeptID = dept.ID;

INSERT INTO vwEmployeeDetails VALUES(7, 'Saroj', 'Male', 110000, 'IT');
DROP TRIGGER tr_vwEmployeeDetails_InsteadOfInsert;

SELECT * FROM vwEmployeeDetails;

--INSTEAD OF INSERT Trigger
CREATE OR ALTER TRIGGER tr_vwEmployeeDetails_InsteadOfInsert
ON vwEmployeeDetails
INSTEAD OF INSERT
AS
	BEGIN
		DECLARE @DepartmentId INT

		SELECT @DepartmentId = dept.ID
		FROM Department dept
		INNER JOIN inserted inst
		ON inst.Department = dept.Name
		IF(@DepartmentId IS NULL)
		BEGIN 
			RAISERROR('Invalid Department Name. Statement terminated', 16, 1)
			RETURN
		END
		INSERT INTO Employee(ID, Name, Gender, Salary, DeptID)
		SELECT ID, Name, Gender, Salary, @DepartmentId
		FROM inserted
	END;

INSERT INTO vwEmployeeDetails VALUES(7, 'Saroj', 'Male', 110000, 'IT');
SELECT * FROM vwEmployeeDetails;
SELECT * FROM Employee;

--INSTEAD OF DELETE Trigger
CREATE TRIGGER tr_vwEmployeeDetails_InsteadOfDelete
ON vwEmployeeDetails
INSTEAD OF DELETE
AS
	BEGIN
		DELETE FROM Employee
		FROM Employee emp
		INNER JOIN deleted del
		ON emp.ID = del.ID
	END;

DELETE FROM vwEmployeeDetails WHERE ID = 1;