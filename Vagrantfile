Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.hostname = "tygernix"

  config.vm.provider "virtualbox" do |vbox|
      vbox.gui = true
      vbox.name = 'tygrant_bionic64'
      # vbox.memory = 8096
      # vbox.cpus = 2
  end

  # config.vm.network "forwarded_port", guest: 5000, host: 5000

  $script = <<-FIXAPT
    echo "Running pre-ansible shell provisioner"
    # Do stuff
    echo "Done."
  FIXAPT
  config.vm.provision "shell", inline: $script

  config.vm.provision "ansible_local" do |a|
      a.galaxy_role_file = "galaxy_roles.yml"
      a.install_mode = "pip"
      a.playbook = "setup.yml"
  end
end
