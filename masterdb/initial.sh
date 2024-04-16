#!/bin/bash

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
mysql> CREATE USER 'replication_user'@'%' IDENTIFIED BY 'your_password';
mysql> GRANT REPLICATION SLAVE ON *.* TO 'replication_user'@'%';
mysql> FLUSH PRIVILEGES;
mysql> EXIT;
