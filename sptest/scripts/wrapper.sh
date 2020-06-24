#!/bin/bash

#Copie des metadata dans le volume paratagé avec les autres conteneurs
cp -f /etc/shibboleth/sptest_metadata.xml /usr/share/etc/ssl/saml/

#Démarrage du service tomcat
httpd-shibd-foreground
