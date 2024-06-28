#!/bin/bash

# Read environment variables
admin_credentials="admin:$PROXYSQL_ADMIN_PASSWORD"

# Generate proxysql.cnf content
cat <<EOF >./proxysql/proxysql.cnf
# This file will be auto generated by initial script of proxysql
datadir="/var/lib/proxysql"

# ProxySQL Admin Variables
admin_variables=
{
    admin_credentials="$admin_credentials"
    mysql_ifaces="0.0.0.0:6032"
}

mysql_variables=
{
    threads=4
    max_connections=2048
    default_query_delay=0
    default_query_timeout=36000000
    have_compress=true
    poll_timeout=2000
    interfaces="0.0.0.0:6033"
    default_schema="information_schema"
    stacksize=1048576
    server_version="5.5.30"
    connect_timeout_server=3000
    monitor_username="$MONITOR_USER_NAME"
    monitor_password="$MONITOR_USER_PASSWORD"
    monitor_history=600000
    monitor_connect_interval=60000
    monitor_ping_interval=10000
    monitor_read_only_interval=1500
    monitor_read_only_timeout=500
    ping_interval_server_msec=120000
    ping_timeout_server=500
    commands_stats=true
    sessions_sort=true
    connect_retries_on_failure=10
}

# MySQL Servers
mysql_servers =
(
    { address="$MASTER_DB_HOST", port=3306, hostgroup=0 },
    { address="$REPLICA_DB_HOST", port=3306, hostgroup=1 }
)

# MySQL Users
mysql_users =
(
    { username = "$SHARED_USER_NAME", password = "$SHARED_USER_PASSWORD", default_schema="cangrow_db", active = 1 }
)

# MySQL Query Rules
mysql_query_rules =
(
    { rule_id=1, active=1, match_pattern="^UPDATE.*|^INSERT.*|DELETE.*", destination_hostgroup=0,username = "samo_programmer" },
    { rule_id=2, active=1, match_pattern="^SELECT.*", destination_hostgroup=1,username = "samo_programmer" }
)
EOF