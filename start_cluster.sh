#!/bin/bash
# Note: Execute this script on the MANAGER host with SSH connections to the other nodes
MANAGER0_IP=10.0.7.11
NODE0_IP=10.0.7.12
NODE1_IP=10.0.7.13

# Create manager and get the token
sudo docker swarm init --advertise-addr ${MANAGER0_IP} --listen-addr ${MANAGER0_IP}
SWARM_TOKEN=`sudo docker swarm join-token -q worker --quiet`

# Add the nodes to this manager
ssh vagrant@${NODE0_IP} "sudo docker swarm join --token ${SWARM_TOKEN} ${MANAGER0_IP}:2377"
ssh vagrant@${NODE1_IP} "sudo docker swarm join --token ${SWARM_TOKEN} ${MANAGER0_IP}:2377"

# Create a network for monitoring tools
sudo docker network create monitoring -d overlay

# Create a Kafka Service
sudo docker service create \
  --network=monitoring \
  --reserve-memory=3221225472 \
  --env KAFKA=${MANAGER0_IP}:9092 \
  --env ZOOKEEPER=${MANAGER0_IP}:2181 \
  --publish 2181:2181 --publish 9092:9092 \
  --constraint node.hostname==swarm-agent-00 \
  --name kafka \
  --replicas 1 \
  flozano/kafka

# Install Influxdb
docker service create \
   --network=monitoring \
   --publish 8083:8083 `# HTTP API Port` \
   --publish 8086:8086 `# Administrator Interface Port` \
   --mount type=volume,target=/var/lib/influxdb \
   --env PRE_CREATE_DB=cadvisor \
   --name influxdb \
   influxdb:latest

# Install Grafana
sudo docker service create \
   --network=monitoring \
   --publish 3000:3000 `# HTTP Port` \
   --env GF_SERVER_ROOT_URL="http://10.48.98.232" \
   --env GF_SECURITY_ADMIN_PASSWORD=admin \
   --env INFLUXDB_HOST="${MANAGER0_IP}" \
   --env INFLUXDB_PORT=8086 \
   --env INFLUXDB_NAME=cadvisor \
   --env INFLUXDB_USER=root \
   --env INFLUXDB_PASS=root \
   --name grafana \
  grafana/grafana

# Start CAdvisor in global mode (an instance on every container) and forward 8080 so we can access the web UI if needed
sudo docker service create --network=monitoring --mode global --name cadvisor \
  --mount type=bind,source=/,target=/rootfs,readonly=true \
  --mount type=bind,source=/var/run,target=/var/run,readonly=false \
  --mount type=bind,source=/sys,target=/sys,readonly=true \
  --mount type=bind,source=/var/lib/docker/,target=/var/lib/docker,readonly=true \
  --publish 8080:8080 \
  google/cadvisor:latest \
  -storage_driver=kafka \
  -storage_driver_kafka_broker_list=kafka:9092 `# Same as the specified ENV variable in the kafka service` \
  -storage_driver_kafka_topic=container_stats `# Topic name` \
  -storage_driver=influxdb \
  -storage_driver_host="${MANAGER0_IP}:8086" \
  -storage_driver_user="root" \
  -storage_driver_password="root" \
  -storage_driver_db="cadvisor"

echo "Done"

# Swarm cluster status
#export DOCKER_HOST_OLD=`echo $DOCKER_HOST`
#export DOCKER_HOST=tcp://${MANAGER0_IP}:4000
#sudo docker -H ${MANAGER0_IP}:4000 info
