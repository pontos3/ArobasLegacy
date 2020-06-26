#!/bin/bash

#start tomcat
cd $CATALINA_HOME
/usr/local/tomcat/bin/catalina.sh run &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start tomcat: $status"
  exit $status
fi

cp -f /opt/shibboleth-idp/metadata/idp-metadata.xml /opt/shibboleth-idp/shared-metadata/idp-metadata.xml
cp -f /opt/shibboleth-idp/metadata/idp-metadata.xml /opt/shibboleth-idp/export_metadata/idp-metadata.xml

# cron activate-metadata
while sleep 30; do
  cp -f /opt/shibboleth-idp/export_metadata/*.xml /opt/shibboleth-idp/metadata_sp/.;
  
  /opt/shibboleth-idp/bin/activate-metadata-docker.sh
  status=$?
  if [ $status -ne 0 ]; then
    echo "Failed to activate metadata: $status"
    exit $status
  fi

done

exit 0;
