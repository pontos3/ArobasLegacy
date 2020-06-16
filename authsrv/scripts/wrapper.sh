#!/bin/bash

#start tomcat
cd $CATALINA_HOME
/usr/local/tomcat/bin/catalina.sh run &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start tomcat: $status"
  exit $status
fi

# cron activate-metadata
while sleep 30; do
  /opt/shibboleth-idp/bin/activate-metadata-docker.sh
  status=$?
  if [ $status -ne 0 ]; then
    echo "Failed to activate metadata: $status"
    exit $status
  fi

done

exit 0;
