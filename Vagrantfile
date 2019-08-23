
# Install requisite plugins
required_plugins = [
    'vagrant-disksize'
  ]
plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }

if ARGV[0] != 'plugin' and not plugins_to_install.empty?
  puts "Installing plugins: #{plugins_to_install.join(' ')}"
  if system "vagrant plugin install #{plugins_to_install.join(' ')}"
    # Continue with the requested vagrant command
    exec "vagrant #{ARGV.join(' ')}"
  else
    abort "Installation of one or more plugins has failed. Aborting."
  end
end

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/bionic64"
  config.vm.hostname = "tygernix"
  config.vm.synced_folder "share/", "/mnt/share", create: true, automount: true
  config.disksize.size = "20GB"

  config.vm.provider "virtualbox" do |vbox|
      vbox.gui = true
      vbox.name = 'tygrant_bionic64'
      vbox.memory = 8096
      vbox.cpus = 2

      # Add an empty optical drive
      vbox.customize ["storageattach", :id, 
        "--storagectl", "IDE", 
        "--port", "0",
        "--device", "1", 
        "--type", "dvddrive", 
        "--medium", "emptydrive"]  
  end

  # config.vm.network "forwarded_port", guest: 5000, host: 5000

  $script = <<-PREANSIBLE
    echo "Running pre-ansible shell provisioner"
    # Do stuff
    echo "Done."
  PREANSIBLE
  config.vm.provision "shell", inline: $script

  config.vm.provision "ansible_local" do |a|
      a.galaxy_role_file = "galaxy_roles.yml"
      a.install_mode = "default"
      a.playbook = "setup.yml"
  end
end
