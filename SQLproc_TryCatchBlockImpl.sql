GO
USE sample_db;
GO
	CREATE PROCEDURE proc_TryCatchBlockImpl
		AS
		BEGIN TRY
			SELECT 100/0 AS 'Divison';
		END TRY
		BEGIN CATCH
			SELECT ERROR_MESSAGE() AS 'Error Message',
			ERROR_LINE() AS 'Error Line',
			ERROR_NUMBER() AS 'Error Number',
			ERROR_PROCEDURE() AS 'Error Procedure',
			ERROR_STATE() AS 'Error State',
			ERROR_SEVERITY() AS 'Error Severity';
		END CATCH
GO
EXECUTE proc_TryCatchBlockImpl;
GO