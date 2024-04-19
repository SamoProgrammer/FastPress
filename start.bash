source .env

docker compose up -d
sleep 6s
source ./masterdb/initial.sh
sleep 3s

source ./replicadb/initial.sh
sleep 2s
source ./proxysql/initial.sh

echo $MASTER_USER
echo $mariadb_master_host

