#!/bin/bash

# Note: Execute this script on the MANAGER host with SSH connections to the other nodes 
MANAGER0_IP=10.0.7.11
NODE0_IP=10.0.7.12
NODE1_IP=10.0.7.13

echo "Hard resetting the swarm"
sudo rm -rf /var/lib/docker/swarm
sudo service docker restart

echo "Unregistering nodes from the swarm"
ssh vagrant@${NODE0_IP} "sudo docker swarm leave"
ssh vagrant@${NODE1_IP} "sudo docker swarm leave"
