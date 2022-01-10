

EXEC sp_MSforeachtable 'SELECT * FROM ?'
------------------------------------------------------------------

--You can even use ? sign in WHERE clause.

EXEC sp_MSforeachdb 'IF ''?''  NOT IN (''tempDB'',''model'',''msdb'')
BEGIN
       SELECT name,physical_name,state,size
       FROM ?.sys.database_files
       WHERE name  LIKE ''?%'' -- Only Files starting with DB name
END'
------------------------------------------------------------------------------
EXEC sp_MSforeachdb 'IF ''?''  like ''%Didgah_FinancialAccounting%'' and ''?'' not in (''Didgah_FinancialAccounting05''
,''Didgah_FinancialAccounting_Operational'',''Didgah_FinancialAccounting_Capital'')
BEGIN
     select * FROM ?..fin_accounts  where guid = ''517F28DE-4A05-4A09-8ADF-FC027C6F30BA''
END'

-------------------------------------------------------------------------------
--Output can be saved in tables (user, temporary) or table variables:
DECLARE   @DatabasesSize TABLE
    (
      name VARCHAR(50),
      physical_name VARCHAR(500),
      state BIT,
      size INT
    )
INSERT  INTO @DatabasesSize
EXEC sp_MSforeachdb 'IF ''?''  NOT IN (''tempDB'',''model'',''msdb'')
BEGIN
       SELECT name,physical_name,state,size
       FROM ?.sys.database_files
END'
------------------------------------------------------
declare @cmd varchar(500)  
set @cmd='USE ? SELECT name FROM sysobjects WHERE xtype = ''U'' ORDER BY name' 
EXECUTE sp_msforeachdb @cmd  

--or

DECLARE @command varchar(1000) 
SELECT @command = 'USE ? SELECT name FROM sysobjects WHERE xtype = ''U'' ORDER BY name' 
EXEC sp_MSforeachdb @command 










