
Select empName, empSalary, deptId
From employee_info;

Select * 
From department_info;

--display name, salary of the employees whose salary is greater than Mike's salary
Select empName, empSalary 
From employee_info
Where empSalary >
(Select empSalary From employee_info Where empName = 'Mike Johnson');

--display name, salary of the employees whose salary is greater than John's salary and deptId is same as Mike's deptId
Select empName, empSalary, deptId
From employee_info
Where empSalary >
(Select empSalary From employee_info Where empName = 'John Doe')
And deptId = (Select deptId From employee_info Where empName = 'John Doe');

--display the emp information whose department is located in Pune
Select * 
From employee_info
Where deptId =
(Select Distinct deptId From department_info Where deptLocation = 'Pune');