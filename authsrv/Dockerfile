FROM tomcat:9.0.35-jdk8-openjdk as authsrv
# zone : intranet | internet | rie | dev
ARG ZONE="dev"
ARG SERVERNAME="arobas"
ARG SCOPE="localhost"
ARG PROXYPORT="444"
ARG HOST_AROBASAPI="appsrv"
ARG PORT_AROBASAPI="8080"

ADD deliverable/idp-mae.tar.gz /tmp/
COPY scripts/*.sh /opt/shibboleth-idp/bin/
WORKDIR /tmp/idp-mae/bin
RUN SCOPERESULT=$(if [ $PROXYPORT = 443 ]; then echo "$SCOPE"; else echo "$SCOPE:$PROXYPORT"; fi;) \
    && sed -i '/<Connector port="8080"/c\<Connector port="8080" protocol="HTTP/1.1" secure="true" proxyName="'${SERVERNAME}'.'${SCOPE}'" proxyPort="'${PROXYPORT}'" scheme="https"' /usr/local/tomcat/conf/server.xml \
    && sed -i "/^idp.zone=.*$/c\idp.zone=${ZONE}" /tmp/idp-mae/conf/idp-mae.properties \
    && sed -i "/^idp.servername=.*$/c\idp.servername=${SERVERNAME}" /tmp/idp-mae/conf/idp-mae.properties \
    && sed -i "/^idp.scope=.*$/c\idp.scope=${SCOPERESULT}" /tmp/idp-mae/conf/idp-mae.properties \
    && sed -i "/^idp.log_dir=.*$/c\idp.log_dir=${CATALINA_HOME}/logs" /tmp/idp-mae/conf/idp-mae.properties \    
    && sed -i "/^idp.tomcat_inst=.*$/c\idp.tomcat_inst=tomcat" /tmp/idp-mae/conf/idp-mae.properties \    
    && sed -i "/^idp.tomcat_dir=.*$/c\idp.tomcat_dir=${CATALINA_HOME}" /tmp/idp-mae/conf/idp-mae.properties \
    && sed -i "/^idp.tomcat_conf_dir=.*$/c\idp.tomcat_conf_dir=${CATALINA_HOME}/conf" /tmp/idp-mae/conf/idp-mae.properties \    
    && sed -i "/^idp.tomcat_user=.*$/c\idp.tomcat_user=root" /tmp/idp-mae/conf/idp-mae.properties \        
    && sed -i "/^idp.java_home=.*$/c\idp.java_home=${JAVA_HOME}" /tmp/idp-mae/conf/idp-mae.properties \    
    && sed -i "/^arobas.server=.*$/c\arobas.server=${HOST_AROBASAPI}" /tmp/idp-mae/conf/idp-mae.properties \        
    && sed -i "/^arobas.port=.*$/c\arobas.port=${PORT_AROBASAPI}" /tmp/idp-mae/conf/idp-mae.properties \        
    && sed -i -e 's/systemctl/#systemctl/g' install-idp-mae.sh; mkdir -p /usr/local/tomcat/conf/Catalina/localhost/ \
    && ./install-idp-mae.sh \
    && mkdir /opt/shibboleth-idp/metadata_sp \
    && chmod 0744 /opt/shibboleth-idp/bin/wrapper.sh \
    && chmod 0744 /opt/shibboleth-idp/bin/activate-metadata-docker.sh \
    && chmod +r /opt/shibboleth-idp/credentials/idp-encryption.key /opt/shibboleth-idp/credentials/idp-signing.key


CMD [ "/opt/shibboleth-idp/bin/wrapper.sh", "run" ]