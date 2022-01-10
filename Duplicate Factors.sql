
;with a as 
(
select 
code,
title,
factortypeguid,
count(code) as factorCount
from bdg_factors
where isnull(deleted,0) = 0 --and FactorLevel = 3
group by 
code,
title,
parentguid,
factortypeguid
having count(code)>1
)
,duplicatedFactor as 
(
select f.* 
from a a join 
bdg_factors f on a.Code = f.Code and a.Title = f.Title and a.FactorTypeGuid = f.FactorTypeGuid
--order by f.code
)
select --*
--distinct dp.Guid 
 HierarchyID.ToString(),*

from
duplicatedFactor dp
where HierarchyID   in (select FactorHierarchyID from bdg_ActionDetailFactors)


