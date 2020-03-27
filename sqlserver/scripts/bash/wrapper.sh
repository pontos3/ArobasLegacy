#!/bin/bash

#start sqlserver
/opt/mssql/bin/sqlservr &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start sqlserver: $status"
  exit $status
fi

# Restore database from /var/opt/mssql/restore/*.bak
while sleep 30; do
  /opt/scripts/bash/restoreDb.sh >> /var/log/restoreDb.log
  status=$?
  if [ $status -ne 0 ]; then
    echo "Failed to start sqlserver: $status"
    exit $status
  fi
done

exit 0;
