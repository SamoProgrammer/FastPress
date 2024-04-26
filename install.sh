#!/usr/bin/env bash
source .env

source ./proxysql/initial.sh

sleep 2s

docker compose up -d

sleep 6s

