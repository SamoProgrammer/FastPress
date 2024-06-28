#!/usr/bin/env bash
source .env

source ./proxysql/initial.sh

sleep 2s

docker compose up -d

sleep 15s

source ./masterdb/initial.sh

sleep 7s

source ./replicadb/initial.sh
