#!/bin/bash

# .env file variables sourced into script
# source ../.env

# Connect slave to master.
result=$(docker exec $MYSQL_MASTER_DATABASE mysql -u root --password=$MYSQL_MASTER_ROOT_PASSWORD --execute="show master status;")
log=$(echo $result | awk '{print $5}')
position=$(echo $result | awk '{print $6}')

docker exec $MYSQL_REPLICA_DATABASE \
    mysql -u root --password=$MYSQL_REPLICA_ROOT_PASSWORD \
    --execute="stop slave;\
   reset slave;\
   CHANGE MASTER TO MASTER_HOST='$MYSQL_REPLICA_DATABAS', MASTER_USER='$REPLICATION_USER_NAME', \
   MASTER_PASSWORD='$REPLICATION_USER_PASSWORD', MASTER_LOG_FILE='$log', MASTER_LOG_POS=$position;\
   start slave;\
   SHOW SLAVE STATUS\G;"
