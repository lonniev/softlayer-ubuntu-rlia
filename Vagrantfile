# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.5.2"

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.guest              = :linux
  config.vm.box                = "ubuntu/trusty64"

  #config.ssh.username         = "vagrant"
  #config.ssh.password         = "vagrant"
  config.ssh.forward_agent     = true
  config.ssh.forward_x11       = false
  config.ssh.private_key_path  = [ File.expand_path("~/.vagrant.d/insecure_private_key") ]

  # Share any additional folders to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  
  #See http://docs.vagrantup.com/v2/synced-folders/basic_usage.html

  # config.vm.synced_folder "../data", "/vagrant_data"

  # common provider-specific settings for this multi-host network
  config.vm.provider :softlayer do |sl, config_override|

    config_override.vm.box       = "ju2wheels/SL_UBUNTU_LATEST_64"

    config_override.ssh.username = "root"

    sl.api_timeout = 180 # in seconds
    sl.provision_timeout = 600 # in seconds

    sl.api_key                   = ENV["SL_API_KEY"]
    sl.ssh_keys                  = [ "SL-root-pk" ]
    sl.username                  = ENV["SL_API_USERNAME"] || ENV['USER'] || ENV['USERNAME']
    sl.domain                    = "almplm.sodius.com"
      
    sl.datacenter                = 'dal05'
    sl.local_disk                = true
      
    sl.network_speed             = 100
      
      #sl.post_install              = "https://raw.githubusercontent.com/lonniev/"

      #sl.hourly_billing            = true
      #sl.dedicated                 = false
      #sl.disk_capacity             = { 0 => 25 }
      #sl.endpoint_url              = SoftLayer::API_PUBLIC_ENDPOINT
      #sl.force_private_ip          = false
      #sl.manage_dns                = false
      #sl.max_memory                = 1024
      #sl.private_only              = false
      #sl.start_cpus                = 1
      #sl.user_data                 = nil
      #sl.vlan_private              = nil
      #sl.vlan_public               = nil

  end if Vagrant.has_plugin?("SoftLayer")

  # this deployment has 4 hosts
  # host1.almplm.domain.com: the primary and public access point
  # host2.almplm.domain.com: the ALM services on the sodiusalm.internal.net subnet
  # host3.almplm.domain.com: the PLM services on the sodiusplm.internal.net subnet
  # host4.almplm.domain.com: the RLIA broker on the sodiusrlia.internal.net subnet

  config.hostmanager.enabled = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true

  config.hostmanager.ip_resolver = proc do |vm, resolving_vm|
    `vagrant ssh #{vm.name} -c '/sbin/ifconfig eth0|grep "inet addr"'`.split("\n").last[/(\d+\.\d+\.\d+\.\d+)/, 1]
  end

  config.omnibus.chef_version = :latest

  config.vm.define "sl-ubuntu-host1", primary: true do | vmh |

    vmh.vm.hostname = "host1"

    vmh.vm.provider :softlayer do |sl, vmh_override|
      sl.hostname                  = vmh.vm.hostname
      vmh_override.vm.network "private_network", type: "dhcp", auto_config: true
    end if Vagrant.has_plugin?("SoftLayer")

    vmh.vm.network "public_network", bridge: 'eth1'
    vmh.hostmanager.aliases = %w(proxy.internal.net)
    vmh.vm.usable_port_range          = 2200..6000

    vmh.vm.provision "chef_solo" do |chef|
      chef.cookbooks_path = "./cookbooks"
      chef.roles_path = "./roles"
      chef.environments_path = "./environments"

      chef.add_role "reverse-proxy"
    end

  end

  config.vm.define "sl-ubuntu-host2" do | vmh |

    vmh.vm.hostname = "host2"

    vmh.vm.provider :softlayer do |sl, vmh_override|
      sl.hostname                  = vmh.vm.hostname
      vmh_override.vm.network "private_network", type: "dhcp", auto_config: true
    end if Vagrant.has_plugin?("SoftLayer")

    vmh.vm.network "public_network", bridge: 'eth1'
    vmh.hostmanager.aliases = %w(alm.internal.net)
    vmh.vm.usable_port_range          = 2200..6000

    vmh.vm.provision "chef_solo" do |chef|
      chef.cookbooks_path = "./cookbooks"
      chef.roles_path = "./roles"
      chef.environments_path = "./environments"

      chef.add_role "alm-server"
    end

  end

  config.vm.define "sl-ubuntu-host3" do | vmh |

    vmh.vm.hostname = "host3"

    vmh.vm.provider :softlayer do |sl, vmh_override|
      sl.hostname                  = vmh.vm.hostname
      vmh_override.vm.network "private_network", type: "dhcp", auto_config: true
    end if Vagrant.has_plugin?("SoftLayer")

    vmh.vm.network "public_network", bridge: 'eth1'
    vmh.hostmanager.aliases = %w(plm.internal.net)
    vmh.vm.usable_port_range          = 2200..6000

    vmh.vm.provision "chef_solo" do |chef|
      chef.cookbooks_path = "./cookbooks"
      chef.roles_path = "./roles"
      chef.environments_path = "./environments"

      chef.add_role "plm-server"
    end

  end

  config.vm.define "sl-ubuntu-host4" do | vmh |

    vmh.vm.hostname = "host4"

    vmh.vm.provider :softlayer do |sl, vmh_override|
      sl.hostname                  = vmh.vm.hostname
      vmh_override.vm.network "private_network", type: "dhcp", auto_config: true
    end if Vagrant.has_plugin?("SoftLayer")

    vmh.vm.network "public_network", bridge: 'eth1'
    vmh.hostmanager.aliases = %w(rlia.internal.net)
    vmh.vm.usable_port_range          = 2200..6000

    vmh.vm.provision "chef_solo" do |chef|
      chef.cookbooks_path = "./cookbooks"
      chef.roles_path = "./roles"
      chef.environments_path = "./environments"

      chef.add_role "rlia-server"
    end

  end

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  #
end