USE sample_db;
CREATE TABLE [tblEmployees]
(
 [Id] int Primary Key,
 [Name] nvarchar(50),
 [Salary] int,
 [Gender] nvarchar(10),
 [City] nvarchar(50)
)
Insert into tblEmployees Values(3,'John',4500,'Male','New York')
Insert into tblEmployees Values(1,'Sam',2500,'Male','London')
Insert into tblEmployees Values(4,'Sara',5500,'Female','Tokyo')
Insert into tblEmployees Values(5,'Todd',3100,'Male','Toronto')
Insert into tblEmployees Values(2,'Pam',6500,'Female','Sydney')
SELECT * FROM tblEmployees;

CREATE INDEX IX_employee_info_empSalary
ON tblEmployees (Salary ASC);

sp_helpIndex employee_info; --to see all available indexs on the table

--Composite Clustered Index
CREATE CLUSTERED INDEX IX_tblEmployees_Gender_Salary
ON tblEmployees (Gender DESC, Salary ASC) ;

DROP INDEX tblEmployees.PK__tblEmplo__3214EC070662DBAB;

CREATE NONCLUSTERED INDEX IX_tblEmployees_Name
ON tblEmployees (Name);
SELECT * FROM tblEmployees;

SET SHOWPLAN_TEXT ON;
SELECT * FROM tblEmployees WHERE Name = 'Sam';
SET SHOWPLAN_TEXT OFF;

sp_helpindex employee_info;