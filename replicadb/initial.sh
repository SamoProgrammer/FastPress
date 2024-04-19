#!/bin/bash

# .env file variables sourced into script
# source .env

# Connect slave to master.
result=$(docker exec mariadb_master mariadb -u root --password=$MASTER_ROOT_PASSWORD --execute="show master status;")

echo $result

log=$(echo $result | awk '{print $5}')
position=$(echo $result | awk '{print $6}')

docker exec mariadb_replica \
    mariadb -u root --password=$REPLICA_ROOT_PASSWORD \
    --execute="stop slave;\
   reset slave;\
   CHANGE MASTER TO MASTER_HOST='$MASTER_DB_HOST', MASTER_USER='$REPLICATION_USER_NAME', \
   MASTER_PASSWORD='$REPLICATION_USER_PASSWORD', MASTER_LOG_FILE='$log', MASTER_PORT=3306,
   MASTER_CONNECT_RETRY=10 , MASTER_LOG_POS=$position;\
   start slave;\
   create user '$SHARED_USER_NAME'@'%' identified by '$SHARED_USER_PASSWORD';\
   grant all privileges on *.* to '$SHARED_USER_NAME'@'%';\
   SHOW SLAVE STATUS\G;"
