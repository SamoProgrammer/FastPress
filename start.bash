source .env

source ./proxysql/initial.sh

echo $MASTER_USER
echo $mariadb_master_host

docker compose up -d

sleep 6s

source ./masterdb/initial.sh

sleep 2s

source ./replicadb/initial.sh
