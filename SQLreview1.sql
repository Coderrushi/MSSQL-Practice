
USE demo_db;

--1.Create a table named "Employees" with columns for employee ID, name, age, and department.
CREATE TABLE Employees (
	employeeId INT IDENTITY(1,1),
	epmName VARCHAR(50) NOT NULL,
	empAge int NOT NULL,
	department VARCHAR(30) NOT NULL);

EXECUTE sp_rename 'Employees.epmName', 'empName';
--2.Add a new column named "Salary" to the "Employees" table.
ALTER TABLE Employees
ADD Salary INT NOT NULL;

--3.Rename the column "Department" to "Dept" in the "Employees" table.
EXECUTE sp_rename 'Employees.department', 'Dept';

--4.Insert a new employee record into the "Employees" table.
--INSERT INTO Employees VALUES ('John', 24, 'IT', 35000);
INSERT INTO Employees VALUES ('Aaron', 24, 'IT', 35000);
INSERT INTO Employees VALUES ('Sophie', 25, 'HR', 45000);
INSERT INTO Employees VALUES ('Jack', 30, 'Finance', 45000);
INSERT INTO Employees VALUES ('Rocky', 27, 'HR', 65000);
INSERT INTO Employees VALUES ('Shane', 26, 'IT', 35000);

--5.Update the salary of employee with ID 1 to 55000.00 in the "Employees" table.
UPDATE Employees
SET Salary = 55000
WHERE employeeId = 1;

--6.Delete all records from the "Employees" table where the age is less than 25.
DELETE Employees
WHERE empAge < 25;

--7.Retrieve the names of employees in alphabetical order.
SELECT empName 
FROM Employees
ORDER BY empName;

--8.Retrieve the names and salaries of the first 3 highest-paid employees.
SELECT  TOP(3)Salary, empName
FROM Employees
ORDER BY Salary DESC;

--9.Retrieve the names of employees whose names start with the letter 'R' amd endswith 'Y'.
SELECT empName 
FROM Employees
WHERE empName LIKE 'R%Y';

--10.Skip first 3 data and retrieve next data from table.
SELECT * 
FROM Employees
ORDER BY Salary
OFFSET 3 ROWS
FETCH NEXT 1 ROWS ONLY;

SELECT * FROM Employees
ORDER BY Salary;




/*
Suppose you have three tables: "Orders," "Customers," and "Products," with the following columns:
Orders: OrderID, CustomerID, ProductID, Quantity
Customers: CustomerID, CustomerName, Email
Products: ProductID, ProductName, Price
Write a SQL query to retrieve the order details (OrderID, CustomerName, ProductName, Quantity) for all orders,
including orders without associated customer or product information. Use an appropriate join type.
*/
SELECT O.OrderID, C.CustomerName, P.ProductName, O.Quantity
FROM Orders O
INNER JOIN Customers C ON O.CustomerID = C.CustomerID
INNER JOIN Products P ON O.ProductID = P.ProductID;

USE sample_db;
Select * from employee_info;
Select * from department_info;

SELECT deptId
FROM employee_info
GROUP BY deptId
HAVING max(empSalary);

SELECT deptId, COUNT(*)
FROM employee_info
GROUP BY deptId;

SELECT TOP 1 d.deptId, d.deptName, COUNT(e.empId) AS empCount
FROM department_info d
JOIN employee_info e
ON d.deptId = e.deptId
GROUP BY d.deptId, d.deptName
ORDER BY empCount DESC;

SELECT * 
FROM department_info
WHERE deptId IN
(SELECT TOP 1 deptId FROM employee_info GROUP BY deptId ORDER BY deptId ASC);

SELECT * FROM employee_info;
SELECT * FROM department_info WHERE deptId IN
(
	(
		SELECT deptId FROM employee_info
		GROUP BY deptId
		HAVING COUNT(deptId) in
	(	SELECT TOP 1 COUNT(deptId) AS numberofEmp 
		FROM employee_info 
		GROUP BY deptId 
		ORDER BY COUNT(deptId) desc
	)
	)
);

USE sample_db;
SELECT * FROM employee_info;
SELECT * FROM department_info;

SELECT d.deptId, d.deptName, COUNT(empId) AS total
FROM employee_info e
INNER JOIN department_info d
ON e.deptId = d.deptId
GROUP BY d.deptId, d.deptName
HAVING d.deptId IN
(SELECT TOP 1 COUNT(d.deptId) AS numOfEmp
 FROM employee_info GROUP BY deptId ORDER BY COUNT(d.deptId) DESC);

WITH cte_DeptWiseEmployees AS (
	SELECT d.deptId, d.deptName, COUNT(empId) AS Total
	FROM department_info d
	INNER JOIN employee_info e
	ON d.deptId = e.deptId
	GROUP BY d.deptId, d.deptName
),
MaxEmpCount AS (
	SELECT MAX(Total) AS MaxCount FROM cte_DeptWiseEmployees)

SELECT d.deptId, d.deptName, d.Total
FROM cte_DeptWiseEmployees d
INNER JOIN MaxEmpCount m
ON d.Total = m.MaxCount;
