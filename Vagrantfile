# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu-14.04"
  config.vm.box_url = "http://200.21.0.30/vagrant/box/trusty-server-cloudimg-amd64-vagrant-disk1.box"

  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false

    # Customize the amount of memory on the VM:
    vb.memory = "1024"
  end

  config.vm.define "graphite" do |graphite|
    graphite.vm.hostname = "graphite.test.com"
  end

  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 9000, host: 9000
  config.vm.network "forwarded_port", guest: 3000, host: 3000

  #config.vm.provision "shell", inline: <<-SHELL
  #  sudo apt-get update
  #  sudo apt-get install -y apache2
  #SHELL

  config.vm.provision :shell, :path => "scripts/init_ubuntu.sh"
  config.vm.provision :shell, :path => "scripts/install_graphite.sh"
end
