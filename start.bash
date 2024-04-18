source .env

docker compose up -d

sleep 10s

./masterdb/initial.sh

sleep 1s

./replicadb/initial.sh
