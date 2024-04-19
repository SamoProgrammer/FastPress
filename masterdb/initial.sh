#!/bin/bash

# .env file variables sourced into script
# source .env

echo "root password is : $MASTER_ROOT_PASSWORD"

# Create user on master database.
docker exec mariadb_master \
    mariadb -u root --password=$MASTER_ROOT_PASSWORD \
    --execute="create user '$REPLICATION_USER_NAME'@'%' identified by '$REPLICATION_USER_PASSWORD';\
   grant replication slave on *.* to '$REPLICATION_USER_NAME'@'%';\
   flush privileges;"

docker exec mariadb_master mariadb -u root -p "$MASTER_ROOT_PASSWORD" -e "CREATE DATABASE '$MASTER_DATABASE';"

docker exec mariadb_master mariadb -u root -p "$MASTER_ROOT_PASSWORD" -e "CREATE USER '$SHARED_USER_NAME'@'%' IDENTIFIED BY '$SHARED_USER_PASSWORD';"

docker exec mariadb_master mariadb -u root -p "$MASTER_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON *.* TO '$SHARED_USER_NAME'@'localhost';"

docker exec mariadb_master mariadb -u root -p "$MASTER_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON *.* TO '$SHARED_USER_NAME'@'%';"
