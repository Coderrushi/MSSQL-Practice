CREATE DATABASE EXAMPLE_DB;

USE sample_db;

Select * 
From employee_info;

Use EXAMPLE_DB;

Select * Into EMP_DETAILS
From sample_db.dbo.employee_info;

Select *
From EMP_DETAILS;

