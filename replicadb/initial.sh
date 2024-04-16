#!/bin/bash

# .env file variables sourced into script
source ../.env

# Edit the MariaDB configuration file to include the server ID and enable binary logging
echo "[mysqld]" >> /etc/mysql/my.cnf
echo "server-id=2" >> /etc/mysql/my.cnf
echo "log-bin" >> /etc/mysql/my.cnf
echo "binlog-format=row" >> /etc/mysql/my.cnf

# Restart the MariaDB service to apply the configuration changes
service mysql restart

# Log in to the MariaDB server as the root user
mysql -u root -p

# Configure the replica to connect to the master and start replicating data
mysql> CHANGE MASTER TO
mysql>   MASTER_HOST='$MYSQL_MASTER_DATABASE',
mysql>   MASTER_USER='$REPLICATION_USER_NAME',
mysql>   MASTER_PASSWORD='$REPLICATION_USER_PASSWORD',
mysql>   MASTER_LOG_FILE='master_log_file',
mysql>   MASTER_LOG_POS=master_log_position;
mysql> START SLAVE;
mysql> EXIT;
