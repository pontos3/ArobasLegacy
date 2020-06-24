#!/bin/bash

#Copie des metadata dans le volume paratagé avec les autres conteneurs
cp -f /usr/local/tomcat/saml/*.* /usr/share/etc/ssl/saml/

#Démarrage du service tomcat
cd $CATALINA_HOME
catalina.sh run
