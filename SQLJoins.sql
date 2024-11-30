USE sample_db;

Select * from employee_info;
Select * from department_info;

Insert Into department_info Values
(10, 'IT', 'Mumbai'),
(20, 'Quality Analysis', 'Pune'),
(30, 'HR', 'Mumbai');

Select e.empName, d.deptName
From employee_info as e
Inner join department_info as d
On e.deptId = d.deptId;

Select AVG(empSalary) From employee_info;

Select empName, empSalary
From employee_info
Where empSalary
> (Select AVG(empSalary) from employee_info);

Select e.empId, e.empName, e.empJob, e.empPhone, d.deptId, d.deptName, d.deptLocation, e.JoiningDate
From employee_info e
Left Outer Join department_info d
On e.deptId = d.deptId;

Select e.empId, e.empName, e.empJob, e.empPhone, d.deptId, d.deptName, d.deptLocation, e.JoiningDate
From employee_info e
Right Outer Join department_info d
On e.deptId = d.deptId;

Select e.empId, e.empName, e.empJob, e.empPhone, d.deptId, d.deptName, d.deptLocation, e.JoiningDate
From employee_info e
Full Outer Join department_info d
On e.deptId = d.deptId;
