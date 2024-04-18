source .env

docker compose up -d

sleep 10s

sudo bash masterdb/initial.sh

sleep 1s

sudo bash replicadb/initial.sh
