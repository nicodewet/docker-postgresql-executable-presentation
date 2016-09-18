FROM postgres:9.5.4
ADD config.sh /docker-entrypoint-initdb.d/
