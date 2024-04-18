#!/bin/bash

# .env file variables sourced into script
# source ../.env

# Connect slave to master.
result=$(docker exec $MARIADB_MASTER_DATABASE mariadb -u root --password=$MARIADB_MASTER_ROOT_PASSWORD --execute="show master status;")
log=$(echo $result | awk '{print $5}')
position=$(echo $result | awk '{print $6}')

docker exec mariadb_replica \
    mariadb -u root --password=$MARIADB_REPLICA_ROOT_PASSWORD \
    --execute="stop slave;\
   reset slave;\
   CHANGE MASTER TO MASTER_HOST='$MARIADB_MASTER_DATABASE', MASTER_USER='$REPLICATION_USER_NAME', \
   MASTER_PASSWORD='$REPLICATION_USER_PASSWORD', MASTER_LOG_FILE='$log', MASTER_LOG_POS=$position;\
   start slave;\
   SHOW SLAVE STATUS\G;"
