USE [Didgah_FinancialAccounting_Commitment_Total]
GO

/****** Object:  StoredProcedure [dbo].[fin_Reports_GetVouchers]    Script Date: 10/31/2021 11:23:43 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[fin_Reports_GetVouchers]
	@FiscalYearDetailGuid UNIQUEIDENTIFIER,
	@Keyword NVARCHAR(128), 
	@StatusList VARCHAR(MAX), 
	@FromDate VARCHAR(30), 
	@ToDate VARCHAR(30),
	@FromReferenceDate VARCHAR(30), 
	@ToReferenceDate VARCHAR(30), 
	@FromDefiniteDate VARCHAR(30), 
	@ToDefiniteDate VARCHAR(30),
	@FromIndex INT, 
	@ToIndex INT, 
	@FromTraceNo INT, 
	@ToTraceNo INT, 
	@VoucherType INT, 
	@SourceSoftwareGuid UNIQUEIDENTIFIER, 
	@AccountCodeStart VARCHAR(256), 
	@AccountCodeEnd VARCHAR(256), 
	@BureauCode VARCHAR(32), 
	@RangeIndex VARCHAR(512), 
	@PartialCodeFrom VARCHAR(256),
	@PartialCodeTo VARCHAR(256),
	@CostCenterIDs VARCHAR(MAX),
	@IdentifierGuids VARCHAR(MAX),
	@AccountReferenceGuids VARCHAR(MAX), 
	@FromReferenceIndex NVARCHAR(128), 
	@ToReferenceIndex NVARCHAR(128), 
	@FromNoteNo BIGINT,
	@ToNoteNo BIGINT, 
	@CostCenterTypeID INT, 
	@IdentifierTypeGuid UNIQUEIDENTIFIER, 
	@AccountReferenceTypeGuid UNIQUEIDENTIFIER, 
	@FromVoucherAmount DECIMAL(22,2), 
	@ToVoucherAmount DECIMAL(22,2), 
	@FromArticleAmount DECIMAL(22,2), 
	@ToArticleAmount DECIMAL(22,2), 
	@VoucherCategoryGuids NVARCHAR(MAX), 
	@FromDefiniteIndex INT, 
	@ToDefiniteIndex INT, 
	@DefiniteIndexPatternGuid UNIQUEIDENTIFIER 
	
AS

DECLARE @AllAccount NVARCHAR(256),
				@SystemAccountCode3 NVARCHAR(256),
				@SystemAccountCode4 NVARCHAR(256),
				@SystemAccountCode5 NVARCHAR(256),
				@SystemAccountCode6 NVARCHAR(256),
				@SystemAccountCode7 NVARCHAR(256),
				@SystemAccountCode8 NVARCHAR(256),
				@SystemAccountCode9 NVARCHAR(256),
				@SystemAccountCode10 NVARCHAR(256),
				@SystemAccountCode11 NVARCHAR(256),
				@SystemAccountCode12 NVARCHAR(256),
				@SystemAccountCode13 NVARCHAR(256),
				@SystemAccountCode14 NVARCHAR(256),
				@SystemAccountCode15 NVARCHAR(256),
				@SystemAccountCode16 NVARCHAR(256),
				@SystemAccountCode17 NVARCHAR(256),
				@SystemAccountCode18 NVARCHAR(256),
				@SystemAccountCode19 NVARCHAR(256),
				@SystemAccountCode20 NVARCHAR(256),
				@SystemAccountCode21 NVARCHAR(256),
				@SystemAccountCode22 NVARCHAR(256),
				@SystemAccountCode23 NVARCHAR(256),
				@SystemAccountCode24 NVARCHAR(256),
				@SystemAccountCode25 NVARCHAR(256),
				@NotFloatDigitCount INT,
				@FirstFloatAccountIndex INT,
				@FloatAccountTitle1 NVARCHAR(MAX),
				@FloatAccountTitle2 NVARCHAR(MAX),
				@FloatAccountTitle3 NVARCHAR(MAX),
				@FloatAccountTitle4 NVARCHAR(MAX),
				@EmptyGuid UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
				@CountRangeVouchers INT
				
SET @PartialCodeFrom = REPLACE(@PartialCodeFrom,' ','')
SET @AllAccount = REPLACE(@PartialCodeFrom,'_','')
SET @StatusList = CASE 
										WHEN ISNULL(@StatusList,'') = '' THEN CAST(@EmptyGuid AS NVARCHAR(36))
										ELSE @StatusList
									END


----------------------- Find All System Accounts -------------------
SELECT 
	Code,
	[Level] 
INTO #TempSystemAccount
FROM 
	fin_Accounts
WHERE 
	[Deleted] = 0 AND 
	[FiscalYearDetailGuid] = @FiscalYearDetailGuid AND 
	[SystemAccount] = 1

DECLARE @CurentLevel AS INT = 3
DECLARE @Query NVARCHAR(MAX) = ''

WHILE @CurentLevel <= 15 BEGIN
	SET @Query =
		'SELECT @SystemAccountCode' + CASt(@CurentLevel AS NVARCHAR(2)) + ' = [Code] FROM #TempSystemAccount WHERE [Level] = ' + CAST(@CurentLevel AS NVARCHAR(2)) +
		'DELETE FROM #TempSystemAccount WHERE [Level] =  ' + cast(@CurentLevel AS NVARCHAR(2)) +''

	EXEC sys.sp_executesql
		@statement = @Query,
		@params = 
			N'@SystemAccountCode3 NVARCHAR(256) OUT,
			@SystemAccountCode4 NVARCHAR(256) OUT,
			@SystemAccountCode5 NVARCHAR(256) OUT,
			@SystemAccountCode6 NVARCHAR(256) OUT,
			@SystemAccountCode7 NVARCHAR(256) OUT,
			@SystemAccountCode8 NVARCHAR(256) OUT,
			@SystemAccountCode9 NVARCHAR(256) OUT,
			@SystemAccountCode10 NVARCHAR(256) OUT,
			@SystemAccountCode11 NVARCHAR(256) OUT,
			@SystemAccountCode12 NVARCHAR(256) OUT,
			@SystemAccountCode13 NVARCHAR(256) OUT,
			@SystemAccountCode14 NVARCHAR(256) OUT,
			@SystemAccountCode15 NVARCHAR(256) OUT,
			@SystemAccountCode16 NVARCHAR(256) OUT,
			@SystemAccountCode17 NVARCHAR(256) OUT,
			@SystemAccountCode18 NVARCHAR(256) OUT,
			@SystemAccountCode19 NVARCHAR(256) OUT,
			@SystemAccountCode20 NVARCHAR(256) OUT,
			@SystemAccountCode21 NVARCHAR(256) OUT,
			@SystemAccountCode22 NVARCHAR(256) OUT,
			@SystemAccountCode23 NVARCHAR(256) OUT,
			@SystemAccountCode24 NVARCHAR(256) OUT,
			@SystemAccountCode25 NVARCHAR(256) OUT',
		@SystemAccountCode3 = @SystemAccountCode3 OUT,
		@SystemAccountCode4 =	@SystemAccountCode4 OUT,
		@SystemAccountCode5 =	@SystemAccountCode5 OUT,
		@SystemAccountCode6 =	@SystemAccountCode6 OUT,
		@SystemAccountCode7 =	@SystemAccountCode7 OUT,
		@SystemAccountCode8 =	@SystemAccountCode8 OUT,
		@SystemAccountCode9 =	@SystemAccountCode9 OUT,
		@SystemAccountCode10 = @SystemAccountCode10 OUT,
		@SystemAccountCode11 = @SystemAccountCode11 OUT,
		@SystemAccountCode12 = @SystemAccountCode12 OUT,
		@SystemAccountCode13 = @SystemAccountCode13 OUT,
		@SystemAccountCode14 = @SystemAccountCode14 OUT,
		@SystemAccountCode15 = @SystemAccountCode15 OUT,
		@SystemAccountCode16 = @SystemAccountCode16 OUT,
		@SystemAccountCode17 = @SystemAccountCode17 OUT,
		@SystemAccountCode18 = @SystemAccountCode18 OUT,
		@SystemAccountCode19 = @SystemAccountCode19 OUT,
		@SystemAccountCode20 = @SystemAccountCode20 OUT,
		@SystemAccountCode21 = @SystemAccountCode21 OUT,
		@SystemAccountCode22 = @SystemAccountCode22 OUT,
		@SystemAccountCode23 = @SystemAccountCode23 OUT,
		@SystemAccountCode24 = @SystemAccountCode24 OUT,
		@SystemAccountCode25 = @SystemAccountCode25 OUT
		SET @CurentLevel = @CurentLevel + 1
END

DROP TABLE #TempSystemAccount

SELECT
	@SystemAccountCode3 = ISNULL(@SystemAccountCode3, ''),
	@SystemAccountCode4 = ISNULL(@SystemAccountCode4, ''),
	@SystemAccountCode5 = ISNULL(@SystemAccountCode5, ''),
	@SystemAccountCode6 = ISNULL(@SystemAccountCode6, ''),
	@SystemAccountCode7 = ISNULL(@SystemAccountCode7, ''),
	@SystemAccountCode8 = ISNULL(@SystemAccountCode8, ''),
	@SystemAccountCode9 = ISNULL(@SystemAccountCode9, ''),
	@SystemAccountCode10 = ISNULL(@SystemAccountCode10, ''),
	@SystemAccountCode11 = ISNULL(@SystemAccountCode11, ''),
	@SystemAccountCode12 = ISNULL(@SystemAccountCode12, ''),
	@SystemAccountCode13 = ISNULL(@SystemAccountCode13, ''),
	@SystemAccountCode14 = ISNULL(@SystemAccountCode14, ''),
	@SystemAccountCode15 = ISNULL(@SystemAccountCode15, ''),
	@SystemAccountCode16 = ISNULL(@SystemAccountCode16, ''),
	@SystemAccountCode17 = ISNULL(@SystemAccountCode17, ''),
	@SystemAccountCode18 = ISNULL(@SystemAccountCode18, ''),
	@SystemAccountCode19 = ISNULL(@SystemAccountCode19, ''),
	@SystemAccountCode20 = ISNULL(@SystemAccountCode20, ''),
	@SystemAccountCode21 = ISNULL(@SystemAccountCode21, ''),
	@SystemAccountCode22 = ISNULL(@SystemAccountCode22, ''),
	@SystemAccountCode23 = ISNULL(@SystemAccountCode23, ''),
	@SystemAccountCode24 = ISNULL(@SystemAccountCode24, ''),
	@SystemAccountCode25 = ISNULL(@SystemAccountCode25, '')

------------------------ Initialize @FirstFloatAccountIndex
SELECT
	@FirstFloatAccountIndex = MIN([Index])
FROM
	fin_AccountLevels
WHERE
	[FiscalYearDetailGuid] = @FiscalYearDetailGuid AND
	[Float] = 1

------------------------ Initialize FloatAccountTitles
SELECT 
	[Title],[Index]
INTO
	#TempAccountLevels
FROM 
	fin_AccountLevels
WHERE 
	[FiscalYearDetailGuid] = @FiscalYearDetailGuid  AND
  [Float] = 1

SET @CurentLevel  = 0
SET @Query  = ''
WHILE @CurentLevel < 4 BEGIN
	SET @Query = 
		'SELECT @FloatAccountTitle' + CASt((@CurentLevel + 1) AS NVARCHAR(2)) + ' = [Title] FROM #TempAccountLevels WHERE [Index] = @FirstFloatAccountIndex + ' + CAST(@CurentLevel AS NVARCHAR(2)) + 
		'DELETE FROM #TempAccountLevels WHERE [Index] =   @FirstFloatAccountIndex + ' + CAST(@CurentLevel AS NVARCHAR(2)) +''

	EXEC sys.sp_executesql
			@statement = @Query,
			@params = N'
				@FirstFloatAccountIndex INT,
				@FloatAccountTitle1 NVARCHAR(256) OUT,
				@FloatAccountTitle2 NVARCHAR(256) OUT,
				@FloatAccountTitle3 NVARCHAR(256) OUT,
				@FloatAccountTitle4 NVARCHAR(256) OUT',
			@FirstFloatAccountIndex = @FirstFloatAccountIndex ,
			@FloatAccountTitle1 = @FloatAccountTitle1 OUT,
			@FloatAccountTitle2 =	@FloatAccountTitle2 OUT,
			@FloatAccountTitle3 =	@FloatAccountTitle3 OUT,
			@FloatAccountTitle4 =	@FloatAccountTitle4 OUT

	SET @CurentLevel = @CurentLevel + 1
END

DROP TABLE #TempAccountLevels

------------------------ Initialize @NotFloatDigitCount
SELECT 
	@NotFloatDigitCount = SUM([DigitCount]) + CASE WHEN @FirstFloatAccountIndex > 0 THEN @FirstFloatAccountIndex - 2  ELSE 0 END
FROM 
	fin_AccountLevels 
WHERE 
	[FiscalYearDetailGuid] = @FiscalYearDetailGuid AND [Float] = 0

------------------------ Initialize Partial Code --------------------
DECLARE
	@HasPartialCodeFrom BIT = 0, 
	@HasPartialCodeTo BIT = 0, 
	@StartIndexPartialCodeFrom INT = 1,
	@StartIndexPartialCodeTo INT = 1,
	@LenghthPartialCodeFrom INT = 0,
	@LenghthPartialCodeTo INT = 0,
	@PartialCode NVARCHAR(256) = '',
	@CodeLenght INT = 0;
				
SELECT 
	@PartialCodeFrom = REPLACE(@PartialCodeFrom,' ',''),
	@PartialCodeTo = REPLACE(@PartialCodeTo,' ','')

IF (REPLACE(@PartialCodeFrom,'_','') != '' AND @PartialCodeFrom = @PartialCodeTo) BEGIN
	SELECT
		@HasPartialCodeFrom = 1,
		@HasPartialCodeTo = 1,
		@PartialCode = @PartialCodeFrom
		
	WHILE RIGHT(@PartialCode,1) = '_' BEGIN
		SET @PartialCode = SUBSTRING(@PartialCode, 0, LEN(@PartialCode))
	END
	
	SELECT 
		@PartialCode = @PartialCode + '%',
		@LenghthPartialCodeFrom = LEN(@PartialCode),
		@StartIndexPartialCodeFrom = 0
END
ELSE BEGIN
	IF (REPLACE(@PartialCodeFrom, '_', '') != '') BEGIN
		SELECT
			@HasPartialCodeFrom = 1,
			@LenghthPartialCodeFrom = LEN(REPLACE(@PartialCodeFrom, '_', ''))
		
		WHILE SUBSTRING(@PartialCodeFrom, @StartIndexPartialCodeFrom, 1) = '_' BEGIN
			SET @StartIndexPartialCodeFrom = @StartIndexPartialCodeFrom + 1
		END
		
		SET @PartialCodeFrom = REPLACE(@PartialCodeFrom, '_', '')
	END
	IF (REPLACE(@PartialCodeTo,'_','') != '') BEGIN
		SELECT 
			@HasPartialCodeTo = 1,
			@LenghthPartialCodeTo = LEN(REPLACE(@PartialCodeTo, '_', ''))
		
		WHILE SUBSTRING(@PartialCodeTo, @StartIndexPartialCodeTo, 1) = '_' BEGIN
			SET @StartIndexPartialCodeTo = @StartIndexPartialCodeTo + 1
		END

		SET @PartialCodeTo=REPLACE(@PartialCodeTo, '_', '')
	END
END
	
IF (@HasPartialCodeFrom = 1 AND @HasPartialCodeTo = 0) BEGIN
	SELECT
		@LenghthPartialCodeTo = @LenghthPartialCodeFrom,
		@StartIndexPartialCodeTo = @StartIndexPartialCodeFrom,
		@PartialCodeTo = '0',
		@HasPartialCodeTo = 1
END
ELSE IF(@HasPartialCodeFrom = 0 AND @HasPartialCodeTo = 1) BEGIN
	SELECT
		@LenghthPartialCodeFrom = @LenghthPartialCodeTo,
		@StartIndexPartialCodeFrom = @StartIndexPartialCodeTo,
		@PartialCodeFrom= '0' ,
		@HasPartialCodeFrom = 1
END
-------------------------------------------------------------------------------------------------------------------	

SELECT 
	COUNT(*) AS [Count],
	SUM([Debitor]) + SUM([Creditor]) AS [Amount], 
	SUM([Creditor]) AS [Creditor], 
	SUM([Debitor]) AS [Debitor], 
	[VoucherGuid] 
INTO
	#articlesInfo
FROM 
	fin_VoucherArticles articles inner join
	fin_Vouchers vouchers ON vouchers.[Guid] = articles.VoucherGuid
WHERE
	ISNULL(vouchers.Deleted,0) = 0 AND
	vouchers.[FiscalYearDetailGuid] = @FiscalYearDetailGuid 
GROUP BY 
	[VoucherGuid] 

SELECT  
	voucherArticles.[VoucherGuid],
	voucherArticles.[Index],
	voucher.[Index] AS [VoucherIndex],
	voucher.[FiscalYearDetailGuid],
	voucher.[FiscalYear],
	voucher.[Day],
	voucher.[Month],
	voucher.[Year],
	voucher.[Date],
	voucher.[Description] AS [VoucherDescription],
	voucher.[SourceSoftwareGuid] AS [VoucherSourceSoftwareGuid],
	voucher.[SourceReferenceGuid] AS [VoucherSourceReferenceGuid],
	voucher.[VoucherType] AS [VoucherType],
	voucher.[Deleted] AS [VoucherDeleted],
	voucher.[TraceNo],
	voucher.[CategoryGuid] AS [VoucherCategoryGuid],
	articlesInfo.[Amount] AS [VoucherAmount],
	articlesInfo.Debitor AS [DebitorAmount],
	articlesInfo.Creditor AS [CreditorAmount],
	voucher.[DefiniteIndexSequenceNo],
	voucher.[DefiniteIndexPatternGuid],
	voucher.[DefiniteDate],
	voucher.[DefiniteIndex],
	ISNULL(assignedVoucherStatus.[IsApproved],0) AS [IsApproved],
	ISNULL(voucherArticles.[AttachedArticle], 0) AS [AttachedArticle],
	voucher.[VoucherStatusGuid],
	ISNULL(voucherStatus.[Title], '') AS [VoucherStatusTitle],
	voucherArticles.[CurrencyAmount],
	voucherArticles.[Description],
	voucherArticles.[Creditor],
	voucherArticles.[Debitor],
	voucherArticles.[RecouncilationExempt],
	voucherArticles.[ReferenceIndex],
	voucherArticles.[LetterNo],
	voucherArticles.[LetterDate],
	voucherArticles.[Comments],
	voucherArticles.[CurrencyQuantity],
	voucherArticles.[CurrencyActionType],
	voucherArticles.[CurrencyUnitPrice],
	voucherArticles.[BankAccountGuid],
	voucherArticles.[BankDocumentApproved],
	voucherArticles.[BankDocumentType],
	voucherArticles.[BankDocumentNo],
	voucherArticles.[BankDocumentDate],
  voucherArticles.[BankDocumentGuid],
	voucherArticles.[CostCenterID],
	voucherArticles.[ReferenceGuid],
  voucherArticles.[IdentifierGuid],
  voucherArticles.[CurrencyGuid],
  voucherArticles.[AccountLevel],
  voucherArticles.[AccountGuid1],
  voucherArticles.[AccountGuid2],
  voucherArticles.[AccountGuid3],
  voucherArticles.[AccountGuid4],
  voucherArticles.[AccountGuid5],
  voucherArticles.[AccountGuid6],
  voucherArticles.[AccountGuid7],
  voucherArticles.[AccountGuid8],
  voucherArticles.[AccountGuid9],
  voucherArticles.[AccountGuid10],
  voucherArticles.[AccountGuid11],
  voucherArticles.[AccountGuid12],
  voucherArticles.[AccountGuid13],
  voucherArticles.[AccountGuid14],
  voucherArticles.[AccountGuid15],
  voucherArticles.[AccountGuid16],
  voucherArticles.[AccountGuid17],
  voucherArticles.[AccountGuid18],
  voucherArticles.[AccountGuid19],
  voucherArticles.[AccountGuid20],
  voucherArticles.[AccountGuid21],
  voucherArticles.[AccountGuid22],
  voucherArticles.[AccountGuid23],
  voucherArticles.[AccountGuid24],
  voucherArticles.[AccountGuid25],
  voucherArticles.[ActivityId],
	voucherArticles.[ExpenseId],
	voucherArticles.[ActivityCode],
  voucherArticles.[ExpenseCode],
	voucherArticles.[FundID],
	voucherArticles.[CreditSupplyDetailID],
	voucherArticles.[CreditSupplyCode]
INTO
	#tempVouchers
FROM 
	fin_Vouchers voucher INNER JOIN
	fin_VoucherArticles voucherArticles ON   voucher.[Guid] = voucherArticles.[VoucherGuid] LEFT JOIN
	fin_VoucherStatusAssignToVouchers assignedVoucherStatus ON (voucher.[Guid] = assignedVoucherStatus.[VoucherGuid] AND voucher.[VoucherStatusGuid] = assignedVoucherStatus.[VoucherStatusGuid]) LEFT JOIN  
	gen_VoucherStatus voucherStatus ON voucher.[VoucherstatusGuid] = voucherStatus.[Guid] LEFT JOIN
	#articlesInfo articlesInfo ON articlesInfo.[VoucherGuid] = voucher.[Guid] 
WHERE
	ISNULL(voucher.Deleted,0) = 0 AND
	[FiscalYearDetailGuid] = @FiscalYearDetailGuid AND
  (@FromDate = '' OR [Date] >= @FromDate)	AND
	(@ToDate = '' OR [Date] <= @ToDate) AND
	(@FromReferenceDate = '' OR [LetterDate] >= @FromReferenceDate)	AND
	(@ToReferenceDate = '' OR [LetterDate] <= @ToReferenceDate) AND
	(@FromDefiniteDate = '' OR [DefiniteDate] >= @FromDefiniteDate)	AND
	(@ToDefiniteDate = '' OR [DefiniteDate] <= @ToDefiniteDate) AND
	(@FromIndex = 0 OR voucher.[Index] >= @FromIndex) AND
	(@ToIndex = 0 OR voucher.[Index] <= @ToIndex) AND
	(@FromTraceNo = 0 OR [TraceNo] >= @FromTraceNo) AND
	(@ToTraceNo = 0 OR [TraceNo] <= @ToTraceNo) AND
	(@VoucherType = 0 OR [VoucherType] = @VoucherType) AND
	(@FromReferenceIndex = 0 OR voucherArticles.[ReferenceIndex] >= @FromReferenceIndex) AND
	(@ToReferenceIndex = 0 OR voucherArticles.[ReferenceIndex] <= @ToReferenceIndex) AND
	(@FromNoteNo = 0 OR [BankDocumentNo] >= @FromNoteNo) AND
	(@ToNoteNo = 0 OR [BankDocumentNo] <= @ToNoteNo) AND
	(@FromDefiniteIndex = 0 OR [DefiniteIndexSequenceNo] >= @FromDefiniteIndex) AND
	(@ToDefiniteIndex = 0 OR [DefiniteIndexSequenceNo] <= @ToDefiniteIndex)AND
	(ISNULL(@VoucherCategoryGuids, CAST(@EmptyGuid AS nvarchar(36))) = CAST(@EmptyGuid AS nvarchar(36)) OR ',' + @VoucherCategoryGuids + ',' LIKE '%,' + CAST([CategoryGuid] AS VARCHAR(36)) + ',%') AND
	(@DefiniteIndexPatternGuid = @EmptyGuid OR [DefiniteIndexPatternGuid] = @DefiniteIndexPatternGuid) AND
	(@PartialCode = '' OR REPLACE([AccountCode],' ','') LIKE @PartialCode) AND
	(@PartialCode != '' OR
			(@HasPartialCodeFrom = 0 OR SUBSTRING(REPLACE([AccountCode],' ',''),@StartIndexPartialCodeFrom,@LenghthPartialCodeFrom) >= @PartialCodeFrom) AND 
			(@HasPartialCodeTo = 0 OR SUBSTRING(REPLACE([AccountCode],' ',''),@StartIndexPartialCodeTo,@LenghthPartialCodeTo) <= @PartialCodeTo)) AND
	--(@AccountCodeStart = '' OR REPLACE([AccountCode], ' ', '') LIKE @AccountCodeStart+'%' OR REPLACE([AccountCode], ' ', '') >= @AccountCodeStart) AND
	--(@AccountCodeEnd = '' OR REPLACE([AccountCode], ' ', '') LIKE @AccountCodeEnd+'%' OR REPLACE([AccountCode], ' ', '') <= @AccountCodeEnd) AND
	(ISNULL(@CostCenterIDs, '') = '' OR ',' + @CostCenterIDs +  ',' LIKE '%,' + CAST([CostCenterID] as VARCHAR(32)) + ',%') AND
	(ISNULL(@IdentifierGuids, '') = '' OR ',' + @IdentifierGuids + ',' LIKE '%,' + CAST([IdentifierGuid] AS VARCHAR(36)) + ',%') AND
	(ISNULL(@AccountReferenceGuids, '') = '' OR ',' + @AccountReferenceGuids + ',' LIKE '%,' + CAST([ReferenceGuid] AS VARCHAR(36)) + ',%') AND
	(@StatusList = @EmptyGuid OR @StatusList LIKE '%' + CONVERT(VARCHAR(36), voucher.[VoucherStatusGuid]) + '%') AND
	(@RangeIndex = '' OR ','+ @RangeIndex +',' LIKE '%,' + CAST(voucher.[Index] AS NVARCHAR(32)) + ',%') AND
	(@Keyword = '' OR voucher.[Description] LIKE '%' + @Keyword + '%'  OR voucher.[Description] LIKE '%' + @Keyword + '%')

DROP TABLE #articlesInfo
------------------------------------CountRangeVouchers--------------------------------------

SELECT 
	@CountRangeVouchers = COUNT(DISTINCT [Date]) 
FROM 
	#tempVouchers
WHERE
	
	(@FromDate = '' OR [Date] < @FromDate) AND	
	(@FromReferenceDate = '' OR [LetterDate] < @FromReferenceDate) AND	
	(@FromDefiniteDate = '' OR [DefiniteDate] < @FromDefiniteDate)	AND
	(@FromIndex = 0 OR [VoucherIndex]  < @FromIndex) AND
	(@FromTraceNo = 0 OR [TraceNo] < @FromTraceNo) AND
	(@FromDefiniteIndex = 0 OR [DefiniteIndexSequenceNo] < @FromDefiniteIndex) AND
	(@FromDate != '' OR @FromDefiniteDate != '' OR @FromIndex != 0 OR @FromTraceNo != 0 OR @FromDefiniteIndex != 0)
		

SET @CountRangeVouchers = ISNULL(@CountRangeVouchers,0)
----------------------------------------- Temp Articles--------------------

SELECT DISTINCT  AccountGuid
INTO #AccountGuid
FROM 
   (SELECT  AccountGuid1, 
						 AccountGuid2, 
						 AccountGuid3, 
						 AccountGuid4, 
						 AccountGuid5, 
						 AccountGuid6, 
						 AccountGuid7, 
						 AccountGuid8, 
						 AccountGuid9, 
						 AccountGuid10, 
						 AccountGuid11, 
						 AccountGuid12, 
						 AccountGuid13, 
						 AccountGuid14, 
						 AccountGuid15, 
						 AccountGuid16, 
						 AccountGuid17, 
						 AccountGuid18, 
						 AccountGuid19, 
						 AccountGuid20, 
						 AccountGuid21, 
						 AccountGuid22, 
						 AccountGuid23, 
						 AccountGuid24, 
						 AccountGuid25
			FROM #tempVouchers) p
UNPIVOT
   (AccountGuid FOR #tempVouchers IN 
																						(AccountGuid1, 
																						 AccountGuid2, 
																						 AccountGuid3, 
																						 AccountGuid4, 
																						 AccountGuid5, 
																						 AccountGuid6, 
																						 AccountGuid7, 
																						 AccountGuid8, 
																						 AccountGuid9, 
																						 AccountGuid10, 
																						 AccountGuid11, 
																						 AccountGuid12, 
																						 AccountGuid13, 
																						 AccountGuid14, 
																						 AccountGuid15, 
																						 AccountGuid16, 
																						 AccountGuid17, 
																						 AccountGuid18, 
																						 AccountGuid19, 
																						 AccountGuid20, 
																						 AccountGuid21, 
																						 AccountGuid22, 
																						 AccountGuid23, 
																						 AccountGuid24, 
																						 AccountGuid25)
)AS unpvt;

CREATE TABLE #TempAccounts (
	[Guid] UNIQUEIDENTIFIER,
	[Code] VARCHAR(16),
	[Comments] NVARCHAR(512),
	[Title] NVARCHAR(256),
	[CategoryGuid] UNIQUEIDENTIFIER,
	[PaymentNature] INT ,
	[PaymentRow] INT,
	[SendReceiveNature] INT,
	[SendReceiveRow] INT
)

INSERT INTO #TempAccounts
SELECT 
	[Guid] AS [Guid],
	Code AS [AccountCode],
	Comments AS [AccountComments],
	Title AS [AccountTitle],
	CategoryGuid AS [FloatCategoryGuid],
	[PaymentNature],
	[PaymentRow],
	[SendReceiveNature],
	[SendReceiveRow]
FROM 
	fin_Accounts 
WHERE 
	FiscalYearDetailGuid = @FiscalYearDetailGuid AND 
	Deleted = 0 AND
  [Guid] IN (SELECT [Guid] FROM #AccountGuid)
---------------------------------------------------------------------------


SELECT 
	voucher.* ,
	accounts1.Code AS [AccountCode1],
	accounts2.Code AS [AccountCode2],
	accounts3.Code AS [AccountCode3],
	accounts4.Code AS [AccountCode4],
	accounts5.Code AS [AccountCode5],
	accounts6.Code AS [AccountCode6],
	accounts7.Code AS [AccountCode7],
	accounts8.Code AS [AccountCode8],
	accounts9.Code AS [AccountCode9],
	accounts10.Code AS [AccountCode10],
	accounts11.Code AS [AccountCode11],
	accounts12.Code AS [AccountCode12],
	accounts13.Code AS [AccountCode13],
	accounts14.Code AS [AccountCode14],
	accounts15.Code AS [AccountCode15],
	accounts16.Code AS [AccountCode16],
	accounts17.Code AS [AccountCode17],
	accounts18.Code AS [AccountCode18],
	accounts19.Code AS [AccountCode19],
	accounts20.Code AS [AccountCode20],
	accounts21.Code AS [AccountCode21],
	accounts22.Code AS [AccountCode22],
	accounts23.Code AS [AccountCode23],
	accounts24.Code AS [AccountCode24],
	accounts25.Code AS [AccountCode25],
	accounts1.Comments AS [AccountComments1],
	accounts2.Comments AS [AccountComments2],
	accounts3.Comments AS [AccountComments3],
	accounts4.Comments AS [AccountComments4],
	accounts5.Comments AS [AccountComments5],
	accounts6.Comments AS [AccountComments6],
	accounts7.Comments AS [AccountComments7],
	accounts8.Comments AS [AccountComments8],
	accounts9.Comments AS [AccountComments9],
	accounts10.Comments AS [AccountComments10],
	accounts11.Comments AS [AccountComments11],
	accounts12.Comments AS [AccountComments12],
	accounts13.Comments AS [AccountComments13],
	accounts14.Comments AS [AccountComments14],
	accounts15.Comments AS [AccountComments15],
	accounts16.Comments AS [AccountComments16],
	accounts17.Comments AS [AccountComments17],
	accounts18.Comments AS [AccountComments18],
	accounts19.Comments AS [AccountComments19],
	accounts20.Comments AS [AccountComments20],
	accounts21.Comments AS [AccountComments21],
	accounts22.Comments AS [AccountComments22],
	accounts23.Comments AS [AccountComments23],
	accounts24.Comments AS [AccountComments24],
	accounts25.Comments AS [AccountComments25],
	accounts1.Title AS [AccountTitle1],
	accounts2.Title AS [AccountTitle2],
	accounts3.Title AS [AccountTitle3],
	accounts4.Title AS [AccountTitle4],
	accounts5.Title AS [AccountTitle5],
	accounts6.Title AS [AccountTitle6],
	accounts7.Title AS [AccountTitle7],
	accounts8.Title AS [AccountTitle8],
	accounts9.Title AS [AccountTitle9],
	accounts10.Title AS [AccountTitle10],
	accounts11.Title AS [AccountTitle11],
	accounts12.Title AS [AccountTitle12],
	accounts13.Title AS [AccountTitle13],
	accounts14.Title AS [AccountTitle14],
	accounts15.Title AS [AccountTitle15],
	accounts16.Title AS [AccountTitle16],
	accounts17.Title AS [AccountTitle17],
	accounts18.Title AS [AccountTitle18],
	accounts19.Title AS [AccountTitle19],
	accounts20.Title AS [AccountTitle20],
	accounts21.Title AS [AccountTitle21],
	accounts22.Title AS [AccountTitle22],
	accounts23.Title AS [AccountTitle23],
	accounts24.Title AS [AccountTitle24],
	accounts25.Title AS [AccountTitle25],
	accounts1.CategoryGuid AS [FloatCategoryGuid1],
	accounts2.CategoryGuid AS [FloatCategoryGuid2],
	accounts3.CategoryGuid AS [FloatCategoryGuid3],
	accounts4.CategoryGuid AS [FloatCategoryGuid4],
	accounts5.CategoryGuid AS [FloatCategoryGuid5],
	accounts6.CategoryGuid AS [FloatCategoryGuid6],
	accounts7.CategoryGuid AS [FloatCategoryGuid7],
	accounts8.CategoryGuid AS [FloatCategoryGuid8],
	accounts9.CategoryGuid AS [FloatCategoryGuid9],
	accounts10.CategoryGuid AS [FloatCategoryGuid10],
	accounts11.CategoryGuid AS [FloatCategoryGuid11],
	accounts12.CategoryGuid AS [FloatCategoryGuid12],
	accounts13.CategoryGuid AS [FloatCategoryGuid13],
	accounts14.CategoryGuid AS [FloatCategoryGuid14],
	accounts15.CategoryGuid AS [FloatCategoryGuid15],
	accounts16.CategoryGuid AS [FloatCategoryGuid16],
	accounts17.CategoryGuid AS [FloatCategoryGuid17],
	accounts18.CategoryGuid AS [FloatCategoryGuid18],
	accounts19.CategoryGuid AS [FloatCategoryGuid19],
	accounts20.CategoryGuid AS [FloatCategoryGuid20],
	accounts21.CategoryGuid AS [FloatCategoryGuid21],
	accounts22.CategoryGuid AS [FloatCategoryGuid22],
	accounts23.CategoryGuid AS [FloatCategoryGuid23],
	accounts24.CategoryGuid AS [FloatCategoryGuid24],
	accounts25.CategoryGuid AS [FloatCategoryGuid25],
	accounts2.[PaymentNature],
	accounts2.[PaymentRow],
	accounts2.[SendReceiveNature],
	accounts2.[SendReceiveRow]
	
INTO
	#TempVoucherLevel15
FROM 
	#tempVouchers voucher LEFT JOIN
	#TempAccounts accounts1 ON accounts1.[Guid] = voucher.[AccountGuid1] LEFT JOIN
	#TempAccounts accounts2 ON accounts2.[Guid] = voucher.[AccountGuid2] LEFT JOIN
	#TempAccounts accounts3 ON accounts3.[Guid] = voucher.[AccountGuid3] LEFT JOIN
	#TempAccounts accounts4 ON accounts4.[Guid] = voucher.[AccountGuid4] LEFT JOIN
	#TempAccounts accounts5 ON accounts5.[Guid] = voucher.[AccountGuid5] LEFT JOIN
	#TempAccounts accounts6 ON accounts6.[Guid] = voucher.[AccountGuid6] LEFT JOIN
	#TempAccounts accounts7 ON accounts7.[Guid] = voucher.[AccountGuid7] LEFT JOIN
	#TempAccounts accounts8 ON accounts8.[Guid] = voucher.[AccountGuid8] LEFT JOIN
	#TempAccounts accounts9 ON accounts9.[Guid] = voucher.[AccountGuid9] LEFT JOIN
	#TempAccounts accounts10 ON accounts10.[Guid] = voucher.[AccountGuid10] LEFT JOIN
	#TempAccounts accounts11 ON accounts11.[Guid] = voucher.[AccountGuid11] LEFT JOIN
	#TempAccounts accounts12 ON accounts12.[Guid] = voucher.[AccountGuid12] LEFT JOIN
	#TempAccounts accounts13 ON accounts13.[Guid] = voucher.[AccountGuid13] LEFT JOIN
	#TempAccounts accounts14 ON accounts14.[Guid] = voucher.[AccountGuid14] LEFT JOIN
	#TempAccounts accounts15 ON accounts15.[Guid] = voucher.[AccountGuid15]  LEFT JOIN
	#TempAccounts accounts16 ON accounts16.[Guid] = voucher.[AccountGuid16]  LEFT JOIN
	#TempAccounts accounts17 ON accounts17.[Guid] = voucher.[AccountGuid17]  LEFT JOIN
	#TempAccounts accounts18 ON accounts18.[Guid] = voucher.[AccountGuid18]  LEFT JOIN
	#TempAccounts accounts19 ON accounts19.[Guid] = voucher.[AccountGuid19]  LEFT JOIN
	#TempAccounts accounts20 ON accounts20.[Guid] = voucher.[AccountGuid20]  LEFT JOIN
	#TempAccounts accounts21 ON accounts21.[Guid] = voucher.[AccountGuid21]  LEFT JOIN
	#TempAccounts accounts22 ON accounts22.[Guid] = voucher.[AccountGuid22]  LEFT JOIN
	#TempAccounts accounts23 ON accounts23.[Guid] = voucher.[AccountGuid23]  LEFT JOIN
	#TempAccounts accounts24 ON accounts24.[Guid] = voucher.[AccountGuid24]  LEFT JOIN
	#TempAccounts accounts25 ON accounts25.[Guid] = voucher.[AccountGuid25] 



DROP TABLE #TempAccounts


SELECT  
	[VoucherGuid],
	[Index],
	[VoucherIndex],
	[FiscalYearDetailGuid],
	[FiscalYear],
	[Day],
	[Month],
	[Year],
	[Date],
	[VoucherDescription],
	[VoucherSourceSoftwareGuid],
	[VoucherSourceReferenceGuid],
	[VoucherType],
	[VoucherDeleted],
	[TraceNo],
	[VoucherCategoryGuid],
	[VoucherAmount],
	[DebitorAmount],
	[CreditorAmount],
	[DefiniteIndexSequenceNo],
	[DefiniteIndexPatternGuid],
	[DefiniteDate],
	[DefiniteIndex],
	[IsApproved],
	[AttachedArticle],
	[VoucherStatusGuid],
	[VoucherStatusTitle],
	ISNULL([AccountCode1], '') + ' ' + ISNULL([AccountCode2], '') + ' ' + ISNULL([AccountCode3], '') + ' ' + ISNULL([AccountCode4], '') + ' ' + ISNULL([AccountCode5], '') + ' ' + ISNULL([AccountCode6], '') + ' ' + ISNULL([AccountCode7], '') + ' ' + ISNULL([AccountCode8], '') + ' ' + ISNULL([AccountCode9], '') + ' ' + ISNULL([AccountCode10], '') + ' ' + ISNULL([AccountCode11], '') + ' ' + ISNULL([AccountCode12], '') + ' ' + ISNULL([AccountCode13], '') + ' ' + ISNULL([AccountCode14], '') + ' ' + ISNULL([AccountCode15], '')  + ' ' + ISNULL([AccountCode16], '')  + ' ' + ISNULL([AccountCode17], '')  + ' ' + ISNULL([AccountCode18], '')  + ' ' + ISNULL([AccountCode19], '')  + ' ' + ISNULL([AccountCode20], '')  + ' ' + ISNULL([AccountCode21], '')  + ' ' + ISNULL([AccountCode22], '')  + ' ' + ISNULL([AccountCode23], '')  + ' ' + ISNULL([AccountCode24], '')  + ' ' + ISNULL([AccountCode25], '') AS [AccountCode],
	CASE WHEN [AccountLevel] >= 1 
		THEN
			ISNULL([AccountCode1], '')
		ELSE 
			NULL
	END AS [AccountCode1],
	CASE WHEN [AccountLevel] >= 2 
		THEN
			RTRIM(ISNULL([AccountCode1], '') + '  ' + ISNULL([AccountCode2], ''))
		ELSE 
			NULL
	END AS [AccountCode2],
	CASE WHEN [AccountLevel] >= 3 
		THEN
			RTRIM(ISNULL([AccountCode1], '') + '  ' + ISNULL([AccountCode2], '') + '  ' + ISNULL([AccountCode3], ''))
		ELSE 
			NULL
	END AS [AccountCode3],
	CASE WHEN [AccountLevel] >= 4 
		THEN
			RTRIM(ISNULL([AccountCode1], '') + '  ' + ISNULL([AccountCode2], '') + '  ' + ISNULL([AccountCode3], '') + '  ' + ISNULL([AccountCode4], ''))
		ELSE 
			NULL
	END AS [AccountCode4],
	CASE WHEN [AccountLevel] >= 5 
		THEN
			RTRIM(ISNULL([AccountCode1], '') + '  ' + ISNULL([AccountCode2], '') + '  ' + ISNULL([AccountCode3], '') + '  ' + ISNULL([AccountCode4], '') + '  ' + ISNULL([AccountCode5], ''))
		ELSE 
			NULL
	END AS [AccountCode5],
	CASE WHEN [AccountLevel] >= 6 
		THEN
			RTRIM(ISNULL([AccountCode1], '') + '  ' + ISNULL([AccountCode2], '') + '  ' + ISNULL([AccountCode3], '') + '  ' + ISNULL([AccountCode4], '') + '  ' + ISNULL([AccountCode5], '') + '  ' + ISNULL([AccountCode6], ''))
		ELSE 
			NULL
	END AS [AccountCode6],
	CASE WHEN [AccountLevel] >= 7 
		THEN
			RTRIM(ISNULL([AccountCode1], '') + '  ' + ISNULL([AccountCode2], '') + '  ' + ISNULL([AccountCode3], '') + '  ' + ISNULL([AccountCode4], '') + '  ' + ISNULL([AccountCode5], '') + '  ' + ISNULL([AccountCode6], '') + '  ' + ISNULL([AccountCode7], ''))
		ELSE 
			NULL
	END AS [AccountCode7],
	CASE WHEN [AccountLevel] >= 8 
		THEN
			RTRIM(ISNULL([AccountCode1], '') + '  ' + ISNULL([AccountCode2], '') + '  ' + ISNULL([AccountCode3], '') + '  ' + ISNULL([AccountCode4], '') + '  ' + ISNULL([AccountCode5], '') + '  ' + ISNULL([AccountCode6], '') + '  ' + ISNULL([AccountCode7], '') + '  ' + ISNULL([AccountCode8], ''))
		ELSE 
			NULL
	END AS [AccountCode8],
	CASE WHEN [AccountLevel] >= 9 
		THEN
			RTRIM(ISNULL([AccountCode1], '') + '  ' + ISNULL([AccountCode2], '') + '  ' + ISNULL([AccountCode3], '') + '  ' + ISNULL([AccountCode4], '') + '  ' + ISNULL([AccountCode5], '') + '  ' + ISNULL([AccountCode6], '') + '  ' + ISNULL([AccountCode7], '') + '  ' + ISNULL([AccountCode8], '') + '  ' + ISNULL([AccountCode9], ''))
		ELSE 
			NULL
	END AS [AccountCode9],
	CASE WHEN [AccountLevel] >= 10 
		THEN
			RTRIM(ISNULL([AccountCode1], '') + '  ' + ISNULL([AccountCode2], '') + '  ' + ISNULL([AccountCode3], '') + '  ' + ISNULL([AccountCode4], '') + '  ' + ISNULL([AccountCode5], '') + '  ' + ISNULL([AccountCode6], '') + '  ' + ISNULL([AccountCode7], '') + '  ' + ISNULL([AccountCode8], '') + '  ' + ISNULL([AccountCode9], '') + '  ' + ISNULL([AccountCode10], ''))
		ELSE 
			NULL
	END AS [AccountCode10],
	CASE WHEN [AccountLevel] >= 11
		THEN
			RTRIM(ISNULL([AccountCode1], '') + '  ' + ISNULL([AccountCode2], '') + '  ' + ISNULL([AccountCode3], '') + '  ' + ISNULL([AccountCode4], '') + '  ' + ISNULL([AccountCode5], '') + '  ' + ISNULL([AccountCode6], '') + '  ' + ISNULL([AccountCode7], '') + '  ' + ISNULL([AccountCode8], '') + '  ' + ISNULL([AccountCode9], '') + '  ' + ISNULL([AccountCode10], '') + '  ' + ISNULL([AccountCode11], ''))
		ELSE 
			NULL
	END AS [AccountCode11],
	CASE WHEN [AccountLevel] >= 12
		THEN
			RTRIM(ISNULL([AccountCode1], '') + '  ' + ISNULL([AccountCode2], '') + '  ' + ISNULL([AccountCode3], '') + '  ' + ISNULL([AccountCode4], '') + '  ' + ISNULL([AccountCode5], '') + '  ' + ISNULL([AccountCode6], '') + '  ' + ISNULL([AccountCode7], '') + '  ' + ISNULL([AccountCode8], '') + '  ' + ISNULL([AccountCode9], '') + '  ' + ISNULL([AccountCode10], '') + '  ' + ISNULL([AccountCode11], '') + '  ' + ISNULL([AccountCode12], ''))
		ELSE 
			NULL
	END AS [AccountCode12],
	CASE WHEN [AccountLevel] >= 13
		THEN
			RTRIM(ISNULL([AccountCode1], '') + '  ' + ISNULL([AccountCode2], '') + '  ' + ISNULL([AccountCode3], '') + '  ' + ISNULL([AccountCode4], '') + '  ' + ISNULL([AccountCode5], '') + '  ' + ISNULL([AccountCode6], '') + '  ' + ISNULL([AccountCode7], '') + '  ' + ISNULL([AccountCode8], '') + '  ' + ISNULL([AccountCode9], '') + '  ' + ISNULL([AccountCode10], '') + '  ' + ISNULL([AccountCode11], '') + '  ' + ISNULL([AccountCode12], '') + '  ' + ISNULL([AccountCode13], ''))
		ELSE 
			NULL
	END AS [AccountCode13],
	CASE WHEN [AccountLevel] >= 14
		THEN
			RTRIM(ISNULL([AccountCode1], '') + '  ' + ISNULL([AccountCode2], '') + '  ' + ISNULL([AccountCode3], '') + '  ' + ISNULL([AccountCode4], '') + '  ' + ISNULL([AccountCode5], '') + '  ' + ISNULL([AccountCode6], '') + '  ' + ISNULL([AccountCode7], '') + '  ' + ISNULL([AccountCode8], '') + '  ' + ISNULL([AccountCode9], '') + '  ' + ISNULL([AccountCode10], '') + '  ' + ISNULL([AccountCode11], '') + '  ' + ISNULL([AccountCode12], '') + '  ' + ISNULL([AccountCode13], '') + '  ' + ISNULL([AccountCode14], ''))
		ELSE 
			NULL
	END AS [AccountCode14],
	CASE WHEN [AccountLevel] = 15
		THEN
			RTRIM(ISNULL([AccountCode1], '') + '  ' + ISNULL([AccountCode2], '') + '  ' + ISNULL([AccountCode3], '') + '  ' + ISNULL([AccountCode4], '') + '  ' + ISNULL([AccountCode5], '') + '  ' + ISNULL([AccountCode6], '') + '  ' + ISNULL([AccountCode7], '') + '  ' + ISNULL([AccountCode8], '') + '  ' + ISNULL([AccountCode9], '') + '  ' + ISNULL([AccountCode10], '') + '  ' + ISNULL([AccountCode11], '') + '  ' + ISNULL([AccountCode12], '') + '  ' + ISNULL([AccountCode13], '') + '  ' + ISNULL([AccountCode14], '') + '  ' + ISNULL([AccountCode15], ''))
		ELSE 
			NULL
	END AS [AccountCode15],
	
	CASE WHEN [AccountLevel] = 16
		THEN
			RTRIM(ISNULL([AccountCode1], '') + '  ' + ISNULL([AccountCode2], '') + '  ' + ISNULL([AccountCode3], '') + '  ' + ISNULL([AccountCode4], '') + '  ' + ISNULL([AccountCode5], '') + '  ' + ISNULL([AccountCode6], '') + '  ' + ISNULL([AccountCode7], '') + '  ' + ISNULL([AccountCode8], '') + '  ' + ISNULL([AccountCode9], '') + '  ' + ISNULL([AccountCode10], '') + '  ' + ISNULL([AccountCode11], '') + '  ' + ISNULL([AccountCode12], '') + '  ' + ISNULL([AccountCode13], '') + '  ' + ISNULL([AccountCode14], '') + '  ' + ISNULL([AccountCode15], '') + '  ' + ISNULL([AccountCode16], ''))
		ELSE 
			NULL
	END AS [AccountCode16],
	CASE WHEN [AccountLevel] = 17
		THEN
			RTRIM(ISNULL([AccountCode1], '') + '  ' + ISNULL([AccountCode2], '') + '  ' + ISNULL([AccountCode3], '') + '  ' + ISNULL([AccountCode4], '') + '  ' + ISNULL([AccountCode5], '') + '  ' + ISNULL([AccountCode6], '') + '  ' + ISNULL([AccountCode7], '') + '  ' + ISNULL([AccountCode8], '') + '  ' + ISNULL([AccountCode9], '') + '  ' + ISNULL([AccountCode10], '') + '  ' + ISNULL([AccountCode11], '') + '  ' + ISNULL([AccountCode12], '') + '  ' + ISNULL([AccountCode13], '') + '  ' + ISNULL([AccountCode14], '') + '  ' + ISNULL([AccountCode15], '') + '  ' + ISNULL([AccountCode16], '') + '  ' + ISNULL([AccountCode17], ''))
		ELSE 
			NULL
	END AS [AccountCode17],
	CASE WHEN [AccountLevel] = 18
		THEN
			RTRIM(ISNULL([AccountCode1], '') + '  ' + ISNULL([AccountCode2], '') + '  ' + ISNULL([AccountCode3], '') + '  ' + ISNULL([AccountCode4], '') + '  ' + ISNULL([AccountCode5], '') + '  ' + ISNULL([AccountCode6], '') + '  ' + ISNULL([AccountCode7], '') + '  ' + ISNULL([AccountCode8], '') + '  ' + ISNULL([AccountCode9], '') + '  ' + ISNULL([AccountCode10], '') + '  ' + ISNULL([AccountCode11], '') + '  ' + ISNULL([AccountCode12], '') + '  ' + ISNULL([AccountCode13], '') + '  ' + ISNULL([AccountCode14], '') + '  ' + ISNULL([AccountCode15], '') + '  ' + ISNULL([AccountCode16], '') + '  ' + ISNULL([AccountCode17], '') + '  ' + ISNULL([AccountCode18], ''))
		ELSE 
			NULL
	END AS [AccountCode18],
	CASE WHEN [AccountLevel] = 19
		THEN
			RTRIM(ISNULL([AccountCode1], '') + '  ' + ISNULL([AccountCode2], '') + '  ' + ISNULL([AccountCode3], '') + '  ' + ISNULL([AccountCode4], '') + '  ' + ISNULL([AccountCode5], '') + '  ' + ISNULL([AccountCode6], '') + '  ' + ISNULL([AccountCode7], '') + '  ' + ISNULL([AccountCode8], '') + '  ' + ISNULL([AccountCode9], '') + '  ' + ISNULL([AccountCode10], '') + '  ' + ISNULL([AccountCode11], '') + '  ' + ISNULL([AccountCode12], '') + '  ' + ISNULL([AccountCode13], '') + '  ' + ISNULL([AccountCode14], '') + '  ' + ISNULL([AccountCode15], '') + '  ' + ISNULL([AccountCode16], '') + '  ' + ISNULL([AccountCode17], '') + '  ' + ISNULL([AccountCode18], '') + '  ' + ISNULL([AccountCode19], ''))
		ELSE 
			NULL
	END AS [AccountCode19],
	CASE WHEN [AccountLevel] = 20
		THEN
			RTRIM(ISNULL([AccountCode1], '') + '  ' + ISNULL([AccountCode2], '') + '  ' + ISNULL([AccountCode3], '') + '  ' + ISNULL([AccountCode4], '') + '  ' + ISNULL([AccountCode5], '') + '  ' + ISNULL([AccountCode6], '') + '  ' + ISNULL([AccountCode7], '') + '  ' + ISNULL([AccountCode8], '') + '  ' + ISNULL([AccountCode9], '') + '  ' + ISNULL([AccountCode10], '') + '  ' + ISNULL([AccountCode11], '') + '  ' + ISNULL([AccountCode12], '') + '  ' + ISNULL([AccountCode13], '') + '  ' + ISNULL([AccountCode14], '') + '  ' + ISNULL([AccountCode15], '') + '  ' + ISNULL([AccountCode16], '') + '  ' + ISNULL([AccountCode17], '') + '  ' + ISNULL([AccountCode18], '') + '  ' + ISNULL([AccountCode19], '') + '  ' + ISNULL([AccountCode20], ''))
		ELSE 
			NULL
	END AS [AccountCode20],
	CASE WHEN [AccountLevel] = 21
		THEN
			RTRIM(ISNULL([AccountCode1], '') + '  ' + ISNULL([AccountCode2], '') + '  ' + ISNULL([AccountCode3], '') + '  ' + ISNULL([AccountCode4], '') + '  ' + ISNULL([AccountCode5], '') + '  ' + ISNULL([AccountCode6], '') + '  ' + ISNULL([AccountCode7], '') + '  ' + ISNULL([AccountCode8], '') + '  ' + ISNULL([AccountCode9], '') + '  ' + ISNULL([AccountCode10], '') + '  ' + ISNULL([AccountCode11], '') + '  ' + ISNULL([AccountCode12], '') + '  ' + ISNULL([AccountCode13], '') + '  ' + ISNULL([AccountCode14], '') + '  ' + ISNULL([AccountCode15], '') + '  ' + ISNULL([AccountCode16], '') + '  ' + ISNULL([AccountCode17], '') + '  ' + ISNULL([AccountCode18], '') + '  ' + ISNULL([AccountCode19], '') + '  ' + ISNULL([AccountCode20], '') + '  ' + ISNULL([AccountCode21], ''))
		ELSE 
			NULL
	END AS [AccountCode21],
	CASE WHEN [AccountLevel] = 22
		THEN
			RTRIM(ISNULL([AccountCode1], '') + '  ' + ISNULL([AccountCode2], '') + '  ' + ISNULL([AccountCode3], '') + '  ' + ISNULL([AccountCode4], '') + '  ' + ISNULL([AccountCode5], '') + '  ' + ISNULL([AccountCode6], '') + '  ' + ISNULL([AccountCode7], '') + '  ' + ISNULL([AccountCode8], '') + '  ' + ISNULL([AccountCode9], '') + '  ' + ISNULL([AccountCode10], '') + '  ' + ISNULL([AccountCode11], '') + '  ' + ISNULL([AccountCode12], '') + '  ' + ISNULL([AccountCode13], '') + '  ' + ISNULL([AccountCode14], '') + '  ' + ISNULL([AccountCode15], '') + '  ' + ISNULL([AccountCode16], '') + '  ' + ISNULL([AccountCode17], '') + '  ' + ISNULL([AccountCode18], '') + '  ' + ISNULL([AccountCode19], '') + '  ' + ISNULL([AccountCode20], '') + '  ' + ISNULL([AccountCode21], '') + '  ' + ISNULL([AccountCode22], ''))
		ELSE 
			NULL
	END AS [AccountCode22],
	CASE WHEN [AccountLevel] = 23
		THEN
			RTRIM(ISNULL([AccountCode1], '') + '  ' + ISNULL([AccountCode2], '') + '  ' + ISNULL([AccountCode3], '') + '  ' + ISNULL([AccountCode4], '') + '  ' + ISNULL([AccountCode5], '') + '  ' + ISNULL([AccountCode6], '') + '  ' + ISNULL([AccountCode7], '') + '  ' + ISNULL([AccountCode8], '') + '  ' + ISNULL([AccountCode9], '') + '  ' + ISNULL([AccountCode10], '') + '  ' + ISNULL([AccountCode11], '') + '  ' + ISNULL([AccountCode12], '') + '  ' + ISNULL([AccountCode13], '') + '  ' + ISNULL([AccountCode14], '') + '  ' + ISNULL([AccountCode15], '') + '  ' + ISNULL([AccountCode16], '') + '  ' + ISNULL([AccountCode17], '') + '  ' + ISNULL([AccountCode18], '') + '  ' + ISNULL([AccountCode19], '') + '  ' + ISNULL([AccountCode20], '') + '  ' + ISNULL([AccountCode21], '') + '  ' + ISNULL([AccountCode22], '') + '  ' + ISNULL([AccountCode23], ''))
		ELSE 
			NULL
	END AS [AccountCode23],
	CASE WHEN [AccountLevel] = 24
		THEN
			RTRIM(ISNULL([AccountCode1], '') + '  ' + ISNULL([AccountCode2], '') + '  ' + ISNULL([AccountCode3], '') + '  ' + ISNULL([AccountCode4], '') + '  ' + ISNULL([AccountCode5], '') + '  ' + ISNULL([AccountCode6], '') + '  ' + ISNULL([AccountCode7], '') + '  ' + ISNULL([AccountCode8], '') + '  ' + ISNULL([AccountCode9], '') + '  ' + ISNULL([AccountCode10], '') + '  ' + ISNULL([AccountCode11], '') + '  ' + ISNULL([AccountCode12], '') + '  ' + ISNULL([AccountCode13], '') + '  ' + ISNULL([AccountCode14], '') + '  ' + ISNULL([AccountCode15], '') + '  ' + ISNULL([AccountCode16], '') + '  ' + ISNULL([AccountCode17], '') + '  ' + ISNULL([AccountCode18], '') + '  ' + ISNULL([AccountCode19], '') + '  ' + ISNULL([AccountCode20], '') + '  ' + ISNULL([AccountCode21], '') + '  ' + ISNULL([AccountCode22], '') + '  ' + ISNULL([AccountCode23], '') + '  ' + ISNULL([AccountCode24], ''))
		ELSE 
			NULL
	END AS [AccountCode24],
	CASE WHEN [AccountLevel] = 25
		THEN
			RTRIM(ISNULL([AccountCode1], '') + '  ' + ISNULL([AccountCode2], '') + '  ' + ISNULL([AccountCode3], '') + '  ' + ISNULL([AccountCode4], '') + '  ' + ISNULL([AccountCode5], '') + '  ' + ISNULL([AccountCode6], '') + '  ' + ISNULL([AccountCode7], '') + '  ' + ISNULL([AccountCode8], '') + '  ' + ISNULL([AccountCode9], '') + '  ' + ISNULL([AccountCode10], '') + '  ' + ISNULL([AccountCode11], '') + '  ' + ISNULL([AccountCode12], '') + '  ' + ISNULL([AccountCode13], '') + '  ' + ISNULL([AccountCode14], '') + '  ' + ISNULL([AccountCode15], '') + '  ' + ISNULL([AccountCode16], '') + '  ' + ISNULL([AccountCode17], '') + '  ' + ISNULL([AccountCode18], '') + '  ' + ISNULL([AccountCode19], '') + '  ' + ISNULL([AccountCode20], '') + '  ' + ISNULL([AccountCode21], '') + '  ' + ISNULL([AccountCode22], '') + '  ' + ISNULL([AccountCode23], '') + '  ' + ISNULL([AccountCode24], '') + '  ' + ISNULL([AccountCode25], ''))
		ELSE 
			NULL
	END AS [AccountCode25],
	[AccountCode1] AS [AccountLevelCode1],
  [AccountCode2] AS [AccountLevelCode2], 
  [AccountCode3] AS [AccountLevelCode3],
  [AccountCode4] AS [AccountLevelCode4],
  [AccountCode5] AS [AccountLevelCode5],
  [AccountCode6] AS [AccountLevelCode6],
  [AccountCode7] AS [AccountLevelCode7],
  [AccountCode8] AS [AccountLevelCode8],
  [AccountCode9] AS [AccountLevelCode9],
  [AccountCode10] AS [AccountLevelCode10],
  [AccountCode11] AS [AccountLevelCode11],
  [AccountCode12] AS [AccountLevelCode12],
  [AccountCode13] AS [AccountLevelCode13],
  [AccountCode14] AS [AccountLevelCode14],
  [AccountCode15] AS [AccountLevelCode15],
  [AccountCode16] AS [AccountLevelCode16],
  [AccountCode17] AS [AccountLevelCode17],
  [AccountCode18] AS [AccountLevelCode18],
  [AccountCode19] AS [AccountLevelCode19],
  [AccountCode20] AS [AccountLevelCode20],
  [AccountCode21] AS [AccountLevelCode21],
  [AccountCode22] AS [AccountLevelCode22],
  [AccountCode23] AS [AccountLevelCode23],
  [AccountCode24] AS [AccountLevelCode24],
  [AccountCode25] AS [AccountLevelCode25],
  ISNULL([AccountTitle25], ISNULL([AccountTitle24], ISNULL([AccountTitle23], ISNULL([AccountTitle22], ISNULL([AccountTitle21], ISNULL([AccountTitle20], ISNULL([AccountTitle19], ISNULL([AccountTitle18], ISNULL([AccountTitle17], ISNULL([AccountTitle16], ISNULL([AccountTitle15], ISNULL([AccountTitle14], ISNULL([AccountTitle13], ISNULL([AccountTitle12], ISNULL([AccountTitle11], ISNULL([AccountTitle10], ISNULL([AccountTitle9], ISNULL([AccountTitle8], ISNULL([AccountTitle7], ISNULL([AccountTitle6], ISNULL([AccountTitle5], ISNULL([AccountTitle4], ISNULL([AccountTitle3], ISNULL([AccountTitle2], [AccountTitle1])))))))))))))))))))))))) AS [AccountTitle],
  [AccountTitle1],
  [AccountTitle2], 
  [AccountTitle3],
  [AccountTitle4],
  [AccountTitle5],
  [AccountTitle6],
  [AccountTitle7],
  [AccountTitle8],
  [AccountTitle9],
  [AccountTitle10],
  [AccountTitle11],
  [AccountTitle12],
  [AccountTitle13],
  [AccountTitle14],
  [AccountTitle15],
  [AccountTitle16],
  [AccountTitle17],
  [AccountTitle18],
  [AccountTitle19],
  [AccountTitle20],
  [AccountTitle21],
  [AccountTitle22],
  [AccountTitle23],
  [AccountTitle24],
  [AccountTitle25],
  [AccountComments1],
  [AccountComments2], 
  [AccountComments3],
  [AccountComments4],
  [AccountComments5],
  [AccountComments6],
  [AccountComments7],
  [AccountComments8],
  [AccountComments9],
  [AccountComments10],
  [AccountComments11],
  [AccountComments12],
  [AccountComments13],
  [AccountComments14],
  [AccountComments15],
  [AccountComments16],
  [AccountComments17],
  [AccountComments18],
  [AccountComments19],
  [AccountComments20],
  [AccountComments21],
  [AccountComments22],
  [AccountComments23],
  [AccountComments24],
  [AccountComments25],
	[FloatCategoryGuid1],
	[FloatCategoryGuid2],
	[FloatCategoryGuid3],
	[FloatCategoryGuid4],
	[FloatCategoryGuid5],
	[FloatCategoryGuid6],
	[FloatCategoryGuid7],
	[FloatCategoryGuid8],
	[FloatCategoryGuid9],
	[FloatCategoryGuid10],
	[FloatCategoryGuid11],
	[FloatCategoryGuid12],
	[FloatCategoryGuid13],
	[FloatCategoryGuid14],
	[FloatCategoryGuid15],
	[FloatCategoryGuid16],
	[FloatCategoryGuid17],
	[FloatCategoryGuid18],
	[FloatCategoryGuid19],
	[FloatCategoryGuid20],
	[FloatCategoryGuid21],
	[FloatCategoryGuid22],
	[FloatCategoryGuid23],
	[FloatCategoryGuid24],
	[FloatCategoryGuid25],
  CASE [AccountLevel]
		WHEN 1 THEN [FloatCategoryGuid1]
		WHEN 2 THEN [FloatCategoryGuid2]
		WHEN 3 THEN [FloatCategoryGuid3]
		WHEN 4 THEN [FloatCategoryGuid4]
		WHEN 5 THEN [FloatCategoryGuid5]
		WHEN 6 THEN [FloatCategoryGuid6]
		WHEN 7 THEN [FloatCategoryGuid7]
		WHEN 8 THEN [FloatCategoryGuid8]
		WHEN 9 THEN [FloatCategoryGuid9]
		WHEN 10 THEN [FloatCategoryGuid10]
		WHEN 11 THEN [FloatCategoryGuid11]
		WHEN 12 THEN [FloatCategoryGuid12]
		WHEN 13 THEN [FloatCategoryGuid13]
		WHEN 14 THEN [FloatCategoryGuid14]
		WHEN 15 THEN [FloatCategoryGuid15]
		WHEN 16 THEN [FloatCategoryGuid16]
		WHEN 17 THEN [FloatCategoryGuid17]
		WHEN 18 THEN [FloatCategoryGuid18]
		WHEN 19 THEN [FloatCategoryGuid19]
		WHEN 20 THEN [FloatCategoryGuid20]
		WHEN 21 THEN [FloatCategoryGuid21]
		WHEN 22 THEN [FloatCategoryGuid22]
		WHEN 23 THEN [FloatCategoryGuid23]
		WHEN 24 THEN [FloatCategoryGuid24]
		WHEN 25 THEN [FloatCategoryGuid25]
	END AS [FloatCategoryGuid],
	[PaymentNature],
	[PaymentRow],
	[SendReceiveNature],
	[SendReceiveRow],
	[CurrencyAmount],
	[Description],
	[Creditor],
	[Debitor],
	[RecouncilationExempt],
	[ReferenceIndex],
	[LetterNo],
	[LetterDate],
	[Comments],
	[CurrencyQuantity],
	[CurrencyActionType],
	[CurrencyUnitPrice],
	[BankAccountGuid],
	[BankDocumentApproved],
	[BankDocumentType],
	[BankDocumentNo],
	[BankDocumentDate],
  [BankDocumentGuid],
	[CostCenterID],
	[ReferenceGuid],
  [IdentifierGuid],
  [CurrencyGuid],
  [AccountLevel],
  [AccountGuid1],
  [AccountGuid2],
  [AccountGuid3],
  [AccountGuid4],
  [AccountGuid5],
  [AccountGuid6],
  [AccountGuid7],
  [AccountGuid8],
  [AccountGuid9],
  [AccountGuid10],
  [AccountGuid11],
  [AccountGuid12],
  [AccountGuid13],
  [AccountGuid14],
  [AccountGuid15],
  [AccountGuid16],
  [AccountGuid17],
  [AccountGuid18],
  [AccountGuid19],
  [AccountGuid20],
  [AccountGuid21],
  [AccountGuid22],
  [AccountGuid23],
  [AccountGuid24],
  [AccountGuid25],
  [ActivityId],
	[ExpenseId],
	[ActivityCode],
  [ExpenseCode],
	[FundID],
	[CreditSupplyDetailID],
	[CreditSupplyCode]
INTO
	#tempVouchersResult
FROM 
	#TempVoucherLevel15 

DROP TABLE #TempVoucherLevel15
-----------------------------------

SELECT
	vouchers.[VoucherGuid],
	vouchers.[Index],
	vouchers.[VoucherIndex],
	vouchers.[FiscalYearDetailGuid],
	vouchers.[FiscalYear],
	vouchers.[Day],
	vouchers.[Month],
	vouchers.[Year],
	vouchers.[Date],
	vouchers.[VoucherDescription],
	vouchers.[VoucherSourceSoftwareGuid],
	vouchers.[VoucherSourceReferenceGuid],
	vouchers.[VoucherType],
	vouchers.[VoucherDeleted],
	vouchers.[TraceNo],
	vouchers.[VoucherCategoryGuid],
	vouchers.[VoucherAmount],
	vouchers.[DebitorAmount],
	vouchers.[CreditorAmount],
	vouchers.[DefiniteIndexSequenceNo],
	vouchers.[DefiniteIndexPatternGuid],
	vouchers.[DefiniteDate],
	vouchers.[DefiniteIndex],
	vouchers.[AttachedArticle],
	vouchers.[VoucherStatusGuid],
	vouchers.[IsApproved],
	vouchers.[VoucherStatusTitle],
	vouchers.[AccountCode],
	vouchers.[AccountCode1],
	vouchers.[AccountCode2],
	vouchers.[AccountCode3],
	vouchers.[AccountCode4],
	vouchers.[AccountCode5],
	vouchers.[AccountCode6],
	vouchers.[AccountCode7],
	vouchers.[AccountCode8],
	vouchers.[AccountCode9],
	vouchers.[AccountCode10],
	vouchers.[AccountCode11],
	vouchers.[AccountCode12],
	vouchers.[AccountCode13],
	vouchers.[AccountCode14],
	vouchers.[AccountCode15],
	vouchers.[AccountCode16],
	vouchers.[AccountCode17],
	vouchers.[AccountCode18],
	vouchers.[AccountCode19],
	vouchers.[AccountCode20],
	vouchers.[AccountCode21],
	vouchers.[AccountCode22],
	vouchers.[AccountCode23],
	vouchers.[AccountCode24],
	vouchers.[AccountCode25],
	vouchers.[AccountLevelCode1],
	vouchers.[AccountLevelCode2],
	vouchers.[AccountLevelCode3],
	vouchers.[AccountLevelCode4],
	vouchers.[AccountLevelCode5],
	vouchers.[AccountLevelCode6],
	vouchers.[AccountLevelCode7],
	vouchers.[AccountLevelCode8],
	vouchers.[AccountLevelCode9],
	vouchers.[AccountLevelCode10],
	vouchers.[AccountLevelCode11],
	vouchers.[AccountLevelCode12],
	vouchers.[AccountLevelCode13],
	vouchers.[AccountLevelCode14],
	vouchers.[AccountLevelCode15],
	vouchers.[AccountLevelCode16],
	vouchers.[AccountLevelCode17],
	vouchers.[AccountLevelCode18],
	vouchers.[AccountLevelCode19],
	vouchers.[AccountLevelCode20],
	vouchers.[AccountLevelCode21],
	vouchers.[AccountLevelCode22],
	vouchers.[AccountLevelCode23],
	vouchers.[AccountLevelCode24],
	vouchers.[AccountLevelCode25],
	vouchers.[AccountTitle],
	vouchers.[AccountTitle1],
	vouchers.[AccountTitle2],
	vouchers.[AccountTitle3],
	vouchers.[AccountTitle4],
	vouchers.[AccountTitle5],
	vouchers.[AccountTitle6],
	vouchers.[AccountTitle7],
	vouchers.[AccountTitle8],
	vouchers.[AccountTitle9],
	vouchers.[AccountTitle10],
	vouchers.[AccountTitle11],
	vouchers.[AccountTitle12],
	vouchers.[AccountTitle13],
	vouchers.[AccountTitle14],
	vouchers.[AccountTitle15],
	vouchers.[AccountTitle16],
	vouchers.[AccountTitle17],
	vouchers.[AccountTitle18],
	vouchers.[AccountTitle19],
	vouchers.[AccountTitle20],
	vouchers.[AccountTitle21],
	vouchers.[AccountTitle22],
	vouchers.[AccountTitle23],
	vouchers.[AccountTitle24],
	vouchers.[AccountTitle25],
	vouchers.[AccountComments1],
	vouchers.[AccountComments2],
	vouchers.[AccountComments3],
	vouchers.[AccountComments4],
	vouchers.[AccountComments5],
	vouchers.[AccountComments6],
	vouchers.[AccountComments7],
	vouchers.[AccountComments8],
	vouchers.[AccountComments9],
	vouchers.[AccountComments10],
	vouchers.[AccountComments11],
	vouchers.[AccountComments12],
	vouchers.[AccountComments13],
	vouchers.[AccountComments14],
	vouchers.[AccountComments15],
	vouchers.[AccountComments16],
	vouchers.[AccountComments17],
	vouchers.[AccountComments18],
	vouchers.[AccountComments19],
	vouchers.[AccountComments20],
	vouchers.[AccountComments21],
	vouchers.[AccountComments22],
	vouchers.[AccountComments23],
	vouchers.[AccountComments24],
	vouchers.[AccountComments25],
	vouchers.[FloatCategoryGuid1],
	vouchers.[FloatCategoryGuid2],
	vouchers.[FloatCategoryGuid3],
	vouchers.[FloatCategoryGuid4],
	vouchers.[FloatCategoryGuid5],
	vouchers.[FloatCategoryGuid6],
	vouchers.[FloatCategoryGuid7],
	vouchers.[FloatCategoryGuid8],
	vouchers.[FloatCategoryGuid9],
	vouchers.[FloatCategoryGuid10],
	vouchers.[FloatCategoryGuid11],
	vouchers.[FloatCategoryGuid12],
	vouchers.[FloatCategoryGuid13],
	vouchers.[FloatCategoryGuid14],
	vouchers.[FloatCategoryGuid15],
	vouchers.[FloatCategoryGuid16],
	vouchers.[FloatCategoryGuid17],
	vouchers.[FloatCategoryGuid18],
	vouchers.[FloatCategoryGuid19],
	vouchers.[FloatCategoryGuid20],
	vouchers.[FloatCategoryGuid21],
	vouchers.[FloatCategoryGuid22],
	vouchers.[FloatCategoryGuid23],
	vouchers.[FloatCategoryGuid24],
	vouchers.[FloatCategoryGuid25],
	vouchers.[FloatCategoryGuid],
	vouchers.[PaymentNature],
	vouchers.[PaymentRow],
	vouchers.[SendReceiveNature],
	vouchers.[SendReceiveRow],
	vouchers.[CurrencyAmount],
	vouchers.[Description],
	vouchers.[Creditor],
	vouchers.[Debitor],
	vouchers.[RecouncilationExempt],
	vouchers.[ReferenceIndex],
	vouchers.[LetterNo],
	vouchers.[LetterDate],
	vouchers.[Comments],
	vouchers.[CurrencyQuantity],
	vouchers.[CurrencyActionType],
	vouchers.[CurrencyUnitPrice],
	vouchers.[BankAccountGuid],
	vouchers.[BankDocumentApproved],
	vouchers.[BankDocumentType],
	vouchers.[BankDocumentNo],
	vouchers.[BankDocumentDate],
	vouchers.[BankDocumentGuid],
	vouchers.[CostCenterID],
	vouchers.[ReferenceGuid],
	vouchers.[IdentifierGuid],
	vouchers.[CurrencyGuid],
	vouchers.[AccountLevel],
	vouchers.[AccountGuid1],
	vouchers.[AccountGuid2],
	vouchers.[AccountGuid3],
	vouchers.[AccountGuid4],
	vouchers.[AccountGuid5],
	vouchers.[AccountGuid6],
	vouchers.[AccountGuid7],
	vouchers.[AccountGuid8],
	vouchers.[AccountGuid9],
	vouchers.[AccountGuid10],
	vouchers.[AccountGuid11],
	vouchers.[AccountGuid12],
	vouchers.[AccountGuid13],
	vouchers.[AccountGuid14],
	vouchers.[AccountGuid15],
	vouchers.[AccountGuid16],
	vouchers.[AccountGuid17],
	vouchers.[AccountGuid18],
	vouchers.[AccountGuid19],
	vouchers.[AccountGuid20],
	vouchers.[AccountGuid21],
	vouchers.[AccountGuid22],
	vouchers.[AccountGuid23],
	vouchers.[AccountGuid24],
	vouchers.[AccountGuid25],
	vouchers.[ActivityId],
	vouchers.[ExpenseId],
	vouchers.[ActivityCode],
	vouchers.[ExpenseCode],
	vouchers.[FundID],
	vouchers.[CreditSupplyDetailID],
	vouchers.[CreditSupplyCode],
	floatCategories.[Title] AS [FloatCategoryTitle],
	(ABS(vouchers.[Creditor]) + ABS(vouchers.[Debitor])) AS [ArticleAmount],
	[ChequeDate],
	[ChequeNo],
	notes.[Date] AS [NotesReceivableDate],
	notes.[No] AS [NotesReceivableNo],
	0 AS [CostCenterTypeID],
	'' AS [CostCenterTitle],
	'' AS [CostCenterCode],
	[ReferenceTypeGuid],
	refrences.Title AS [ReferenceTitle],
	refrences.Code AS [ReferenceCode],
	[IdentifierTypeGuid],
	identifiers.Title AS [IdentifierTitle],
	identifiers.Code [IdentifierCode]
INTO
	#TempVoucherArticlesResult
FROM 
	#tempVouchersResult vouchers LEFT JOIN
	fin_FloatAccountsCategory floatCategories ON vouchers.[FloatCategoryGuid] = floatCategories.[Guid] LEFT JOIN
	fin_Identifiers identifiers ON vouchers.[IdentifierGuid] = identifiers.[Guid] LEFT JOIN
	--com_CostCenters costCenters ON costCenters.[ID] = vouchers.[CostCenterID] LEFT JOIN
	fin_References refrences ON refrences.[Guid] = vouchers.[ReferenceGuid]  LEFT JOIN
	fin_Cheques AS cheques ON 
	(
		cheques.ChequeNo != '0' AND 
		ISNULL(cheques.[Deleted], 0) = 0 AND
		vouchers.[BankDocumentType] = 1 AND /*eBankDocumentType.cheque*/ 
		vouchers.[BankDocumentNo] = CAST(cheques.[ChequeNo] AS NVARCHAR(32)) AND 
		vouchers.[BankAccountGuid] = cheques.[BankAccountGuid] 
	) LEFT JOIN
	fin_NotesReceivable AS notes ON 
	(
		vouchers.[BankDocumentGuid] = notes.[Guid] AND
		vouchers.[BankDocumentType] = 5 /*eBankDocumentType.cheque*/ AND
		ISNULL(notes.[Deleted], 0) = 0
	)    


-------------------------------------------------------------------------------------------------------------------

DROP TABLE #tempVouchersResult

DECLARE @Date datetime
set @Date = getdate()


SELECT 
	[FiscalYearDetailGuid],
	[VoucherGuid],
	[VoucherIndex],
	[VoucherDescription],
	[VoucherStatusGuid],
	[VoucherStatusTitle],
	[VoucherSourceSoftwareGuid],		
	dbo.fin_udfGetSolarDate([Date]) AS [Date],
	ISNULL([DefiniteIndex],'') AS [DefiniteIndex],
	ISNULL(dbo.fin_udfGetSolarDate([DefiniteDate]),'') AS [DefiniteDate],
	[TraceNo],
	(SELECT DISTINCT ' ، ' + [AccountTitle1] FROM #TempVoucherArticlesResult WHERE [VoucherGuid] = VA.[VoucherGuid] FOR XML PATH ('')) AS [AccountTitles],  -- Select all account title in level 1 that usage in this article
	(SELECT DISTINCT ' ، ' + CAST([VoucherIndex] AS VARCHAR(32)) FROM #TempVoucherArticlesResult WHERE [Date] = VA.[Date] FOR XML PATH ('')) AS [VoucherIndexes],  -- Select all account title in level 1 that usage in this article
	[Index],
	[LetterNo],
	ISNULL(dbo.fin_udfGetSolarDate([LetterDate]),'') AS [LetterDate],
	[AccountLevel],
	[AccountCode],
	[AccountTitle],
	[Description] AS [ArticleDescription],
	[Creditor],
	[Debitor],
	([Creditor] - [Debitor]) AS [ArticleAmount],
	[AttachedArticle],
	ISNULL([Comments],'') AS [Comments],
	
	ISNULL([AccountGuid1],@EmptyGuid) AS [AccountGuid1],
	ISNULL([AccountGuid2],@EmptyGuid) AS [AccountGuid2],
	ISNULL([AccountGuid3],@EmptyGuid) AS [AccountGuid3],
	ISNULL([AccountGuid4],@EmptyGuid) AS [AccountGuid4],
	ISNULL([AccountGuid5],@EmptyGuid) AS [AccountGuid5],
	ISNULL([AccountGuid6],@EmptyGuid) AS [AccountGuid6],
	ISNULL([AccountGuid7],@EmptyGuid) AS [AccountGuid7],
	ISNULL([AccountGuid8],@EmptyGuid) AS [AccountGuid8],
	ISNULL([AccountGuid9],@EmptyGuid) AS [AccountGuid9],
	ISNULL([AccountGuid10],@EmptyGuid) AS [AccountGuid10],
	ISNULL([AccountGuid11],@EmptyGuid) AS [AccountGuid11],
	ISNULL([AccountGuid12],@EmptyGuid) AS [AccountGuid12],
	ISNULL([AccountGuid13],@EmptyGuid) AS [AccountGuid13],
	ISNULL([AccountGuid14],@EmptyGuid) AS [AccountGuid14],
	ISNULL([AccountGuid15],@EmptyGuid) AS [AccountGuid15],
	ISNULL([AccountGuid16],@EmptyGuid) AS [AccountGuid16],
	ISNULL([AccountGuid17],@EmptyGuid) AS [AccountGuid17],
	ISNULL([AccountGuid18],@EmptyGuid) AS [AccountGuid18],
	ISNULL([AccountGuid19],@EmptyGuid) AS [AccountGuid19],
	ISNULL([AccountGuid20],@EmptyGuid) AS [AccountGuid20],
	ISNULL([AccountGuid21],@EmptyGuid) AS [AccountGuid21],
	ISNULL([AccountGuid22],@EmptyGuid) AS [AccountGuid22],
	ISNULL([AccountGuid23],@EmptyGuid) AS [AccountGuid23],
	ISNULL([AccountGuid24],@EmptyGuid) AS [AccountGuid24],
	ISNULL([AccountGuid25],@EmptyGuid) AS [AccountGuid25],
	
	ISNULL([AccountCode1],'') AS [AccountCode1],
	ISNULL([AccountCode2],'') AS [AccountCode2],
	ISNULL([AccountCode3],'') AS [AccountCode3],
	ISNULL([AccountCode4],'') AS [AccountCode4],
	ISNULL([AccountCode5],'') AS [AccountCode5],
	ISNULL([AccountCode6],'') AS [AccountCode6],
	ISNULL([AccountCode7],'') AS [AccountCode7],
	ISNULL([AccountCode8],'') AS [AccountCode8],
	ISNULL([AccountCode9],'') AS [AccountCode9],
	ISNULL([AccountCode10],'') AS [AccountCode10],
	ISNULL([AccountCode11],'') AS [AccountCode11],
	ISNULL([AccountCode12],'') AS [AccountCode12],
	ISNULL([AccountCode13],'') AS [AccountCode13],
	ISNULL([AccountCode14],'') AS [AccountCode14],
	ISNULL([AccountCode15],'') AS [AccountCode15], 
	ISNULL([AccountCode16],'') AS [AccountCode16], 
	ISNULL([AccountCode17],'') AS [AccountCode17], 
	ISNULL([AccountCode18],'') AS [AccountCode18], 
	ISNULL([AccountCode19],'') AS [AccountCode19], 
	ISNULL([AccountCode20],'') AS [AccountCode20], 
	ISNULL([AccountCode21],'') AS [AccountCode21], 
	ISNULL([AccountCode22],'') AS [AccountCode22], 
	ISNULL([AccountCode23],'') AS [AccountCode23], 
	ISNULL([AccountCode24],'') AS [AccountCode24], 
	ISNULL([AccountCode25],'') AS [AccountCode25], 
	
	ISNULL([AccountLevelCode1],'') AS [AccountLevelCode1],
	ISNULL([AccountLevelCode2],'') AS [AccountLevelCode2],
	ISNULL([AccountLevelCode3],'') AS [AccountLevelCode3],
	ISNULL([AccountLevelCode4],'') AS [AccountLevelCode4],
	ISNULL([AccountLevelCode5],'') AS [AccountLevelCode5],
	ISNULL([AccountLevelCode6],'') AS [AccountLevelCode6],
	ISNULL([AccountLevelCode7],'') AS [AccountLevelCode7],
	ISNULL([AccountLevelCode8],'') AS [AccountLevelCode8],
	ISNULL([AccountLevelCode9],'') AS [AccountLevelCode9],
	ISNULL([AccountLevelCode10],'') AS [AccountLevelCode10],
	ISNULL([AccountLevelCode11],'') AS [AccountLevelCode11],
	ISNULL([AccountLevelCode12],'') AS [AccountLevelCode12],
	ISNULL([AccountLevelCode13],'') AS [AccountLevelCode13],
	ISNULL([AccountLevelCode14],'') AS [AccountLevelCode14],
	ISNULL([AccountLevelCode15],'') AS [AccountLevelCode15],
	ISNULL([AccountLevelCode15],'') AS [AccountLevelCode15],
	ISNULL([AccountLevelCode16],'') AS [AccountLevelCode16],
	ISNULL([AccountLevelCode17],'') AS [AccountLevelCode17],
	ISNULL([AccountLevelCode18],'') AS [AccountLevelCode18],
	ISNULL([AccountLevelCode19],'') AS [AccountLevelCode19],
	ISNULL([AccountLevelCode20],'') AS [AccountLevelCode20],
	ISNULL([AccountLevelCode21],'') AS [AccountLevelCode21],
	ISNULL([AccountLevelCode22],'') AS [AccountLevelCode22],
	ISNULL([AccountLevelCode23],'') AS [AccountLevelCode23],
	ISNULL([AccountLevelCode24],'') AS [AccountLevelCode24],
	ISNULL([AccountLevelCode25],'') AS [AccountLevelCode25],
	
	ISNULL(REPLACE([AccountComments1],'SystemCreated',''),'') AS [AccountComments1],
	ISNULL(REPLACE([AccountComments2],'SystemCreated',''),'') AS [AccountComments2],
	ISNULL(REPLACE([AccountComments3],'SystemCreated',''),'') AS [AccountComments3],
	ISNULL(REPLACE([AccountComments4],'SystemCreated',''),'') AS [AccountComments4],
	ISNULL(REPLACE([AccountComments5],'SystemCreated',''),'') AS [AccountComments5],
	ISNULL(REPLACE([AccountComments6],'SystemCreated',''),'') AS [AccountComments6],
	ISNULL(REPLACE([AccountComments7],'SystemCreated',''),'') AS [AccountComments7],
	ISNULL(REPLACE([AccountComments8],'SystemCreated',''),'') AS [AccountComments8],
	ISNULL(REPLACE([AccountComments9],'SystemCreated',''),'') AS [AccountComments9],
	ISNULL(REPLACE([AccountComments10],'SystemCreated',''),'') AS [AccountComments10],
	ISNULL(REPLACE([AccountComments11],'SystemCreated',''),'') AS [AccountComments11],
	ISNULL(REPLACE([AccountComments12],'SystemCreated',''),'') AS [AccountComments12],
	ISNULL(REPLACE([AccountComments13],'SystemCreated',''),'') AS [AccountComments13],
	ISNULL(REPLACE([AccountComments14],'SystemCreated',''),'') AS [AccountComments14],
	ISNULL(REPLACE([AccountComments15],'SystemCreated',''),'') AS [AccountComments15],
	ISNULL(REPLACE([AccountComments16],'SystemCreated',''),'') AS [AccountComments16],
	ISNULL(REPLACE([AccountComments17],'SystemCreated',''),'') AS [AccountComments17],
	ISNULL(REPLACE([AccountComments18],'SystemCreated',''),'') AS [AccountComments18],
	ISNULL(REPLACE([AccountComments19],'SystemCreated',''),'') AS [AccountComments19],
	ISNULL(REPLACE([AccountComments20],'SystemCreated',''),'') AS [AccountComments20],
	ISNULL(REPLACE([AccountComments21],'SystemCreated',''),'') AS [AccountComments21],
	ISNULL(REPLACE([AccountComments22],'SystemCreated',''),'') AS [AccountComments22],
	ISNULL(REPLACE([AccountComments23],'SystemCreated',''),'') AS [AccountComments23],
	ISNULL(REPLACE([AccountComments24],'SystemCreated',''),'') AS [AccountComments24],
	ISNULL(REPLACE([AccountComments25],'SystemCreated',''),'') AS [AccountComments25],

	ISNULL([AccountTitle1],'') AS [AccountTitle1],
	ISNULL([AccountTitle2],'') AS [AccountTitle2],
	ISNULL([AccountTitle3],'') AS [AccountTitle3],
	ISNULL([AccountTitle4],'') AS [AccountTitle4],
	ISNULL([AccountTitle5],'') AS [AccountTitle5],
	ISNULL([AccountTitle6],'') AS [AccountTitle6],
	ISNULL([AccountTitle7],'') AS [AccountTitle7],
	ISNULL([AccountTitle8],'') AS [AccountTitle8],
	ISNULL([AccountTitle9],'') AS [AccountTitle9],
	ISNULL([AccountTitle10],'') AS [AccountTitle10],
	ISNULL([AccountTitle11],'') AS [AccountTitle11],
	ISNULL([AccountTitle12],'') AS [AccountTitle12],
	ISNULL([AccountTitle13],'') AS [AccountTitle13],
	ISNULL([AccountTitle14],'') AS [AccountTitle14],
	ISNULL([AccountTitle15],'') AS [AccountTitle15],
	ISNULL([AccountTitle16],'') AS [AccountTitle16],
	ISNULL([AccountTitle17],'') AS [AccountTitle17],
	ISNULL([AccountTitle18],'') AS [AccountTitle18],
	ISNULL([AccountTitle19],'') AS [AccountTitle19],
	ISNULL([AccountTitle20],'') AS [AccountTitle20],
	ISNULL([AccountTitle21],'') AS [AccountTitle21],
	ISNULL([AccountTitle22],'') AS [AccountTitle22],
	ISNULL([AccountTitle23],'') AS [AccountTitle23],
	ISNULL([AccountTitle24],'') AS [AccountTitle24],
	ISNULL([AccountTitle25],'') AS [AccountTitle25],
	
	@SystemAccountCode3 AS [SystemAccountCode3],
	@SystemAccountCode4 AS [SystemAccountCode4],
	@SystemAccountCode5 AS [SystemAccountCode5],
	@SystemAccountCode6 AS [SystemAccountCode6],
	@SystemAccountCode7 AS [SystemAccountCode7],
	@SystemAccountCode8 AS [SystemAccountCode8],
	@SystemAccountCode9 AS [SystemAccountCode9],
	@SystemAccountCode10 AS [SystemAccountCode10],
	@SystemAccountCode11 AS [SystemAccountCode11],
	@SystemAccountCode12 AS [SystemAccountCode12],
	@SystemAccountCode13 AS [SystemAccountCode13],
	@SystemAccountCode14 AS [SystemAccountCode14],
	@SystemAccountCode15 AS [SystemAccountCode15],
	@SystemAccountCode16 AS [SystemAccountCode16],
	@SystemAccountCode17 AS [SystemAccountCode17],
	@SystemAccountCode18 AS [SystemAccountCode18],
	@SystemAccountCode19 AS [SystemAccountCode19],
	@SystemAccountCode20 AS [SystemAccountCode20],
	@SystemAccountCode21 AS [SystemAccountCode21],
	@SystemAccountCode22 AS [SystemAccountCode22],
	@SystemAccountCode23 AS [SystemAccountCode23],
	@SystemAccountCode24 AS [SystemAccountCode24],
	@SystemAccountCode25 AS [SystemAccountCode25],
	
	ISNULL([AccountTitle2],'')+CHAR(13)+ ISNULL([AccountTitle3],'')+CHAR(13)+	ISNULL([AccountTitle4],'')+CHAR(13)+ISNULL([AccountTitle5],'')+CHAR(13)
			+ ISNULL([AccountTitle6],'')+CHAR(13)+ISNULL([AccountTitle7],'')+CHAR(13)+ISNULL([AccountTitle8],'')+CHAR(13)+ISNULL([AccountTitle9],'')+CHAR(13)
			+ ISNULL([AccountTitle10],'')+CHAR(13)+ISNULL([AccountTitle11],'')+CHAR(13)+ISNULL([AccountTitle12],'')+CHAR(13)+ISNULL([AccountTitle13],'')+CHAR(13)
			+ ISNULL([AccountTitle14],'')+CHAR(13)+ISNULL([AccountTitle15],'')+CHAR(13)+ISNULL([AccountTitle16],'')+CHAR(13)+ISNULL([AccountTitle17],'')+CHAR(13)
			+ ISNULL([AccountTitle18],'')+CHAR(13)+ISNULL([AccountTitle19],'')+CHAR(13)+ISNULL([AccountTitle20],'')+CHAR(13)+ISNULL([AccountTitle21],'')+CHAR(13)
			+ ISNULL([AccountTitle22],'')+CHAR(13)+ ISNULL([AccountTitle23],'')+CHAR(13)+ ISNULL([AccountTitle24],'')+CHAR(13)+ ISNULL([AccountTitle25],'') AS [AllAccountTitle],
	ISNULL([IdentifierCode],'') AS [IdentifierCode],
	ISNULL([ReferenceCode],'') AS [ReferenceCode],
	ISNULL([ReferenceIndex],'') AS [ReferenceIndex],
	ISNULL([CostCenterCode],'') AS [CostCenterCode],
	ISNULL([IdentifierTitle],'') AS [IdentifierTitle],
	ISNULL([ReferenceTitle],'') AS [ReferenceTitle],
	ISNULL([CostCenterTitle],'') AS [CostCenterTitle],
	[CurrencyAmount],
	[CurrencyQuantity],
	[CurrencyGuid],
	[CurrencyUnitPrice],
	[ActivityId],
  [ExpenseId],
	[ActivityCode],
	[ExpenseCode],
  [FundID],
  [CreditSupplyDetailID],
  [CreditSupplyCode],
  [RecouncilationExempt],
	ISNULL([BankAccountGuid],@EmptyGuid) AS [BankAccountGuid],
	CASE [BankDocumentType] 
		WHEN 1 THEN ISNULL(dbo.fin_udfGetSolarDate([ChequeDate]),'')
		WHEN 5 THEN ISNULL(dbo.fin_udfGetSolarDate([NotesReceivableDate]),'')
		ELSE ISNULL(dbo.fin_udfGetSolarDate([BankDocumentDate]),'')
	END AS [BankDocumentDate],
	ISNULL([BankDocumentNo],0) AS [BankDocumentNo],
	CASE [Creditor] WHEN 0 THEN 1 ELSE 2 END AS [Nature],
	@FirstFloatAccountIndex AS [FirstFloatLevel],
	SUBSTRING([AccountCode], 1, @NotFloatDigitCount) AS [NotFloatAccountCode],
	CASE  
		WHEN [AttachedArticle] = 1 AND [AccountLevel] = 2 THEN
			[AccountCode1]
		WHEN [AttachedArticle] = 1 AND [AccountLevel] = 3 THEN
			[AccountCode2]
		WHEN [AttachedArticle] = 1 AND [AccountLevel] = 4 THEN
			[AccountCode3]
		WHEN [AttachedArticle] = 1 AND [AccountLevel] = 5 THEN
			[AccountCode4]
		WHEN [AttachedArticle] = 1 AND [AccountLevel] = 6 THEN
			[AccountCode5]
		WHEN [AttachedArticle] = 1 AND [AccountLevel] = 7 THEN
			[AccountCode6]
		WHEN [AttachedArticle] = 1 AND [AccountLevel] = 8 THEN
			[AccountCode7]
		WHEN [AttachedArticle] = 1 AND [AccountLevel] = 9 THEN
			[AccountCode8]
		WHEN [AttachedArticle] = 1 AND [AccountLevel] = 10 THEN
			[AccountCode9]
		WHEN [AttachedArticle] = 1 AND [AccountLevel] = 11 THEN
			[AccountCode10]
		WHEN [AttachedArticle] = 1 AND [AccountLevel] = 12 THEN
			[AccountCode11]
		WHEN [AttachedArticle] = 1 AND [AccountLevel] = 13 THEN
			[AccountCode12]
		WHEN [AttachedArticle] = 1 AND [AccountLevel] = 14 THEN
			[AccountCode13]
		WHEN [AttachedArticle] = 1 AND [AccountLevel] = 15 THEN
			[AccountCode14]
		WHEN [AttachedArticle] = 1 AND [AccountLevel] = 16 THEN
			[AccountCode15]
		WHEN [AttachedArticle] = 1 AND [AccountLevel] = 17 THEN
			[AccountCode16]
		WHEN [AttachedArticle] = 1 AND [AccountLevel] = 18 THEN
			[AccountCode17]
		WHEN [AttachedArticle] = 1 AND [AccountLevel] = 19 THEN
			[AccountCode18]
		WHEN [AttachedArticle] = 1 AND [AccountLevel] = 20 THEN
			[AccountCode19]
		WHEN [AttachedArticle] = 1 AND [AccountLevel] = 21 THEN
			[AccountCode20]
		WHEN [AttachedArticle] = 1 AND [AccountLevel] = 22 THEN
			[AccountCode21]
		WHEN [AttachedArticle] = 1 AND [AccountLevel] = 23 THEN
			[AccountCode22]
		WHEN [AttachedArticle] = 1 AND [AccountLevel] = 24 THEN
			[AccountCode23]
		WHEN [AttachedArticle] = 1 AND [AccountLevel] = 25 THEN
			[AccountCode24]
		ELSE
			[AccountCode]
	END AS [AccountCodeGroup],
	@CountRangeVouchers AS [CountRangeVouchers],
	@FloatAccountTitle1 AS [FloatAccountTitle1],
	@FloatAccountTitle2 AS [FloatAccountTitle2],
	@FloatAccountTitle3 AS [FloatAccountTitle3],
	@FloatAccountTitle4 AS [FloatAccountTitle4],
	permanent.Title AS VoucherCategoryTitle
FROM
	#TempVoucherArticlesResult VA left join fin_Permanents permanent ON va.VoucherCategoryGuid=permanent.Guid
WHERE
	(@FromDate = '' OR [Date] >= @FromDate)	AND
	(@ToDate = '' OR [Date] <= @ToDate) AND
	(@FromReferenceDate = '' OR [LetterDate] >= @FromReferenceDate)	AND
	(@ToReferenceDate = '' OR [LetterDate] <= @ToReferenceDate) AND
	(@FromDefiniteDate = '' OR [DefiniteDate] >= @FromDefiniteDate)	AND
	(@ToDefiniteDate = '' OR [DefiniteDate] <= @ToDefiniteDate) AND
	(@FromIndex = 0 OR [VoucherIndex] >= @FromIndex) AND
	(@ToIndex = 0 OR [VoucherIndex] <= @ToIndex) AND
	(@FromTraceNo = 0 OR [TraceNo] >= @FromTraceNo) AND
	(@ToTraceNo = 0 OR [TraceNo] <= @ToTraceNo) AND
	(@VoucherType = 0 OR [VoucherType] = @VoucherType) AND
	(@SourceSoftwareGuid = @EmptyGuid OR [VoucherSourceSoftwareGuid] = @SourceSoftwareGuid) AND
	(@FromReferenceIndex = 0 OR [ReferenceIndex] >= @FromReferenceIndex) AND
	(@ToReferenceIndex = 0 OR [ReferenceIndex] <= @ToReferenceIndex) AND
	(@FromNoteNo = 0 OR [BankDocumentNo] >= @FromNoteNo) AND
	(@ToNoteNo = 0 OR [BankDocumentNo] <= @ToNoteNo) AND
	(@FromArticleAmount = 0 OR [ArticleAmount] >= @FromArticleAmount) AND
	(@ToArticleAmount = 0 OR [ArticleAmount] <= @ToArticleAmount) AND
	--(@FromVoucherAmount = 0 OR [VoucherAmount] >= @FromVoucherAmount) AND
	--(@ToVoucherAmount = 0 OR [VoucherAmount] <= @ToVoucherAmount) AND
	(@FromVoucherAmount = 0 OR ([DebitorAmount] >= @FromVoucherAmount OR [CreditorAmount] >= @FromVoucherAmount)) AND
	(@ToVoucherAmount = 0 OR ([DebitorAmount] <= @ToVoucherAmount OR [CreditorAmount] <= @ToVoucherAmount)) AND
	(@FromDefiniteIndex = 0 OR [DefiniteIndexSequenceNo] >= @FromDefiniteIndex) AND
	(@ToDefiniteIndex = 0 OR [DefiniteIndexSequenceNo] <= @ToDefiniteIndex)AND
	(@CostCenterTypeID = 0 OR [CostCenterTypeID] = @CostCenterTypeID) AND
	(@IdentifierTypeGuid = @EmptyGuid OR [IdentifierTypeGuid] = @IdentifierTypeGuid) AND
	(@AccountReferenceTypeGuid = @EmptyGuid OR [ReferenceTypeGuid] = @AccountReferenceTypeGuid) AND
	(ISNULL(@VoucherCategoryGuids, CAST(@EmptyGuid AS nvarchar(36))) = CAST(@EmptyGuid AS nvarchar(36)) OR ',' + @VoucherCategoryGuids + ',' LIKE '%,' + CAST([VoucherCategoryGuid] AS VARCHAR(36)) + ',%') AND
	(@DefiniteIndexPatternGuid = @EmptyGuid OR [DefiniteIndexPatternGuid] = @DefiniteIndexPatternGuid) AND
	(@PartialCode = '' OR REPLACE([AccountCode],' ','') LIKE @PartialCode) AND
	(@PartialCode != '' OR
			(@HasPartialCodeFrom = 0 OR SUBSTRING(REPLACE([AccountCode],' ',''),@StartIndexPartialCodeFrom,@LenghthPartialCodeFrom) >= @PartialCodeFrom) AND 
			(@HasPartialCodeTo = 0 OR SUBSTRING(REPLACE([AccountCode],' ',''),@StartIndexPartialCodeTo,@LenghthPartialCodeTo) <= @PartialCodeTo)) AND
	(@AccountCodeStart = '' OR REPLACE([AccountCode], ' ', '') LIKE @AccountCodeStart+'%' OR REPLACE([AccountCode], ' ', '') >= @AccountCodeStart) AND
	(@AccountCodeEnd = '' OR REPLACE([AccountCode], ' ', '') LIKE @AccountCodeEnd+'%' OR REPLACE([AccountCode], ' ', '') <= @AccountCodeEnd) AND
	(ISNULL(@CostCenterIDs, '') = '' OR ',' + @CostCenterIDs +  ',' LIKE '%,' + CAST([CostCenterID] as VARCHAR(32)) + ',%') AND
	(ISNULL(@IdentifierGuids, '') = '' OR ',' + @IdentifierGuids + ',' LIKE '%,' + CAST([IdentifierGuid] AS VARCHAR(36)) + ',%') AND
	(ISNULL(@AccountReferenceGuids, '') = '' OR ',' + @AccountReferenceGuids + ',' LIKE '%,' + CAST([ReferenceGuid] AS VARCHAR(36)) + ',%') AND
	(@StatusList = @EmptyGuid OR @StatusList LIKE '%' + CONVERT(VARCHAR(36), [VoucherStatusGuid]) + '%') AND
	(@RangeIndex = '' OR ','+ @RangeIndex +',' LIKE '%,' + CAST([VoucherIndex] AS NVARCHAR(32)) + ',%') AND
	(@Keyword = '' OR [Description] LIKE '%' + @Keyword + '%'  OR [VoucherDescription] LIKE '%' + @Keyword + '%')
ORDER BY 
		[Index],
		[Date],
		[VoucherIndex],
		[AccountCode2],
		[AccountCode]

DROP TABLE #TempVoucherArticlesResult
GO


