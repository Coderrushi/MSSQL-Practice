USE sample_db;
GO
CREATE PROCEDURE proc_CaseStatementImpl
	AS
	BEGIN
		SELECT empName, empSalary,
		CASE
			WHEN empSalary < 100000 THEN '< 100000'
			WHEN empSalary > 100000 THEN '> 100000'
			WHEN empSalary = 100000 THEN '= 100000'
			ELSE 'No Category'
		END AS 'salary_info_table'
		FROM employee_info;
	END
GO
EXECUTE proc_CaseStatementImpl;
GO