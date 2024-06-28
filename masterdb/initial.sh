#!/bin/bash

# Create slave user and grant access on master database.
sudo docker exec mariadb_master \
    mariadb -u root --password="$MASTER_ROOT_PASSWORD" \
    --execute="create user if not exists '$REPLICATION_USER_NAME'@'%' identified by '$REPLICATION_USER_PASSWORD';\
   grant replication slave on *.* to '$REPLICATION_USER_NAME'@'%';\
   flush privileges;"

# Creating database
sudo docker exec mariadb_master mariadb -u root --password="$MASTER_ROOT_PASSWORD" --execute="CREATE DATABASE IF NOT EXISTS $MASTER_DATABASE;"


sleep 3
# Creating shared user between databases
sudo docker exec mariadb_master mariadb -u root --password="$MASTER_ROOT_PASSWORD" --execute="CREATE USER IF NOT EXISTS '$SHARED_USER_NAME'@'%' IDENTIFIED BY '$SHARED_USER_PASSWORD';"
sleep 4
sudo docker exec mariadb_master mariadb -u root --password="$MASTER_ROOT_PASSWORD" --execute="GRANT ALL PRIVILEGES ON $MASTER_DATABASE.* TO '$SHARED_USER_NAME'@'%';"

sudo docker exec mariadb_master mariadb -u root --password="$MASTER_ROOT_PASSWORD" --execute="CREATE USER IF NOT EXISTS '$MONITOR_USER_NAME'@'%' IDENTIFIED BY '$MONITOR_USER_PASSWORD';"
sleep 4
sudo docker exec mariadb_master mariadb -u root --password="$MASTER_ROOT_PASSWORD" --execute="GRANT ALL PRIVILEGES ON $MASTER_DATABASE.* TO '$MONITOR_USER_NAME'@'%';"