#!/bin/bash

# .env file variables sourced into script
# source .env

echo "root password is : $MASTER_ROOT_PASSWORD"

# Create user on master database.
docker exec mariadb_master \
    mariadb -u root --password=$MASTER_ROOT_PASSWORD \
    --execute="create user '$REPLICATION_USER_NAME'@'%' identified by '$REPLICATION_USER_PASSWORD';\
   grant replication slave on *.* to '$REPLICATION_USER_NAME'@'%';\
   CREATE DATABASE $MASTER_DATABASE;\
   flush privileges;"
