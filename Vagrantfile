# A dummy plugin for DockerRoot to set hostname and network correctly at the very first `vagrant up`
module VagrantPlugins
  module GuestLinux
    class Plugin < Vagrant.plugin("2")
      guest_capability("linux", "change_host_name") { Cap::ChangeHostName }
      guest_capability("linux", "configure_networks") { Cap::ConfigureNetworks }
    end
  end
end

Vagrant.configure(2) do |config|
  config.vm.define "fschangetest"

  config.vm.box = "ailispaw/barge"

  config.vm.network :private_network, ip: "192.168.33.10"

  if "#{ENV['NFS']}" === "1" then
    config.vm.synced_folder ".", "/vagrant", type: "nfs",
      mount_options: ["nolock", "vers=3", "udp", "noatime", "actimeo=1"]
  else
    config.vm.synced_folder ".", "/vagrant"
  end

  config.vm.provision :docker do |docker|
    docker.build_image "/vagrant", args: "-t alpine -f /vagrant/Dockerfile.alpine"
    docker.run "alpine",
      args: "-v /vagrant:/app -p 8000:5000",
      cmd: "python app.py",
      restart: false

    docker.build_image "/vagrant", args: "-t slim -f /vagrant/Dockerfile.slim"
    docker.run "slim",
      args: "-v /vagrant:/app -p 8001:5000",
      cmd: "python app.py",
      restart: false

    docker.build_image "/vagrant", args: "-t nginx-alpine -f /vagrant/Dockerfile.nginx-alpine"
    docker.run "nginx-alpine",
      args: "-v /vagrant:/usr/html -p 8002:80",
      restart: false

    docker.build_image "/vagrant", args: "-t nginx-jessie -f /vagrant/Dockerfile.nginx-jessie"
    docker.run "nginx-jessie",
      args: "-v /vagrant:/usr/share/nginx/html -p 8003:80",
      restart: false
  end
end
