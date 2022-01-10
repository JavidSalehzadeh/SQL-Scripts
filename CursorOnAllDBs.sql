DECLARE @dbName NVARCHAR(MAX) = ''
DECLARE dbName CURSOR FAST_FORWARD FOR
SELECT DISTINCT
    [Name]
FROM Didgah_Common..com_PhysicalDatabases
WHERE SoftwareGuid = '320EC7E4-E040-4574-BF8B-278D7B56EE18'
      AND [Name] NOT IN ( 'Didgah_Budgets_Capital' )
OPEN dbName
FETCH NEXT FROM dbName
INTO @dbName
WHILE @@FETCH_STATUS = 0
WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC ('INSERT INTO [Didgah_Budgets_Capital].[dbo].[bdg_EventLog]
           ([Guid]
           ,[UserGuid]
           ,[ReferenceType]
           ,[ReferenceGuid]
           ,[EventType]
           ,[Date]
           ,[Description]
           ,[ExtraDescription]
           ,[Deleted])
select [Guid]
           ,[UserGuid]
           ,[ReferenceType]
           ,[ReferenceGuid]
           ,[EventType]
           ,[Date]
           ,[Description]
           ,[ExtraDescription]
           ,[Deleted]
from ' + @dbName + '..bdg_EventLog')
    FETCH NEXT FROM dbName
    INTO @dbName
END
CLOSE dbName
DEALLOCATE dbName
