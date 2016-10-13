$prepare_swarm_manager_script = <<SCRIPT
# Install Docker
curl -sSL https://get.docker.com/ | sh

# Configure docker
service docker stop;
rm -rf /etc/docker/key.json
echo 'DOCKER_OPTS="-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --cluster-store=consul://10.0.7.11:8500 --cluster-advertise=eth1:2375"' | tee -a /etc/default/docker;
service docker start;
SCRIPT

$prepare_swarm_node1_script = <<SCRIPT
# Install Docker
curl -sSL https://get.docker.com/ | sh

# Configure docker
service docker stop;
rm -rf /etc/docker/key.json;
echo 'DOCKER_OPTS="-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --cluster-store=consul://10.0.7.12:8500 --cluster-advertise=eth1:2375"' | tee -a /etc/default/docker;
service docker start;
SCRIPT

$prepare_swarm_node2_script = <<SCRIPT
# Install Docker
curl -sSL https://get.docker.com/ | sh

# Configure docker
service docker stop;
rm -rf /etc/docker/key.json;
echo 'DOCKER_OPTS="-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --cluster-store=consul://10.0.7.13:8500 --cluster-advertise=eth1:2375"' | tee -a /etc/default/docker;
service docker start;
SCRIPT


Vagrant.configure(2) do |config|
  config.vm.define "swarm_manager" do |config|
    config.vm.box = "hashicorp/trusty64"
    config.vm.hostname = "swarm-manager-00"
    config.vm.network "private_network", ip: "10.0.7.11"
    config.vm.provision "shell", inline: $prepare_swarm_manager_script
    config.vm.synced_folder ".", "/vagrant", disabled: true
  end

  config.vm.define "swarm_node1" do |config|
    config.vm.box = "hashicorp/trusty64"
    config.vm.hostname = "swarm-agent-00"
    config.vm.network "private_network", ip: "10.0.7.12"
    config.vm.provision "shell", inline: $prepare_swarm_node1_script
    config.vm.synced_folder ".", "/vagrant", disabled: true
  end

  config.vm.define "swarm_node2" do |config|
    config.vm.box = "hashicorp/trusty64"
    config.vm.hostname = "swarm-agent-01"
    config.vm.network "private_network", ip: "10.0.7.13"
    config.vm.provision "shell", inline: $prepare_swarm_node2_script
    config.vm.synced_folder ".", "/vagrant", disabled: true
  end
end
