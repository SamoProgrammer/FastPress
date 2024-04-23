#!/bin/bash

# Create slave user and grant access on master database.

mariadb -u root --password=$MASTER_ROOT_PASSWORD \
    --execute="create user if not exists '$REPLICATION_USER_NAME'@'%' identified by '$REPLICATION_USER_PASSWORD';\
   grant replication slave on *.* to '$REPLICATION_USER_NAME'@'%';\
   flush privileges;"

# Creating database
mariadb -u root --password=$MASTER_ROOT_PASSWORD --execute="CREATE DATABASE IF NOT EXISTS $MASTER_DATABASE;"

# Creating shared user between databases
mariadb -u root --password=$MASTER_ROOT_PASSWORD --execute="CREATE USER IF NOT EXISTS '$SHARED_USER_NAME'@'%' IDENTIFIED BY '$SHARED_USER_PASSWORD';"

mariadb -u root --password=$MASTER_ROOT_PASSWORD --execute="GRANT ALL PRIVILEGES ON *.* TO '$SHARED_USER_NAME'@'localhost';"

mariadb -u root --password=$MASTER_ROOT_PASSWORD --execute="GRANT ALL PRIVILEGES ON *.* TO '$SHARED_USER_NAME'@'%';"


# Creating monitor user
mariadb -u root --password=$MASTER_ROOT_PASSWORD --execute="CREATE USER IF NOT EXISTS '$MONITOR_USER_NAME'@'%' IDENTIFIED BY '$MONITOR_USER_PASSWORD';"

mariadb -u root --password=$MASTER_ROOT_PASSWORD --execute="GRANT ALL PRIVILEGES ON *.* TO '$MONITOR_USER_NAME'@'localhost';"

mariadb -u root --password=$MASTER_ROOT_PASSWORD --execute="GRANT ALL PRIVILEGES ON *.* TO '$MONITOR_USER_NAME'@'%';"