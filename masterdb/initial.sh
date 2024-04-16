#!/bin/bash

# .env file variables sourced into script
source ../.env

# Edit the MariaDB configuration file to include the server ID and enable binary logging
echo "[mysqld]" >> /etc/mysql/my.cnf
echo "server-id=1" >> /etc/mysql/my.cnf
echo "log-bin" >> /etc/mysql/my.cnf
echo "binlog-format=row" >> /etc/mysql/my.cnf

# Restart the MariaDB service to apply the configuration changes
service mysql restart

# Log in to the MariaDB server as the root user
mysql -u root -p

# Create a replication user with the necessary permissions
mysql> CREATE USER '$REPLICATION_USER_NAME'@'%' IDENTIFIED BY '$REPLICATION_USER_PASSWORD';
mysql> GRANT REPLICATION SLAVE ON *.* TO '$REPLICATION_USER_NAME'@'%';
mysql> FLUSH PRIVILEGES;
mysql> EXIT;
