Use sample_db;
Select * From employee_info;
/*
Join on three columns
Suppose you have three tables: "Orders," "Customers," and "Products," with the following columns:
Orders: OrderID, CustomerID, ProductID, Quantity
Customers: CustomerID, CustomerName, Email
Products: ProductID, ProductName, Price
Write a SQL query to retrieve the order details (OrderID, CustomerName, ProductName, Quantity) 
for all orders, including orders without associated customer or product information. 
Use an appropriate join type.
*/
Select OrderID, CustomerName, ProductName, Quantity
From Orders O
Inner Join Customers C On O.CustomerID = C.CustomerID
Inner Join Products P On O.ProductID = P.ProductID
Order by OrderID;

-- first employee of the company by joining date
Select TOP(1)empName, JoiningDate
From employee_info
Order By JoiningDate;
--in case multiple employees join on same date
Select * 
From employee_info
Where JoiningDate = 
(Select MIN(JoiningDate) From employee_info);

Select empName, JoiningDate From employee_info;

--Find the employee whose name having maximum characters
Select TOP(1)empName, LEN(empName)
From employee_info
Order By LEN(empName) DESC;

-- In case multiple records have same length of name
Select *
From employee_info
Where LEN(empName) =
(Select MAX(LEN(empName)) From employee_info);

--Find employee salary from last eight months
SELECT empName, empSalary, JoiningDate
FROM employee_info
WHERE 
DATEDIFF(MONTH, JoiningDate, GETDATE()) < 8;

--find the employees having top 2 max salaries and 2 min salaries 
Select TOP(2)empSalary, empName
From employee_info
Order By empSalary DESC
Union All
Select TOP(2)empSalary, empName
From employee_info
Order By empSalary ASC;

