FROM mcr.microsoft.com/mssql/server:2017-latest

VOLUME /var/opt/mssql/restore

COPY ./scripts/bash/*.sh /opt/scripts/bash/
RUN chmod 0744 /opt/scripts/bash/*.sh

# Add crontab file in the cron directory
#ADD ./scripts/cron/crontab /etc/cron.d/hello-cron

# Give execution rights on the cron job
#RUN chmod 0744 /etc/cron.d/hello-cron

# Create the log file to be able to run tail
#RUN touch /var/log/cron.log

#Install Cron
# RUN apt-get update && apt-get install -y \
#      cron \
#   && rm -rf /var/lib/apt/lists/*

# Run the command on container startup
CMD /opt/scripts/bash/wrapper.sh


