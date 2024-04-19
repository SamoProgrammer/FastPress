#!/bin/bash
# source .env

# Read environment variables
# admin_credentials="admin:$PROXYSQL_ADMIN_PASSWORD"
mariadb_master_host="$MASTER_DB_HOST"
mariadb_replica_host="$REPLICA_DB_HOST"
master_db_user="$MASTER_USER"
master_db_password="$MASTER_PASSWORD"

# Generate proxysql.cnf content
# cat <<EOF >./proxysql/proxysql.cnf
# # ProxySQL Admin Variables
# admin_variables=
# {
#     admin_credentials="$admin_credentials"
#     mysql_ifaces="0.0.0.0:6032"
#     refresh_interval=2000
# }

# # MySQL Servers
# mysql_servers =
# (
#     { address="$mariadb_master_host", port=3306, hostgroup=0 },
#     { address="$mariadb_replica_host", port=3306, hostgroup=1 }
# )

# # MySQL Users
# mysql_users =
# (
#     { username = "$master_db_user", password = "$master_db_password", default_hostgroup = 0, active = 1 },
#     { username = "$master_db_user", password = "$master_db_password", default_hostgroup = 1, active = 1 }
# )

# # MySQL Query Rules
# mysql_query_rules =
# (
#     { rule_id=1, active=1, match_pattern="^SELECT.*", destination_hostgroup=2 },
#     { rule_id=2, active=1, match_pattern="^UPDATE.*|^INSERT.*|DELETE.*", destination_hostgroup=1 }
# )
# EOF

docker exec proxysql mysql -u admin -padmin -h 127.0.0.1 -P6032 <<EOF
INSERT INTO mysql_servers(hostgroup_id,hostname,port) VALUES (0,'$mariadb_master_host',3306);
INSERT INTO mysql_servers(hostgroup_id,hostname,port) VALUES (1,'$mariadb_replica_host',3306);
INSERT INTO mysql_replication_hostgroups VALUES (0,1,'production');
LOAD MYSQL SERVERS TO RUNTIME;
SAVE MYSQL SERVERS TO DISK;
UPDATE global_variables SET variable_value='monitor' WHERE variable_name='mysql-monitor_password';
LOAD MYSQL VARIABLES TO RUNTIME;
SAVE MYSQL VARIABLES TO DISK;
INSERT INTO mysql_users(username,password,default_hostgroup) VALUES ($master_db_user,$master_db_password,0);
INSERT INTO mysql_users(username,password,default_hostgroup) VALUES ($master_db_user,$master_db_password,1);
UPDATE global_variables SET variable_value=2000 WHERE variable_name IN ('mysql-monitor_connect_interval','mysql-monitor_ping_interval','mysql-monitor_read_only_interval');
UPDATE global_variables SET variable_value = 1000 where variable_name = 'mysql-monitor_connect_timeout';
UPDATE global_variables SET variable_value = 500 where variable_name = 'mysql-monitor_ping_timeout';
LOAD MYSQL VARIABLES TO RUNTIME;
SAVE MYSQL VARIABLES TO DISK;
UPDATE mysql_servers SET max_replication_lag=60;
INSERT INTO mysql_query_rules (rule_id, active, match_pattern, destination_hostgroup) VALUES (2, 1, "^UPDATE.*|^INSERT.*|DELETE.*", 0);
INSERT INTO mysql_query_rules (rule_id, active, match_pattern, destination_hostgroup) VALUES (1, 1,"^SELECT.*", 1);
LOAD MYSQL QUERY RULES TO RUNTIME;
SAVE MYSQL QUERY RULES TO DISK;
EOF
