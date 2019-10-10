FROM bitnami/mariadb:10.1

COPY mariadb_custom.conf /opt/bitnami/mariadb/conf/bitnami/my_custom.cnf
