source .env

source ./proxysql/initial.sh

docker compose up -d

sleep 6s

source ./masterdb/initial.sh

sleep 2s

source ./replicadb/initial.sh
