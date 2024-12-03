CREATE TABLE AuditTable (
DatabaseName nvarchar(250),
 TableName nvarchar(250),
 EventType nvarchar(250),
 LoginName nvarchar(250),
 SQLCommand nvarchar(2500),
 AuditDateTime datetime
)
GO

CREATE TABLE MyTable (Id int, Name NVARCHAR(50))

ALTER TABLE MyTable
ALTER COLUMN Name NVARCHAR(100)

DROP TABLE MyTable;

GO
CREATE OR ALTER TRIGGER tr_AuditTableChanges
ON ALL SERVER
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
BEGIN
 DECLARE @EventData XML
 SELECT @EventData = EVENTDATA()

 INSERT INTO sample_db.dbo.AuditTable 
 (DatabaseName, TableName, EventType, LoginName, SQLCommand, AuditDateTime)
 VALUES
 (
  @EventData.value('(/EVENT_INSTANCE/DatabaseName)[1]', 'varchar(250)'),
  @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(250)'),
  @EventData.value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(250)'),
  @EventData.value('(/EVENT_INSTANCE/LoginName)[1]', 'varchar(250)'),
  @EventData.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(2500)'),
  GetDate()
 ) 
END
GO
SELECT * FROM AuditTable;
GO

CREATE TRIGGER tr_EventData1
ON ALL SERVER
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
	BEGIN
		SELECT EVENTDATA()
	END
GO

