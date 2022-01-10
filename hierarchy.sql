

select 
'00000000-0000-0000-0000-000000000000'
+ISNULL('.'+CONVERT(nvarchar(36),p2.guid),'')
+ISNULL('.'+CONVERT(nvarchar(36),p1.guid),'')
+ISNULL('.'+CONVERT(nvarchar(36),p.guid),'') as hierarchy ,
 isnull('/'+convert(nvarchar(10),p2.id),'')
+isnull('/'+convert(nvarchar(10),p1.id),'')
+isnull('/'+convert(nvarchar(10),p.id),'') +'/' as hierarchyid
from Didgah_General..gen_plans p 
join Didgah_General..gen_plans p1 on p.parentguid = p1.guid 
join Didgah_General..gen_plans p2 on p1.ParentGuid = p2.guid 
where p.guid in (select guid from backups..PlansImport11 where level = 3 )


UPDATE       p
SET             Hierarchy = '00000000-0000-0000-0000-000000000000'
+ISNULL('.'+CONVERT(nvarchar(36),p2.guid),'')
+ISNULL('.'+CONVERT(nvarchar(36),p1.guid),'')
+ISNULL('.'+CONVERT(nvarchar(36),p.guid),'')
               ,HierarchyID =    isnull('/'+convert(nvarchar(10),p2.id),'')
+isnull('/'+convert(nvarchar(10),p1.id),'')
+isnull('/'+convert(nvarchar(10),p.id),'') +'/'
FROM            gen_Plans AS p INNER JOIN
                         gen_Plans AS p1 ON p.ParentGuid = p1.GUID INNER JOIN
                         gen_Plans AS p2 ON p1.ParentGuid = p2.GUID
where p.guid in (select guid from backups..PlansImport11 where level = 3 )
---------------------------------------------------------------------------------------------
select 
'00000000-0000-0000-0000-000000000000'
+ISNULL('.'+CONVERT(nvarchar(36),p3.guid),'')
+ISNULL('.'+CONVERT(nvarchar(36),p2.guid),'')
+ISNULL('.'+CONVERT(nvarchar(36),p1.guid),'') 
+ISNULL('.'+CONVERT(nvarchar(36),p.guid),'') as hierarchy ,
isnull('/'+convert(nvarchar(10),p3.id),'')
+isnull('/'+convert(nvarchar(10),p2.id),'')
+isnull('/'+convert(nvarchar(10),p1.id),'')
+isnull('/'+convert(nvarchar(10),p.id),'') +'/' as hierarchyid
from Didgah_General..gen_plans p 
join Didgah_General..gen_plans p1 on p.parentguid = p1.guid 
join Didgah_General..gen_plans p2 on p1.ParentGuid = p2.guid 
join Didgah_General..gen_plans p3 on p2.ParentGuid = p3.guid 

UPDATE       p
SET          
Hierarchy = '00000000-0000-0000-0000-000000000000'
+ISNULL('.'+CONVERT(nvarchar(36),p3.guid),'')
+ISNULL('.'+CONVERT(nvarchar(36),p2.guid),'')
+ISNULL('.'+CONVERT(nvarchar(36),p1.guid),'') 
+ISNULL('.'+CONVERT(nvarchar(36),p.guid),'')
,HierarchyID=  isnull('/'+convert(nvarchar(10),p3.id),'')
+isnull('/'+convert(nvarchar(10),p2.id),'')
+isnull('/'+convert(nvarchar(10),p1.id),'')
+isnull('/'+convert(nvarchar(10),p.id),'') +'/'    
FROM            gen_Plans AS p INNER JOIN
                         gen_Plans AS p1 ON p.ParentGuid = p1.GUID INNER JOIN
                         gen_Plans AS p2 ON p1.ParentGuid = p2.GUID INNER JOIN
                         gen_Plans AS p3 ON p2.ParentGuid = p3.GUID
where p.guid in (select guid from backups..PlansImport11 where level = 4 )
--------------------------------------------------------------------------------------
select 
'00000000-0000-0000-0000-000000000000'
+ISNULL('.'+CONVERT(nvarchar(36),p4.guid),'')
+ISNULL('.'+CONVERT(nvarchar(36),p3.guid),'')
+ISNULL('.'+CONVERT(nvarchar(36),p2.guid),'')
+ISNULL('.'+CONVERT(nvarchar(36),p1.guid),'') 
+ISNULL('.'+CONVERT(nvarchar(36),p.guid),'') as hierarchy ,
isnull('/'+convert(nvarchar(10),p4.id),'')
+isnull('/'+convert(nvarchar(10),p3.id),'')
+isnull('/'+convert(nvarchar(10),p2.id),'')
+isnull('/'+convert(nvarchar(10),p1.id),'')
+isnull('/'+convert(nvarchar(10),p.id),'') +'/' as hierarchyid
from Didgah_General..gen_plans p 
join Didgah_General..gen_plans p1 on p.parentguid = p1.guid 
join Didgah_General..gen_plans p2 on p1.ParentGuid = p2.guid 
join Didgah_General..gen_plans p3 on p2.ParentGuid = p3.guid 
join Didgah_General..gen_plans p4 on p3.ParentGuid = p4.guid 
where p.guid in (select guid from backups..PlansImport11 where level = 5 )

UPDATE       p
SET               Hierarchy = '00000000-0000-0000-0000-000000000000'
+ISNULL('.'+CONVERT(nvarchar(36),p4.guid),'')
+ISNULL('.'+CONVERT(nvarchar(36),p3.guid),'')
+ISNULL('.'+CONVERT(nvarchar(36),p2.guid),'')
+ISNULL('.'+CONVERT(nvarchar(36),p1.guid),'') 
+ISNULL('.'+CONVERT(nvarchar(36),p.guid),'')
               ,HierarchyID =  isnull('/'+convert(nvarchar(10),p4.id),'')
+isnull('/'+convert(nvarchar(10),p3.id),'')
+isnull('/'+convert(nvarchar(10),p2.id),'')
+isnull('/'+convert(nvarchar(10),p1.id),'')
+isnull('/'+convert(nvarchar(10),p.id),'') +'/'
FROM            gen_Plans AS p INNER JOIN
                         gen_Plans AS p1 ON p.ParentGuid = p1.GUID INNER JOIN
                         gen_Plans AS p2 ON p1.ParentGuid = p2.GUID INNER JOIN
                         gen_Plans AS p3 ON p2.ParentGuid = p3.GUID INNER JOIN
                         gen_Plans AS p4 ON p3.ParentGuid = p4.GUID
where p.guid in (select guid from backups..PlansImport11 where level = 5 )