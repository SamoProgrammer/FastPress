#!/bin/bash

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
mysql>   MASTER_HOST='master_host_name',
mysql>   MASTER_USER='replication_user',
mysql>   MASTER_PASSWORD='your_password',
mysql>   MASTER_LOG_FILE='master_log_file',
mysql>   MASTER_LOG_POS=master_log_position;
mysql> START SLAVE;
mysql> EXIT;
