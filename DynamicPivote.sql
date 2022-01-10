drop table if exists FactStage1
select ad.guid as ActionDetailGuid,ad.id as ActionDetailID,f.ID as FactorID,ft.LatinTitle as factortypetitle,A.Code as ActionCode,A.IssueDate,A.FiscalYear,
AT.ID as ActionTypeID,isnull(pt.id,0) as PaymentTypeID,TotalAmount,ReturnAmount into #Temp
              from bdg_Actiondetails ad
               join  bdg_Actiondetailfactors adf on  ad.id = adf.ActionDetailID 
			   	INNER JOIN bdg_factors f
				on f.HierarchyID = adf.FactorHierarchyID
				inner join bdg_FactorTypes ft
				on ft.guid = adf.FactorTypeGuid
				inner join bdg_Actions A
				on A.guid = Ad.ActionGuid
				inner join bdg_actiontypes at 
				on at.guid = a.ActionTypeGuid
								left join bdg_paymenttypes pt 
				on pt.guid = ad.PaymentTypeGuid
			   where ad.deleted = 0 and f.deleted = 0 

DECLARE @DynamicPivotQuery AS NVARCHAR(MAX),
        @PivotColumnNames AS NVARCHAR(MAX),
        @PivotSelectColumnNames AS NVARCHAR(MAX)

SELECT @PivotColumnNames= ISNULL(@PivotColumnNames + ',','')+ QUOTENAME(factortypetitle) 
FROM (SELECT DISTINCT factortypetitle FROM #Temp where factortypetitle is not null) AS tmp
--Get distinct values of the PIVOT Column with isnull
SELECT @PivotSelectColumnNames = ISNULL(@PivotSelectColumnNames + ',','')+ 'ISNULL(' + QUOTENAME(factortypetitle) + ', 0) AS '+ QUOTENAME(factortypetitle)
FROM (SELECT DISTINCT factortypetitle FROM #Temp where factortypetitle is not null) AS tmp

SET @DynamicPivotQuery =
N'SELECT ActionDetailGuid,ActionDetailID,ActionCode,IssueDate,FiscalYear,ActionTypeID,PaymentTypeID,TotalAmount,ReturnAmount, ' + @PivotSelectColumnNames + '
into FactStage1 FROM #Temp
PIVOT(Max(FactorID)
FOR factortypetitle IN (' + @PivotColumnNames + ')) AS PVTTable'
--Execute the Dynamic Pivot Query
EXEC sp_executesql @DynamicPivotQuery
drop table #Temp
