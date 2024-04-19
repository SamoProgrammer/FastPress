#!/bin/bash

# .env file variables sourced into script
# source .env

echo "root password is : $MASTER_ROOT_PASSWORD"

# Create user on master database.
docker exec mariadb_master \
    mariadb -u root --password=$MASTER_ROOT_PASSWORD \
    --execute="create user '$REPLICATION_USER_NAME'@'%' identified by '$REPLICATION_USER_PASSWORD';\
   grant replication slave on *.* to '$REPLICATION_USER_NAME'@'%';\
   flush privileges;\
   create database '$MASTER_DATABASE';\
   create user '$SHARED_USER_NAME'@'%' identified by '$SHARED_USER_PASSWORD';\
   grant all privileges on '$MASTER_DATABASE'.* to '$SHARED_USER_NAME'@'%';\
   flush privileges;"
