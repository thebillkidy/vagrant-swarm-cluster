#!/bin/bash

SWARM_VERSION=1.2.0
MANAGER0_IP=10.0.7.11
CONSUL0_IP=10.0.7.11
NODE1_IP=10.0.7.12
NODE2_IP=10.0.7.13

# Run Consul on every Host (Consul can thus be running as master on any of these nodes!)
#  $ docker run -d -p 8500:8500 --name=consul progrium/consul -server -bootstrap
echo "Starting Consul containers..."
sudo docker -H ${CONSUL0_IP}:2375 run -d -p 8500:8500 --name=consul progrium/consul -server -bootstrap
#sudo docker -H ${CONSUL0_IP}:2375 run -d --restart always --name consul1 --net host consul agent -server -bind ${CONSUL0_IP} -client 10.0.7.11 -retry-join 10.0.7.11 -retry-join 10.0.7.12 -retry-join 10.0.7.13 -bootstrap-expect 3

# Run a Swarm manager node (HA enabled)
# $ docker run -d -p 4000:4000 swarm manage -H :4000 --replication --advertise <manager0_ip>:4000 consul://<consul0_ip>:8500
echo "Starting Swarm Manager..."
sudo docker -H ${MANAGER0_IP}:2375 run -d --restart always -p 4000:4000 --name swarm_manager_01 swarm:${SWARM_VERSION} manage -H :4000 --replication --advertise ${MANAGER0_IP}:2375 consul://${CONSUL0_IP}:8500

# Run the first and second Swarm nodes
# $ docker run -d swarm join --advertise=<node_ip>:2375 consul://<consul0_ip>:8500
echo "Starting Swarm Agent #1..."
sudo docker -H ${NODE0_IP}:2375 run -d --restart always --name swarm_agent_00 swarm:${SWARM_VERSION} join --heartbeat 20s --ttl 30s --advertise ${NODE0_IP}:2375 consul://${CONSUL0_IP}:8500
echo "Starting Swarm Agent #2..."
sudo docker -H ${NODE1_IP}:2375 run -d --restart always --name swarm_agent_01 swarm:${SWARM_VERSION} join --heartbeat 20s --ttl 30s --advertise ${NODE1_IP}:2375 consul://${CONSUL0_IP}:8500

echo "Waiting for the nodes to join the cluster..."
# Wait for the nodes to join the cluster
sleep 20

# Swarm cluster status
export DOCKER_HOST_OLD=`echo $DOCKER_HOST`
export DOCKER_HOST=tcp://${MANAGER0_IP}:4000
sudo docker -H ${MANAGER0_IP}:4000 info
