CREATE DATABASE HR;
GO
USE HR;
drop table Employees
CREATE TABLE Employees (
  Id int IDENTITY PRIMARY KEY,
  FirstName varchar(50) NOT NULL,
  LastName varchar(50) NOT NULL
);
INSERT INTO Employees (FirstName, LastName)VALUES
('John', 'Doe'),
('Jane', 'Doe');

SELECT * FROM Employees;

CREATE DATABASE HR_Snapshots
ON (NAME = HR, FILENAME = 'F:\db_snapshots1\hr.ss')
AS SNAPSHOT OF HR;

DELETE FROM Employees
WHERE Id = 2;

SELECT * FROM Employees;

USE HR_Snapshots;

SELECT * FROM Employees;

USE master;

RESTORE DATABASE HR 
FROM DATABASE_SNAPSHOT = 'HR_Snapshots';

USE HR;

SELECT * FROM Employees;


--2nd snapshot
CREATE DATABASE HR_Snapshots1
ON (NAME = HR, FILENAME = 'F:\db_snapshots\hr1.bak')
AS SNAPSHOT OF HR;

DELETE FROM Employees
WHERE Id = 2;

SELECT * FROM Employees;

USE HR_Sanpshots1;

SELECT * FROM Employees;

USE MASTER;

RESTORE DATABASE HR 
FROM DATABASE_SNAPSHOT = 'HR_Sanpshots1';

USE HR;

SELECT * FROM Employees;