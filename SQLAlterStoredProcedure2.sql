USE [sample_db]
GO
/****** Object:  StoredProcedure [dbo].[proc_findEmpByLocation]    Script Date: 08-11-2024 11:10:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[proc_findEmpByLocation](@location AS VARCHAR(20))
AS
BEGIN
	SELECT DISTINCT e.empId, e.empName, d.deptLocation FROM employee_info e
	INNER JOIN department_info d
	ON e.deptId = d.deptId
	WHERE d.deptLocation = @location;
END;