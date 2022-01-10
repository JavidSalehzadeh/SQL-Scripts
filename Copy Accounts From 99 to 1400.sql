
--SELECT * INTO [Backups].[dbo].[Didgah_FinancialAccounting_Accrual_SpecializedTrainingCenter_fin_AccountBankAccounts_000206]
--FROM [Didgah_FinancialAccounting_Accrual_SpecializedTrainingCenter].[dbo].[fin_AccountBankAccounts]
--SELECT * INTO [Backups].[dbo].[Didgah_FinancialAccounting_Accrual_SpecializedTrainingCenter_fin_Accounts_000206]
--FROM [Didgah_FinancialAccounting_Accrual_SpecializedTrainingCenter].[dbo].[fin_Accounts]

DECLARE @OldFiscalYear VARCHAR(4) ='1399',@FiscalYear VARCHAR(4) ='1400', @FiscalYearDetailGuid UNIQUEIDENTIFIER 

SELECT @FiscalYearDetailGuid=GUID FROM Didgah_Common..com_FiscalYearDetails WHERE FiscalYear=@FiscalYear;

SELECT A.[Comments],
       A.[Active],
       A.[Deleted],
       A.[Code],
       @FiscalYear AS FiscalYear,
       A.[CurrencyBased],
       A.[Level],
       A.[SourceAccountId],
       A.[DuplicationBatchGuid],
       A.[Title],
       A.[MaximumNature],
       A.[CategoryID],
       A.[Nature],
       A.[SystemAccount],
       A.[FinancialAccountSourceID],
       A.[FinancialAccountBindingID],
       NEWID() AS [Guid],
       FAC.GUID AS [CategoryGuid],
       A.[SendReceiveNature],
       A.[SendReceiveRow],
       A.[PaymentNature],
       A.[PaymentRow],
       A.[Permanent],
       A.[UseInDraft],
       A.[DraftType],
       A.[UseInCostVoucher],
       A.[CostType],
       A.[BalanceSheetNature],
       A.[SubtractFundingNature],
       A.[SeparateSubtractFundingColumn],
       A.[ProfitAndLossNature],
       A.[Guid] AS [SourceAccountGuid],
       A.[BudgetActive],
       A.[BudgetExpenseVoucherID],
       A.[BudgetType],
       A.[ExternalEntityGuid],
       A.[IsFixedRate],
       A.[FixedRate],
       @FiscalYearDetailGuid AS [FiscalYearDetailGuid] 
INTO #Accounts
FROM [Didgah_FinancialAccounting_Accrual_SpecializedTrainingCenter].[dbo].[fin_Accounts] A
JOIN [Didgah_FinancialAccounting_Accrual_SpecializedTrainingCenter].[dbo].[fin_FloatAccountsCategory] FAC 
ON FAC.SourceCategoryGuid=A.CategoryGuid
WHERE A.FiscalYear = @OldFiscalYear
  AND FAC.FiscalYear = @FiscalYear
  AND A.Deleted = 0
  AND FAC.Deleted = 0
  and fac.guid = '4b961a8d-c282-4428-8e70-51d419338b95'

INSERT INTO [Didgah_FinancialAccounting_Accrual_SpecializedTrainingCenter].[dbo].[fin_Accounts] 
([Comments] , [Active] , [Deleted] , [Code] , [FiscalYear] , [CurrencyBased] , [Level] , [SourceAccountId] , [DuplicationBatchGuid] , [Title] , [MaximumNature] , [CategoryID] , [Nature] , [SystemAccount] , [FinancialAccountSourceID] , [FinancialAccountBindingID] , [Guid] , [CategoryGuid] , [SendReceiveNature] , [SendReceiveRow] , [PaymentNature] , [PaymentRow] , [Permanent] , [UseInDraft] , [DraftType] , [UseInCostVoucher] , [CostType] , [BalanceSheetNature] , [SubtractFundingNature] , [SeparateSubtractFundingColumn] , [ProfitAndLossNature] , [SourceAccountGuid] , [BudgetActive] , [BudgetExpenseVoucherID] , [BudgetType] , [ExternalEntityGuid] , [IsFixedRate] , [FixedRate] , [FiscalYearDetailGuid])
SELECT *
FROM #Accounts 

/*******************************************************************************************/
INSERT INTO [Didgah_FinancialAccounting_Accrual_SpecializedTrainingCenter].[dbo].[fin_AccountBankAccounts] ([AccountId] , [BankAccountId] , [AccountGuid] , [BankAccountGuid])
SELECT ABA.[AccountId] ,
       ABA.[BankAccountId] ,
       A.[Guid] ,
       [BankAccountGuid]
FROM [Didgah_FinancialAccounting_Accrual_SpecializedTrainingCenter].[dbo].[fin_AccountBankAccounts] ABA
JOIN #Accounts A ON A.[SourceAccountGuid]=ABA.[AccountGuid]


DROP TABLE #Accounts

