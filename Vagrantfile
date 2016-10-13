$prepare_swarm_manager_script = <<SCRIPT
# Install Docker
curl -sSL https://get.docker.com/ | sh
SCRIPT

$prepare_swarm_node1_script = <<SCRIPT
# Install Docker
curl -sSL https://get.docker.com/ | sh
SCRIPT

$prepare_swarm_node2_script = <<SCRIPT
# Install Docker
curl -sSL https://get.docker.com/ | sh
SCRIPT


Vagrant.configure(2) do |config|
  config.vm.define "swarm_manager_00" do |config|
    config.vm.box = "ubuntu/trusty64"
    config.vm.hostname = "swarm-manager-00"
    config.vm.network "private_network", ip: "10.0.7.11"
    config.vm.provision "shell", inline: $prepare_swarm_manager_script
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.memory = 1024
    config.vm.cpus = 2
  end

  config.vm.define "swarm_agent_00" do |config|
    config.vm.box = "ubuntu/trusty64"
    config.vm.hostname = "swarm-agent-00"
    config.vm.network "private_network", ip: "10.0.7.12"
    config.vm.provision "shell", inline: $prepare_swarm_node1_script
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.memory = 4096
    config.vm.cpus = 2
  end

  config.vm.define "swarm_agent_01" do |config|
    config.vm.box = "ubuntu/trusty64"
    config.vm.hostname = "swarm-agent-01"
    config.vm.network "private_network", ip: "10.0.7.13"
    config.vm.provision "shell", inline: $prepare_swarm_node2_script
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.memory = 4096
    config.vm.cpus = 2
  end
end
