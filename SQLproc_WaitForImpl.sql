SELECT GETDATE();
GO
	CREATE PROCEDURE proc_WaitForTimeImpl
		AS
		BEGIN
			WAITFOR TIME '13:07:00'
			SELECT * FROM employee_info;
		END
GO

GO
	CREATE PROCEDURE proc_WaitForDelayImpl
		AS
		BEGIN
			WAITFOR DELAY '00:00:10'
			SELECT * FROM employee_info;
		END
GO
SELECT GETDATE();
GO
EXECUTE proc_WaitForTimeImpl;
EXECUTE proc_WaitForDelayImpl;

