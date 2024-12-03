USE sample_db;

WITH EmployeesCTE(employeeId, Name, ManagerId, [Level])
AS
(
	SELECT employeeId, Name, ManagerId, 1
	FROM tblEmployee
	WHERE ManagerId IS NULL
	UNION ALL
	SELECT tblEmployee.EmployeeId, tblEmployee.Name, tblEmployee.ManagerId,
	EmployeesCTE.[Level] + 1
	FROM tblEmployee
	JOIN EmployeesCTE
	ON tblEmployee.ManagerId = EmployeesCTE.EmployeeId
)
SELECT EmpCTE.Name AS Employee, ISNULL(MgrCTE.Name, 'Super Boss') AS Manager,
EmpCTE.[Level]
FROM EmployeesCTE EmpCTE
LEFT JOIN EmployeesCTE MgrCTE
ON EmpCTE.ManagerId = MgrCTE.EmployeeId;


Create Table tblEmployee
(
  EmployeeId int Primary key,
  Name nvarchar(20),
  ManagerId int
)

Insert into tblEmployee values (1, 'Tom', 2)
Insert into tblEmployee values (2, 'Josh', null)
Insert into tblEmployee values (3, 'Mike', 2)
Insert into tblEmployee values (4, 'John', 3)
Insert into tblEmployee values (5, 'Pam', 1)
Insert into tblEmployee values (6, 'Mary', 3)
Insert into tblEmployee values (7, 'James', 1)
Insert into tblEmployee values (8, 'Sam', 5)
Insert into tblEmployee values (9, 'Simon', 1)

SELECT * FROM tblEmployee;

