#!/bin/bash
MANAGER0_IP=10.0.7.11
NODE0_IP=10.0.7.12
NODE1_IP=10.0.7.13

# Create manager and get the token
vagrant ssh swarm_manager_00 -c "sudo docker swarm init --advertise-addr ${MANAGER0_IP}"
SWARM_TOKEN=`vagrant ssh swarm_manager_00 -c "sudo docker swarm join-token -q worker --quiet"`

# Add the nodes to this manager
vagrant ssh swarm_agent_00 -c "sudo docker swarm join --token ${SWARM_TOKEN} ${MANAGER0_IP}:2377"
vagrant ssh swarm_agent_01 -c "sudo docker swarm join --token ${SWARM_TOKEN} ${MANAGER0_IP}:2377"

# Create a network for monitoring tools
vagrant ssh swarm_manager_00 -c "sudo docker network create monitoring -d overlay"

# Create a Kafka Service
sudo docker service create \
  --network=monitoring \
  --reserve-memory=3221225472 \
  --env KAFKA=localhost:9092 --env ZOOKEEPER=localhost:2181 \
  --publish 2181:2181 --publish 9092:9092 \
  --name kafka \
  --replicas 1 \
  antlypls/kafka

# Start CAdvisor in global mode (an instance on every container) and forward 8080 so we can access the web UI if needed
sudo docker service create --network=monitoring --mode global --name cadvisor \
  --mount type=bind,source=/,target=/rootfs,readonly=true \
  --mount type=bind,source=/var/run,target=/var/run,readonly=false \
  --mount type=bind,source=/sys,target=/sys,readonly=true \
  --mount type=bind,source=/var/lib/docker/,target=/var/lib/docker,readonly=true \
  --publish 8080:8080 \
  google/cadvisor:latest \
  -storage_driver=kafka \
  -storage_driver_kafka_broker_list=localhost:9092 `# Same as the specified ENV variable in the kafka service` \
  -storage_driver_kafka_topic=container_stats `# Topic name`
#  -storage_driver=elasticsearch \
#  -storage_driver_es_host="http://elasticsearch:9200"

# Wait for the nodes to join the cluster
echo "Waiting for the nodes to join the cluster..."
sleep 5

# Swarm cluster status
#export DOCKER_HOST_OLD=`echo $DOCKER_HOST`
#export DOCKER_HOST=tcp://${MANAGER0_IP}:4000
#sudo docker -H ${MANAGER0_IP}:4000 info
