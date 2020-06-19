FROM unicon/shibboleth-sp:3.0.4

ARG SERVERNAME="arobas"
ARG SCOPE="localhost"
ARG PROXYPORT="443"
ARG SPTEST_PORT="445"

#COPY --from=arobas_env_authsrv:latest /opt/shibboleth-idp/metadata/idp-metadata.xml /etc/shibboleth/idp-metadata.xml

WORKDIR /etc/shibboleth/
RUN SCOPERESULT=$(if [ $PROXYPORT = 443 ]; then echo "$SCOPE"; else echo "$SCOPE:$PROXYPORT"; fi;) \
    && sed -i '/<ApplicationDefaults entityID=/c\<ApplicationDefaults entityID="https:\/\/localhost:'$SPTEST_PORT'\/Shibboleth.SSO"' shibboleth2.xml \
    && sed -i '/checkAddress="false"/c\checkAddress="false" handlerSSL="true" cookieProps="https" handlerURL="/Shibboleth.sso">' shibboleth2.xml \
    && sed -i '/Example of locally maintained metadata/c\<MetadataProvider type="XML" validate="false" path="/etc/shibboleth/metadata/idp-metadata.xml"\/>' shibboleth2.xml \
    && sed -i '/<SSO entityID=/c\\t<SSO entityID="https://'$SERVERNAME'.'$SCOPERESULT'/idp"' shibboleth2.xml