FROM tomcat:9.0.35-jdk8-openjdk

ADD deliverable/idp-mae-1.6.0.tar.gz /tmp/
COPY deliverable/conf/idp-mae.properties /tmp/idp-mae-1.6.0/conf/
WORKDIR /tmp/idp-mae-1.6.0/bin
RUN sed -i -e 's/systemctl/#systemctl/g' install-idp-mae.sh; mkdir -p /usr/local/tomcat/conf/Catalina/localhost/; ./install-idp-mae.sh

CMD [ "catalina.sh", "run" ]