
SELECT TABLE_NAME, TABLE_SCHEMA 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME like '%costcen%'


exec sp_msforeachdb 'select ''?'',table_name from ?.information_schema.tables 
where table_name like''%costcen%''';


exec sp_MSforeachdb 'SELECT "?" AS DB, * FROM [?].sys.tables 
where name like''%costcen%''';

---All Objects(Views,...)
select * from information_schema.tables 
---Only Tables
select * from sys.tables 