SELECT ROW_NUMBER() OVER (ORDER BY parentguid) AS RowNumber
,IDENTITY(int, 1120,1) AS ID  
,*
into zimport3
FROM zimport2

UPDATE backups..factorinsert
SET code = x.newrownumber
FROM (
      SELECT code,guid, case len(ROW_NUMBER() OVER (ORDER BY code)) 
	  when 1 then '000'+convert (varchar(3),ROW_NUMBER() OVER (ORDER BY code))
	  when 2 then '00'+convert (varchar(3),ROW_NUMBER() OVER (ORDER BY code))
	  when 3 then '0'+convert (varchar(3),ROW_NUMBER() OVER (ORDER BY code))
	  else convert (varchar(3),ROW_NUMBER() OVER (ORDER BY code))
	  
	  end AS newrownumber
      FROM backups..factorinsert
      ) x where backups..factorinsert.guid = x.guid 
-------------------------------------------------------------------------
UPDATE fin_vouchers
SET [index] = x.newrownumber
FROM (
      SELECT guid, ROW_NUMBER() OVER (ORDER BY date) 
	   AS newrownumber
      FROM fin_vouchers where fiscalyear = 1399
      ) x where fin_vouchers.guid = x.guid 
	  and fiscalyear = 1399
--------------------------------------------------------------------------
use Demo_Didgah_Budgets
UPDATE bdg_factors
SET code = x.newrownumber
FROM (
       SELECT guid, case len(ROW_NUMBER() OVER (ORDER BY code)) 
	  when 1 then '00'+convert (varchar(3),ROW_NUMBER() OVER (ORDER BY code))
	  when 2 then '0'+convert (varchar(3),ROW_NUMBER() OVER (ORDER BY code))
	  else convert (varchar(3),ROW_NUMBER() OVER (ORDER BY code))
	  	  end AS newrownumber
      FROM bdg_factors where factortypeguid in (select guid from bdg_factortypes where [index] = 33)
      ) x where bdg_factors.guid = x.guid 