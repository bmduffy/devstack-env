# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    config.vm.box = "centos/7"    
    config.vm.box_check_update = true
    config.ssh.forward_agent = true
    
    # disable default synced folders, you won't need them
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.synced_folder ".", "/home/vagrant/sync", disabled: true

    # scripts to run on host on vagrant up + destroy

    config.trigger.before :up do
        info "Set /etc/host info ..."
        run "./pre-provision.sh"
    end

    config.trigger.after :up do
        info "Mount /opt/devstack/ on guest to ./devstack/ on host ..."
        run "./post-provision.sh"
    end

    config.trigger.after :destroy do
        info "Clean up host after VM destroyed ..."
        run "./clean-up.sh"
    end 

    config.vm.define "guest_box" do |box|

        # set up host only adapter for horizon        
        box.vm.network "private_network", ip: ENV['VAGRANT_DEVSTACK_HOST_IP']

        # configure the box instancd
        box.vm.provider "virtualbox" do |instance|
            
            instance.name   = "devstack-box"
            instance.gui    = false
            instance.cpus   = "2"
            instance.memory = "4096"

            instance.customize ["modifyvm", :id, "--uart1", "0x3F8", 4]
        
        end 

        # run ansible on guest, see devstack_box.yml
        box.vm.provision "ansible" do |ansible|
            
            ansible.playbook = "devstack_box.yml"
            ansible.verbose  = true
            ansible.groups = {
                "guests" => ["guest_box"]
            }

        end
    end
end
