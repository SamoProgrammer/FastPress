#!/bin/bash

# .env file variables sourced into script
# source ../.env

# Connect slave to master.
result=$(docker exec mariadb_master mariadb -u root --password=$MYSQL_MASTER_ROOT_PASSWORD --execute="show master status;")
log=$(echo $result | awk '{print $5}')
position=$(echo $result | awk '{print $6}')

docker exec mariadb_replica \
    mariadb -u root --password=$MYSQL_REPLICA_ROOT_PASSWORD \
    --execute="stop slave;\
   reset slave;\
   CHANGE MASTER TO MASTER_HOST='$MASTER_DB_HOST', MASTER_USER='$REPLICATION_USER_NAME', \
   MASTER_PASSWORD='$REPLICATION_USER_PASSWORD', MASTER_LOG_FILE='$log', MASTER_PORT=3306,
   MASTER_CONNECT_RETRY=10 , MASTER_LOG_POS=$position;\
   start slave;\
   SHOW SLAVE STATUS\G;"
