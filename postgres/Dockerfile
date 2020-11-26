FROM postgres:12.2

ENV POSTGRES_PASSWORD demo
COPY ./10-postgresql-init.sql /docker-entrypoint-initdb.d/10-postgresql-init.sql

