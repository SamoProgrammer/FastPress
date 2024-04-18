#!/bin/bash

# .env file variables sourced into script
# source ../.env

echo $MYSQL_MASTER_ROOT_PASSWORD

# Create user on master database.
docker exec mariadb_master \
    mariadb -u root --password=$MYSQL_MASTER_ROOT_PASSWORD \
    --execute="create user '$REPLICATION_USER_NAME'@'%' identified by '$REPLICATION_USER_PASSWORD';\
   grant replication slave on *.* to '$REPLICATION_USER_NAME'@'%';\
   flush privileges;"
