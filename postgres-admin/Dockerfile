FROM dpage/pgadmin4:4.19

ENV PGADMIN_DEFAULT_EMAIL=admin
ENV PGADMIN_DEFAULT_PASSWORD demo

ADD servers.json /pgadmin4/servers.json

ADD pgpassfile /pgpassfile

# the password file must have 600 permission, otherwise it will be ignored!
USER root
RUN chmod 600 /pgpassfile

USER pgadmin

