# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  N = 2

  config.vm.boot_timeout = 3000
  
  # Master Node #
  config.vm.define "master" do |cfg|
    cfg.vm.box = "ubuntu/focal64"
    cfg.vm.provider "virtualbox" do |vb|
      vb.name = "master"
      vb.cpus = 2
      vb.memory = 3072
      vb.customize ["modifyvm", :id, "--groups", "/k8s"]
    end
    cfg.vm.host_name = "master"
    cfg.vm.network "private_network", ip: "192.168.56.1"
    cfg.vm.network "forwarded_port", guest: 22, host: 2220, auto_correct: true, id: "ssh"
    cfg.vm.synced_folder "../data", "/vagrant", disabled: true
    cfg.vm.provision "shell", path: "config.sh", args: N
    cfg.vm.provision "shell", path: "install_pkg.sh"
    cfg.vm.provision "shell", path: "master_node.sh"
  end

  # Worker Nodes #
  (1..N).each do |i|
    config.vm.define "worker#{i}" do |cfg|
      cfg.vm.box = "ubuntu/focal64"
      cfg.vm.provider "virtualbox" do |vb|
        vb.name = "worker#{i}"
        vb.cpus = 2
        vb.memory = 2560
        vb.customize ["modifyvm", :id, "--groups", "/k8s"]
      end
      cfg.vm.host_name = "worker#{i}"
      cfg.vm.network "private_network", ip: "192.168.56.1#{i}"
      cfg.vm.network "forwarded_port", guest: 22, host: "222#{i}", auto_correct: true, id: "ssh"
      cfg.vm.synced_folder "../data", "/vagrant", disabled: true
      cfg.vm.provision "shell", path: "config.sh", args: N
      cfg.vm.provision "shell", path: "install_pkg.sh"
      cfg.vm.provision "shell", path: "work_nodes.sh"
    end
  end
end  