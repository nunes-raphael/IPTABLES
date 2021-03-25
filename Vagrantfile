Vagrant.configure("2") do |config|
  
  NodeCount = 1
  (1..NodeCount).each do |i|
    config.vm.define "debianfw_#{i}" do |debianfw|
      debianfw.vm.box = "debian/stretch64"
      debianfw.vm.network "public_network", ip: "192.168.100.13#{i+2}"
      debianfw.vm.network "private_network", ip: "192.168.1.254",
        virtualbox__intnet: "NatNetwork"
      debianfw.vm.hostname = "debianfw-#{i}"
      
      debianfw.ssh.insert_key = false
      debianfw.ssh.private_key_path = ['~/.vagrant.d/insecure_private_key', '~/.ssh/id_rsa']
      debianfw.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"

      debianfw.vm.provision "file", source: "dhcpd.conf", destination: "/tmp/dhcpd.conf"
      debianfw.vm.provision "file", source: "isc-dhcp-server", destination: "/tmp/isc-dhcp-server"
      debianfw.vm.provision "file", source: "server.conf", destination: "/tmp/server.conf"
      debianfw.vm.provision "file", source: "static.key", destination: "/tmp/static.key"
      debianfw.vm.provision "file", source: "firewall_1.0_amd64.deb", destination: "/tmp/firewall_1.0_amd64.deb"

      debianfw.vm.provision "shell", path: "config.sh"


      debianfw.vm.provider "virtualbox" do |v|
        v.memory = 2048
        v.cpus = 4
        v.name = "debianfw_#{i}"
      end
    end
  end
end
