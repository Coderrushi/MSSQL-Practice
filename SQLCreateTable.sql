use sample_db;

CREATE TABLE employee_info(
 empId INTEGER PRIMARY KEY,
 empName VARCHAR(50) NOT NULL,
 empSalary DECIMAL(10,2) NOT NULL,
 empJob VARCHAR(20),
 empPhone INTEGER UNIQUE,
 deptId INTEGER NOT NULL
);

CREATE TABLE department_info(
 deptId INTEGER NOT NULL,
 deptName VARCHAR(20) NOT NULL,
 deptLocation VARCHAR(20)
);
 
ALTER TABLE employee_info DROP CONSTRAINT UQ__employee__826C1DD77FCAE79B;


ALTER TABLE employee_info
ALTER COLUMN empPhone VARCHAR(20) NOT NULL;




--joins on three tables
--basics of sql dcl,dml,dql,ddl,tcl
--sub queries


