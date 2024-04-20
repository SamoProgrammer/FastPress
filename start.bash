source .env

source ./proxysql/initial.sh

sleep 2s

docker compose up -d

sleep 6s

source ./masterdb/initial.sh

sleep 1s

source ./replicadb/initial.sh
