# Substitution des variables d'environnement dans les livrables pré-livrables
FROM supinf/envsubst as subst
ARG PROXY_APP_SCHEME="https"
ARG PROXY_APP_HOST="localhost"
ARG PROXY_APP_PORT="443"
COPY ./pre_build/ /opt/pre_build/
WORKDIR /opt/
RUN export PROXY_CALC_HOST_PORT=$(if [[ $PROXY_APP_PORT == 443 && $PROXY_APP_SCHEME == "https" || $PROXY_APP_PORT == 80 && $PROXY_APP_SCHEME == "http" ]]; then echo "$PROXY_APP_HOST"; else echo "$PROXY_APP_HOST:$PROXY_APP_PORT"; fi); \
    for substFile in $(find . -name '*.subst'); do cat $substFile | envsubst >${substFile%.*}; done;

#Exécution des tâches ant de création du livrable
#Séparation des apps *.war des metatadata saml et des jks
FROM frekele/ant:1.10.1-jdk8 as antbuild
COPY --from=subst /opt/pre_build/ /opt/pre_build
WORKDIR /opt/
RUN for antfile in $(find . -name 'dynamique*.xml'); do ant -buildfile ${antfile}; done; \
    mkdir -p /opt/build/saml; \
    mkdir -p /opt/build/webapps; \
    cp -f /opt/*/*/nouveauLivrable/*.war /opt/build/webapps/; \
    cp -f /opt/*/*/*_metadata.xml /opt/build/saml/; \
    cp -f /opt/*/*/*.jks /opt/build/saml/;

#    mkdir -p /usr/share/ssl/saml; \

#Création du serveur tomcat avec copy des fichiers générés
FROM tomcat:6.0.48
COPY --from=antbuild /opt/build/webapps/ /usr/local/tomcat/webapps/
COPY --from=antbuild /opt/build/saml/ /usr/local/tomcat/saml/
COPY scripts/*.sh /opt/appsrv/bin/
CMD [ "/opt/appsrv/bin/wrapper.sh", "run" ]

#Exemple: 
#   docker build -t envsubst .
#   docker run -ti --entrypoint /bin/bash envsubst

