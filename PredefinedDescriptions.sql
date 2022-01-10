
DECLARE @dbName NVARCHAR(MAX)=''

DECLARE dbName CURSOR FAST_FORWARD FOR 
    SELECT DISTINCT
      [Name]
    FROM 
      Didgah_Common..com_PhysicalDatabases
	  WHERE
			SoftwareGuid='EB8EC091-42E8-45A3-B13E-0423097BCB0D' AND
			 [Name] NOT IN ('Didgah_FinancialAccounting_Operational','Didgah_FinancialAccounting_capital','Didgah_Budgets_Accrual_01')
    OPEN dbName
FETCH NEXT FROM dbName INTO @dbName
WHILE @@FETCH_STATUS = 0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            WHILE @@FETCH_STATUS = 0
BEGIN 

	EXEC(' 
	INSERT INTO '+@dbName+'.[dbo].[fin_PredefinedDescriptions]
           ([Text]
           ,[Guid]
           ,[AccountGuid])
select p.text,newid() as guid,a.guid as accountguid 
from '+@dbName+'.[dbo].[fin_PredefinedDescriptions] p
join '+@dbName+'.[dbo].[fin_accounts] a
on p.accountguid = a.SourceAccountGuid
where AccountGuid <> ''00000000-0000-0000-0000-000000000000''
and fiscalyear = 1399 and deleted = 0
and a.guid not in (select accountguid from '+@dbName+'.[dbo].[fin_PredefinedDescriptions])
')
            
FETCH NEXT FROM dbName INTO  @dbName
END
CLOSE dbName
DEALLOCATE dbName  
------------------------------------------------------
INSERT INTO [dbo].[fin_PredefinedDescriptions]
           ([Text]
           ,[Guid]
           ,[AccountGuid])
select p.text,newid() as guid,a.guid as accountguid 
from fin_PredefinedDescriptions p
join  fin_accounts a
on p.accountguid = a.SourceAccountGuid
where AccountGuid <> '00000000-0000-0000-0000-000000000000'