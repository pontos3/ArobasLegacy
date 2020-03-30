FROM mcr.microsoft.com/mssql/server:2017-latest

VOLUME /var/opt/mssql/restore

COPY ./scripts/bash/*.sh /opt/scripts/bash/
RUN chmod 0744 /opt/scripts/bash/*.sh

# Run the command on container startup
CMD /opt/scripts/bash/wrapper.sh


