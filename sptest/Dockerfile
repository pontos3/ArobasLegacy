# Substitution des variables d'environnement dans les livrables pré-livrables
FROM supinf/envsubst as subst
ARG SERVERNAME="arobas"
ARG SCOPE="localhost"
ARG PROXYPORT="443"
ARG SPTEST_HOST="localhost"
ARG SPTEST_SECURE_PORT="445"
COPY ./pre_build/ /opt/pre_build/
WORKDIR /opt/
RUN export SCOPERESULT=$(if [ $PROXYPORT = 443 ]; then echo "$SCOPE"; else echo "$SCOPE:$PROXYPORT"; fi;); \
    export SPTEST_CALC_HOST_PORT=$(if [[ $SPTEST_SECURE_PORT == 443 ]]; then echo "$SPTEST_HOST"; else echo "$SPTEST_HOST:$SPTEST_SECURE_PORT"; fi); \
    for substFile in $(find . -name '*.subst'); do cat $substFile | envsubst >${substFile%.*}; done;

FROM unicon/shibboleth-sp:3.0.4

#COPY --from=arobas_env_authsrv:latest /opt/shibboleth-idp/metadata/idp-metadata.xml /etc/shibboleth/idp-metadata.xml

WORKDIR /etc/shibboleth/
COPY --from=subst /opt/pre_build/sp_shibboleth/ /etc/shibboleth/
COPY --from=subst /opt/pre_build/appfiles/ /var/www/html/
COPY scripts/*.sh /opt/sptest/bin/
RUN mkdir -p /usr/share/etc/ssl/saml/
CMD [ "/opt/sptest/bin/wrapper.sh" ]
# RUN SCOPERESULT=$(if [ $PROXYPORT = 443 ]; then echo "$SCOPE"; else echo "$SCOPE:$PROXYPORT"; fi;) \
#     && sed -i '/<ApplicationDefaults entityID=/c\<ApplicationDefaults entityID="https:\/\/localhost:'$SPTEST_PORT'\/Shibboleth.SSO"' shibboleth2.xml \
#     && sed -i '/checkAddress="false"/c\checkAddress="false" handlerSSL="true" cookieProps="https" handlerURL="/Shibboleth.sso">' shibboleth2.xml \
#     && sed -i '/Example of locally maintained metadata/c\<MetadataProvider type="XML" validate="false" path="/etc/shibboleth/metadata/idp-metadata.xml"\/>' shibboleth2.xml \
#     && sed -i '/<SSO entityID=/c\\t<SSO entityID="https://'$SERVERNAME'.'$SCOPERESULT'/idp"' shibboleth2.xml