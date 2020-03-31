#!/bin/bash
for f in /var/opt/mssql/restore/*.bak; do 
    if test -f "$f"; then
        f_name="$(basename $f .bak)";
        f_dbName="${f_name//-/''}"
        echo "Read $f file in $f_name database ...";

        # if exists, remove the database
        /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $SA_PASSWORD -Q ":on error exit
            IF DB_ID('$f_dbName') IS NOT NULL 
            BEGIN 
                USE master;
                alter database [$f_dbName] 
                set offline with rollback immediate;
                DROP DATABASE [$f_dbName];
            END";

        status=$?

        if [ $status -eq 0 ]; then
            echo "remove $f_dbName database files..."
            rm -rf /var/opt/mssql/data/$f_dbName.*;
        else
            >&2 echo "Drop $f_dbName database. Something is wrong!"
            exit $status;
        fi

        # Cronstruct sql string for restore action
        count=0; 
        restore=":on error exit 
        RESTORE DATABASE $f_dbName"
        restore="$restore FROM DISK = '/var/opt/mssql/restore/$f_name.bak' WITH"

        OLDIFS="$IFS"
        IFS=$'\n'

        for i in $(/opt/mssql-tools/bin/sqlcmd -h -1 -s '|' -W -S localhost -U SA -P $SA_PASSWORD -Q  ":on error exit 
        SET NOCOUNT ON; 
        RESTORE FILELISTONLY  
        FROM DISK = '/var/opt/mssql/restore/$f_name.bak'");  do 

            nextOLDIFS="$IFS"
            IFS="|" 
            while read logicalName physicalName otherBackupInfo;
            do

                extension=`expr match "$physicalName" '.*[.]\([a-z]*\)$'`

                if [ "$count" -gt "0" ]
                then
                    restore="$restore,";
                fi

                restore="$restore MOVE '$logicalName' TO '/var/opt/mssql/data/$f_dbName.$extension'"

                count=$(($count + 1));
                IFS="$nextOLDIFS"
            done < <(printf '%s\n' "$i")
        done

        IFS="$OLDIFS"
        echo $restore;

        #Execute string to restore database.
        /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $SA_PASSWORD -Q "$restore";

        status=$?;

        # Put the database online
        if [ $status -eq 0 ]; then
            /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P $SA_PASSWORD -Q ":on error exit
                IF DB_ID('$f_dbName') IS NOT NULL 
                BEGIN 
                    alter database [$f_dbName] 
                    set online;
                END";
                status=$?;
        else
            >&2 echo "Restore $f file in $f_dbName database. Something is wrong!"
            >&2 echo "inspect the restore sql string see below:";
            >&2 echo "$restore";
            exit $status;
        fi

        if [ $status -eq 0 ]; then
            echo "Read $f file in $f_dbName database is done!"
            mv "$f" "${f/.bak/.oldbak}";
            status=$?;
        else
            >&2 echo "Error on Set $f_dbName database online. Something is wrong!"
            exit $status;
        fi
    else
        echo "no file to restore"
    fi
done

exit $status