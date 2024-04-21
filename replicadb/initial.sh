#!/bin/bash


result=$(docker exec mariadb_master mariadb -u root --password=$MASTER_ROOT_PASSWORD --execute="show master status;")

log=$(echo $result | awk '{print $5}')
position=$(echo $result | awk '{print $6}')

# Connect slave to master.
docker exec mariadb_replica \
    mariadb -u root --password=$REPLICA_ROOT_PASSWORD \
    --execute="stop slave;\
   reset slave;\
   CHANGE MASTER TO MASTER_HOST='$MASTER_DB_HOST', MASTER_USER='$REPLICATION_USER_NAME', \
   MASTER_PASSWORD='$REPLICATION_USER_PASSWORD', MASTER_LOG_FILE='$log', MASTER_PORT=3306,
   MASTER_CONNECT_RETRY=10 , MASTER_LOG_POS=$position;\
   start slave;"

# Creating shared user between databases
docker exec mariadb_replica mariadb -u root --password=$REPLICA_ROOT_PASSWORD --execute="CREATE USER IF NOT EXISTS '$SHARED_USER_NAME'@'%' IDENTIFIED BY $SHARED_USER_PASSWORD;"

docker exec mariadb_replica mariadb -u root --password=$REPLICA_ROOT_PASSWORD --execute="GRANT ALL PRIVILEGES ON *.* TO '$SHARED_USER_NAME'@'localhost';"

docker exec mariadb_replica mariadb -u root --password=$REPLICA_ROOT_PASSWORD --execute="GRANT ALL PRIVILEGES ON *.* TO '$SHARED_USER_NAME'@'%';"
