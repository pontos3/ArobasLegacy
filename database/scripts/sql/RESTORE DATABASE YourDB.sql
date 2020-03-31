RESTORE DATABASE WideWorldImporters
FROM DISK = '/var/opt/mssql/backup/WideWorldImporters-Standard.bak'
WITH MOVE 'WWI_Primary' TO '/var/opt/mssql/data/WideWorldImporters.mdf',
MOVE 'WWI_UserData' TO '/var/opt/mssql/data/WideWorldImporters_userdata.ndf',
MOVE 'WWI_Log' TO '/var/opt/mssql/data/WideWorldImporters_Log.ldf'


RESTORE FILELISTONLY  
   FROM AdventureWorks2012_Backup; 

DROP DATABASE WideWorldImporters_Standard;
DROP DATABASE SalesDBOriginal;

RESTORE FILELISTONLY  
   FROM DISK = '/var/opt/mssql/restore/CreditBackup80.bak';

RESTORE HEADERONLY FROM DISK = '/var/opt/mssql/restore/CreditBackup80.bak';

RESTORE DATABASE CreditBackup80
FROM DISK = '/var/opt/mssql/restore/CreditBackup80.bak'
WITH MOVE 'CreditData' TO '/var/opt/mssql/data/CreditBackup80.mdf',
MOVE 'CreditLog' TO '/var/opt/mssql/data/CreditBackup80.ldf'

RESTORE DATABASE SalesDBOriginal
FROM DISK = '/var/opt/mssql/restore/SalesDBOriginal.oldbak'
WITH MOVE 'SalesDBData' TO '/var/opt/mssql/data/SalesDBOriginal.mdf',
MOVE 'SalesDBLog' TO '/var/opt/mssql/data/SalesDBOriginal_Log.ldf'

alter database [WideWorldImporters_Standard] 
  set online

IF DB_ID('WideWorldImporters_Standard') IS NOT NULL 
BEGIN 
    alter database [WideWorldImporters_Standard] 
    set offline with rollback immediate;

    select 1;
END

IF DB_ID('WideWorldImporters_Standard') IS NOT NULL 
BEGIN 

    alter database [WideWorldImporters_Standard] 
    set online;

    select 2;
END

