use sample_db;


--(1, 'Adam', 25000, 'Jr. Developer', '9878578382', 10),
--(2, 'Shane', 45000, 'Sr. Developer', '9878578382', 10),
INSERT INTO employee_info Values
(4, 'Jack', 35000, 'Tester', '9778578302', 10),
(5, 'Ellie', 40000, 'Sr. HR', '8078578389', 30),
(6, 'Sophie', 45000, 'Jr. HR', '9178578388', 30);

INSERT INTO employee_info(empId, empName, empSalary, empPhone, deptId) Values
(3, 'Matt', 30000, '9089706050', 20);

Select * from employee_info;

Select empName, empSalary from employee_info;

TRUNCATE TABLE employee_info;

INSERT INTO employee_info (empId, empName, empSalary, empJob, empPhone, deptId, JoiningDate) VALUES
(1, 'John Doe', 50000, 'Manager', 1234567890, 101, '2024-01-15'),
(2, 'Jane Smith', 45000, 'Analyst', 1234567891, 102, '2024-02-20'),
(3, 'Mike Johnson', 55000, 'Developer', 1234567892, 101, '2024-03-10'),
(4, 'Emily Davis', 60000, 'Designer', 1234567893, 103, '2024-04-05'),
(5, 'Chris Brown', 58000, 'Tester', 1234567894, 102, '2024-04-05');

Update employee_info
Set deptId =
Case
	When deptId = 101 Then 10
	When deptId = 102 Then 20
	When deptId = 103 Then 30
	Else deptId
End;
