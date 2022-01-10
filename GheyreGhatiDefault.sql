/*
لطفا پرداختهای غیرقطعی از سال 98 به 99 انتقال یابد.

*/


USE Didgah_Budgets_Accrual_Qom
--SELECT * FROM BDG_ACTIONTYPES WHERE [Index] in(49,63,64,65)
--SELECT * FROM BDG_ACTIONTYPES WHERE TITLE LIKE N'%تامین اعتبار%'

--SELECT * FROM bdg_Actions WHERE FiscalYear=1399 AND Title LIKE N'%انتقال مانده عملیات های غیرقطعی و خنثی%'

DECLARE @BackupDate NVARCHAR(8) = '_990110';
DECLARE @Query NVARCHAR(MAX) = '';




DECLARE @ActionIndex INT	= 49 ,
    @NewActionIndex INT	= 49 ,
    @OldFiscalYear INT	= 1398 ,
    @NewFiscalYear INT	= 1399 ,
    @Title NVARCHAR(MAX)= N'انتقال مانده عملیات های غیرقطعی و خنثی عملیات تامین اعتبار هزینه ای از سال 1398';

--DECLARE @ActionIndex INT	= 63 ,
--    @NewActionIndex INT	= 63 ,
--    @OldFiscalYear INT	= 1398 ,
--    @NewFiscalYear INT	= 1399 ,
--    @Title NVARCHAR(MAX)= N'انتقال مانده عملیات های غیرقطعی و خنثی عملیات تامین اعتبار تملک از سال 1398';

--DECLARE @ActionIndex INT	= 64 ,
--    @NewActionIndex INT	= 64 ,
--    @OldFiscalYear INT	= 1398 ,
--    @NewFiscalYear INT	= 1399 ,
--    @Title NVARCHAR(MAX)= N'انتقال مانده عملیات های غیرقطعی و خنثی عملیات تامین اعتبار هزینه ای قراردادها از سال 1398';

--DECLARE @ActionIndex INT	= 65 ,
--    @NewActionIndex INT	= 65 ,
--    @OldFiscalYear INT	= 1398 ,
--    @NewFiscalYear INT	= 1399 ,
--    @Title NVARCHAR(MAX)= N'انتقال مانده عملیات های غیرقطعی و خنثی عملیات تامین اعتبار تملک قراردادها از سال 1398';







DECLARE @TargetDBName sysname;


DECLARE DatabaseCursor CURSOR FAST_FORWARD READ_ONLY
FOR
    SELECT  cpd.Name
    FROM    Didgah_Common.dbo.com_PhysicalDatabases cpd
    WHERE   ISNULL(cpd.Deleted, 0) = 0
            AND cpd.Name IN (
            'Didgah_Budgets_Accrual_Qom' );



			
OPEN DatabaseCursor;

FETCH NEXT FROM DatabaseCursor INTO @TargetDBName;


WHILE @@FETCH_STATUS = 0
    BEGIN


        SET @Query = ' SET XACT_ABORT ON '; --+ CHAR(10) + CHAR(13);


        SET @Query += N'/*****************************************/

USE ' + QUOTENAME(@TargetDBName)
            + '

BEGIN TRY 
        BEGIN TRAN
SELECT * INTO [Backups]..'+@TargetDBName+'_bdg_Actions' + @BackupDate + ' FROM bdg_Actions
SELECT * INTO [Backups]..'+@TargetDBName+'_bdg_ActionDetails' + @BackupDate + ' FROM bdg_ActionDetails

CREATE TABLE #TT
    (
      ActionGuid UNIQUEIDENTIFIER ,
      title NVARCHAR(MAX) ,
      Id INT
    );


SELECT 
		PaymentTypeGuid,[FactorGuid1],[FactorGuid2],[FactorGuid3],[FactorGuid4],[FactorGuid5],[FactorGuid6],[FactorGuid7],[FactorGuid8]
		,[FactorGuid9],[FactorGuid10],[FactorGuid11],[FactorGuid12],[FactorGuid13],[FactorGuid14],[FactorGuid15],[FactorGuid16],[FactorGuid17]
		,[FactorGuid18],[FactorGuid19],[FactorGuid20],[FactorGuid21],[FactorGuid22],[FactorGuid23],[FactorGuid24],[FactorGuid25],[FactorGuid26]
		,[FactorGuid27],[FactorGuid28],[FactorGuid29],[FactorGuid30],[Coefficient],[Value],[RawAmount],0 AS RowNo, 
		SUM(TotalAmount-ReturnAmount) AS [Remain]
INTO #ActionDetails
FROM bdg_ActionDetails 
WHERE ActionGuid IN(
SELECT Guid FROM bdg_Actions WHERE ActionTypeGuid IN(SELECT Guid FROM bdg_ActionTypes WHERE [Index] =@ActionIndex AND Deleted=0)
AND FiscalYear=@OldFiscalYear AND Deleted=0)
AND 
PaymentTypeGuid IN(SELECT Guid FROM bdg_PaymentTypes where Nature =2)
AND FinalFlag=1 AND Deleted=0
GROUP BY PaymentTypeGuid
,[FactorGuid1],[FactorGuid2],[FactorGuid3],[FactorGuid4],[FactorGuid5],[FactorGuid6],[FactorGuid7],[FactorGuid8],[FactorGuid9]
,[FactorGuid10],[FactorGuid11],[FactorGuid12],[FactorGuid13],[FactorGuid14],[FactorGuid15],[FactorGuid16],[FactorGuid17]
,[FactorGuid18],[FactorGuid19],[FactorGuid20],[FactorGuid21],[FactorGuid22],[FactorGuid23],[FactorGuid24],[FactorGuid25]
,[FactorGuid26],[FactorGuid27],[FactorGuid28],[FactorGuid29],[FactorGuid30],[Coefficient],[Value],[RawAmount]
HAVING SUM(TotalAmount-ReturnAmount)> 0

'
SET @Query += N'

;with cte as
(
  select *, new_row_id=ROW_NUMBER() OVER (ORDER BY [FactorGuid7])
  from #ActionDetails
)
update cte
set RowNo = new_row_id



'
SET @Query += N'

IF EXISTS(SELECT * FROM #ActionDetails)
BEGIN
INSERT INTO [dbo].[bdg_Actions]
           ([Guid]
           ,[Title]
           ,[Active]
           ,[Description]
           ,[IssueDate]
           ,[ActionTypeGuid]
           ,[ActionTypeStateGuid]
           ,[FiscalYear]
           ,[Deleted]
           ,[Code]
           ,[PrerequisiteActionGuid]
           ,[ExtraRecordGuid]
           ,[InWorkflow]
           ,[VoucherGeneratedBySourceSoftware]
           ,[LoadPercentage]
           ,[UserGuid]
           ,[AutoPayment]
           ,[FiscalYearDetailGuid]
           ,[SourceFinancialVoucherGuid]
           ,[StatePayment]
           ,[CreateDate]
           ,[Locked]
           ,[GatewayItemGuid]
           ,[ActionCategory]
           ,[LockedStartTime])
output  inserted.Guid,inserted.Title,inserted.ID into #TT
values
( 
NEWID(),
@Title,
1,
@Title,
GETDATE(),
(SELECT Guid FROM bdg_ActionTypes WHERE [INDEX] IN(@NewActionIndex) AND Deleted=0),
''93AB1563-E6A5-4BAD-93FB-EEF532BADFAB'',
@NewFiscalYear,
0,
(SELECT CASE WHEN (SELECT   TOP 1 CAST(CODE AS INT)  FROM bdg_Actions WHERE ActionTypeGuid IN(SELECT Guid FROM bdg_ActionTypes WHERE [INDEX] IN(@NewActionIndex) AND Deleted=0) AND FiscalYear=@NewFiscalYear AND Deleted=0) IS NULL THEN 1
ELSE 
(SELECT TOP 1 CAST(CODE AS INT)+1 FROM bdg_Actions WHERE ActionTypeGuid IN(SELECT Guid FROM bdg_ActionTypes WHERE [INDEX] IN(@NewActionIndex) AND Deleted=0)
AND FiscalYear=@NewFiscalYear ORDER BY CAST(CODE AS int) DESC )
END)
,
NULL,
''00000000-0000-0000-0000-000000000000'',
0,
0,
0,
(SELECT GUID FROM Didgah_Common..com_Users WHERE Username = ''chargoon'' AND Deleted=0),
null,
(select guid from Didgah_Common..com_FiscalYearDetails where FiscalYear =@NewFiscalYear),
null,
null,
GETDATE(),
0,
''00000000-0000-0000-0000-000000000000'',
2,
null)

SELECT * FROM #TT
'
SET @Query += N'

INSERT INTO [dbo].[bdg_ActionDetails]
           ([Guid]
           ,[ActionGuid]
           ,[Index]
           ,[FactorGuid1]
           ,[FactorGuid2]
           ,[FactorGuid3]
           ,[FactorGuid4]
           ,[FactorGuid5]
           ,[FactorGuid6]
           ,[FactorGuid7]
           ,[FactorGuid8]
           ,[FactorGuid9]
           ,[FactorGuid10]
           ,[FactorGuid11]
           ,[FactorGuid12]
           ,[FactorGuid13]
           ,[FactorGuid14]
           ,[FactorGuid15]
           ,[FactorGuid16]
           ,[FactorGuid17]
           ,[FactorGuid18]
           ,[FactorGuid19]
           ,[FactorGuid20]
           ,[Coefficient]
           ,[Value]
           ,[RawAmount]
           ,[TotalAmount]
           ,[Deleted]
           ,[SourceActionDetailGuid]
           ,[Description]
           ,[ActionDetailRelationType]
           ,[FinalFlag]
           ,[ReturnAmount]
           ,[BudgetRequestGuid]
           ,[PaymentTypeGuid]
           ,[PaymentNature]
           ,[FactorGuid21]
           ,[FactorGuid22]
           ,[FactorGuid23]
           ,[FactorGuid24]
           ,[FactorGuid25]
           ,[FactorGuid26]
           ,[FactorGuid27]
           ,[FactorGuid28]
           ,[FactorGuid29]
           ,[FactorGuid30])
'
SET @Query += N'
SELECT 
			NEWID()
           ,(SELECT ActionGuid FROM #TT)
           ,RowNo
           ,[FactorGuid1]
           ,[FactorGuid2]
           ,[FactorGuid3]
           ,[FactorGuid4]
           ,[FactorGuid5]
           ,[FactorGuid6]
           ,[FactorGuid7]
           ,[FactorGuid8]
           ,[FactorGuid9]
           ,[FactorGuid10]
           ,[FactorGuid11]
           ,[FactorGuid12]
           ,[FactorGuid13]
           ,[FactorGuid14]
           ,[FactorGuid15]
           ,[FactorGuid16]
           ,[FactorGuid17]
           ,[FactorGuid18]
           ,[FactorGuid19]
           ,[FactorGuid20]
           ,[Coefficient]
           ,[Value]
           ,[RawAmount]
           ,Remain AS [TotalAmount]
           ,0 AS [Deleted]
           ,''00000000-0000-0000-0000-000000000000'' AS [SourceActionDetailGuid]
           ,(SELECT title FROM #TT) AS [Description]
           ,0 AS [ActionDetailRelationType]
           ,1 AS [FinalFlag]
           ,0 AS [ReturnAmount]
           ,''00000000-0000-0000-0000-000000000000'' AS [BudgetRequestGuid]
           ,[PaymentTypeGuid]
           ,NULL AS [PaymentNature]
           ,[FactorGuid21]
           ,[FactorGuid22]
           ,[FactorGuid23]
           ,[FactorGuid24]
           ,[FactorGuid25]
           ,[FactorGuid26]
           ,[FactorGuid27]
           ,[FactorGuid28]
           ,[FactorGuid29]
           ,[FactorGuid30]
from #ActionDetails

END

SELECT * FROM bdg_Actions A
JOIN bdg_ActionDetails AD ON AD.ActionGuid=A.Guid
WHERE A.Guid =(SELECT ActionGuid FROM #TT)

DROP TABLE #ActionDetails
DROP TABLE #TT







COMMIT TRAN
    END TRY
    BEGIN CATCH
        ROLLBACK;
        RAISERROR(''Something bad happend.'', 16, 1)
        RETURN
    END CATCH
';


        SELECT  @Query;


        EXEC sp_executesql @Query, N'	
		@ActionIndex int,	
		@NewActionIndex int,	
		@OldFiscalYear INT,	
		@NewFiscalYear INT,	
		@Title nvarchar(MAX),
		@BackupDate NVARCHAR(8)', 
		@ActionIndex = @ActionIndex,
        @NewActionIndex = @NewActionIndex, 
		@OldFiscalYear = @OldFiscalYear,
        @NewFiscalYear = @NewFiscalYear, 
		@Title = @Title,
		@BackupDate = @BackupDate;


        SELECT  @TargetDBName + ' Finished';

        FETCH NEXT FROM DatabaseCursor INTO @TargetDBName;
    END;

CLOSE DatabaseCursor;
DEALLOCATE DatabaseCursor;
