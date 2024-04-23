#!/bin/bash

# Connect slave to master.

mariadb -u root --password=$REPLICA_ROOT_PASSWORD \
    --execute="stop slave;\
   reset slave;\
   CHANGE MASTER TO MASTER_HOST='$MASTER_DB_HOST', MASTER_USER='$REPLICATION_USER_NAME', \
   MASTER_PASSWORD='$REPLICATION_USER_PASSWORD', MASTER_PORT=3306,
   MASTER_CONNECT_RETRY=10;\
   start slave;"

# Creating shared user between databases
mariadb -u root --password=$REPLICA_ROOT_PASSWORD --execute="CREATE USER IF NOT EXISTS '$SHARED_USER_NAME'@'%' IDENTIFIED BY '$SHARED_USER_PASSWORD';"

mariadb -u root --password=$REPLICA_ROOT_PASSWORD --execute="GRANT ALL PRIVILEGES ON *.* TO '$SHARED_USER_NAME'@'localhost';"

mariadb -u root --password=$REPLICA_ROOT_PASSWORD --execute="GRANT ALL PRIVILEGES ON *.* TO '$SHARED_USER_NAME'@'%';"


# Creating monitor user
mariadb -u root --password=$MASTER_ROOT_PASSWORD --execute="CREATE USER IF NOT EXISTS '$MONITOR_USER_NAME'@'%' IDENTIFIED BY '$MONITOR_USER_PASSWORD';"

mariadb -u root --password=$MASTER_ROOT_PASSWORD --execute="GRANT ALL PRIVILEGES ON *.* TO '$MONITOR_USER_NAME'@'localhost';"

mariadb -u root --password=$MASTER_ROOT_PASSWORD --execute="GRANT ALL PRIVILEGES ON *.* TO '$MONITOR_USER_NAME'@'%';"