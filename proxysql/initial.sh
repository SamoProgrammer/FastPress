#!/bin/bash
source .env

# Read environment variables
admin_credentials="admin:$PROXYSQL_ADMIN_PASSWORD"
mariadb_master_host="$MASTER_DB_HOST"
mariadb_replica_host="$REPLICA_DB_HOST"
master_db_user="$MASTER_USER"
master_db_password="$MASTER_PASSWORD"


# Generate proxysql.cnf content
cat <<EOF >proxysql.cnf
# ProxySQL Admin Variables
admin_variables=
{
    admin_credentials="$admin_credentials"
    mysql_ifaces="0.0.0.0:6032"
    refresh_interval=2000
}

# MySQL Servers
mysql_servers =
(
    { address="$mariadb_master_host", port=3306, hostgroup=1 },
    { address="$mariadb_replica_host", port=3306, hostgroup=2 }
)

# MySQL Users
mysql_users =
(
    { username = "$master_db_user", password = "$master_db_password", default_hostgroup = 1, active = 1 },
    { username = "$master_db_user", password = "$master_db_password", default_hostgroup = 2, active = 1 }
)

# MySQL Query Rules
mysql_query_rules =
(
    { rule_id=1, active=1, match_pattern="^SELECT.*", destination_hostgroup=2 },
    { rule_id=2, active=1, match_pattern="^UPDATE.*|^INSERT.*|DELETE.*", destination_hostgroup=1 }
)
EOF
