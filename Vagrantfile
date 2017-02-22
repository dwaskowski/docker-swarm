Vagrant.configure("2") do |config|

  config.vm.define :master do |vm_config|
    vm_config.vm.box = "debian/jessie64"
    vm_config.vm.synced_folder "swarm", "/swarm", :nfs => true
    vm_config.vm.synced_folder "vendor/dwaskowski/environment/docker", "/docker", :nfs => true
    vm_config.vm.provision "shell" do |s|
      s.path = "master/bootstrap.sh"
      s.args = ["master", "192.168.254.2"]
    end
    vm_config.vm.network "private_network", ip: "192.168.254.2"
    vm_config.vm.provider "virtualbox" do |vb|
      vb.name = "Docker Swarm Master"
      vb.memory = 1024
      vb.cpus = 2
    end
  end

  config.vm.define :node1 do |vm_config|
    vm_config.vm.box = "debian/jessie64"
    vm_config.vm.synced_folder "swarm", "/swarm", :nfs => true
    vm_config.vm.provision "shell" do |s|
      s.path = "node/bootstrap.sh"
      s.args = ["node1", "192.168.254.3"]
    end
    vm_config.vm.network "private_network", ip: "192.168.254.3"
    vm_config.vm.provider "virtualbox" do |vb|
      vb.name = "Docker Swarm Node1"
      vb.memory = 768
      vb.cpus = 2
    end
  end

  config.vm.define :node2 do |vm_config|
    vm_config.vm.box = "debian/jessie64"
    vm_config.vm.synced_folder "swarm", "/swarm", :nfs => true
    vm_config.vm.provision "shell" do |s|
      s.path = "node/bootstrap.sh"
      s.args = ["node2", "192.168.254.4"]
    end
    vm_config.vm.network "private_network", ip: "192.168.254.4"
    vm_config.vm.provider "virtualbox" do |vb|
      vb.name = "Docker Swarm Node2"
      vb.memory = 768
      vb.cpus = 2
    end
  end

end

