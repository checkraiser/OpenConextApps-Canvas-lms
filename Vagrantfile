# -*- mode: ruby -*-
# vim: set ft=ruby :

Vagrant::Config.run do |config|

  config.vm.box = "lucid32"

  config.vm.box_url = "http://files.vagrantup.com/lucid32.box"

  # Boot with a GUI so you can see the screen. (Default is headless)
  # config.vm.boot_mode = :gui

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  # config.vm.network :hostonly, "192.168.33.10"

  # Assign this VM to a bridged network, allowing you to connect directly to a
  # network using the host's network device. This makes the VM appear as another
  # physical device on your network.
  # config.vm.network :bridged

  config.vm.forward_port(80, 8080)
  config.vm.forward_port(3000, 3000)

  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  config.vm.share_folder "cookbooks", "/var/chef/cookbooks", "cookbooks"
  config.vm.share_folder "shared", "/home/vagrant/shared", "shared"

  config.vm.provision :chef_solo do |chef|

        #canvas::ruby
        #canvas
        #java
        #canvas::coffeescript

    chef.cookbooks_path = "cookbooks"
    %w{
        canvas::apt-sources
        ruby_build
        rbenv::system
        passenger_apache2::mod_rails
        canvas
    }.each { |r|
      chef.add_recipe r
    }

    chef.json.merge!({
        :rbenv => {
            :global => "1.8.7-p358",
            :rubies => [ "1.8.7-p358" ],
            :gems => {
                "1.8.7-p358" => [
                    { :name => "bundler" }
                ]
            }
        },
        :passenger => {
            :version => "3.0.13"
        },
        :mysql => { :server_root_password => "secret" }
    })
  end

end
