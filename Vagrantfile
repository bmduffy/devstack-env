# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    
    config.env.enable # enable env plugin
    
    config.vm.box = "centos/7"    
    config.vm.box_check_update = true
    config.ssh.forward_agent = true
    
    # disable default synced folders, you won't need them
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.synced_folder ".", "/home/vagrant/sync", disabled: true

    # scripts to run on host on vagrant up + destroy

    config.trigger.before :up do
        info "Set up host environment"
        run "ansible-playbook ./plays/pre-provision.yml -v"
    end

    config.trigger.after :up do
        info "Mount directories and configure ssh"
        run "ansible-playbook ./plays/post-provision.yml -v"
    end

    config.trigger.before :provision do
        info "Mount directories and configure ssh"
        run "ansible-playbook ./plays/pre-provision.yml -v"
    end

    config.trigger.after :provision do
        info "Mount directories and configure ssh"
        run "ansible-playbook ./plays/post-provision.yml -v"
    end

    config.trigger.after :destroy do
        info "Clean up host after VM destroyed ..."
        run "ansible-playbook ./plays/clean-up.yml -v"
    end 

    config.vm.define "guest_box" do |box|

        # set up host only adapter for horizon
        ipaddr = ENV['GUEST_IP']
        box.vm.network "private_network", ip: "172.18.161.6"

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
            
            ansible.playbook = "./plays/devstack-box.yml"
            ansible.verbose  = true
            ansible.groups = {
                "guests" => ["guest_box"]
            }

        end
    end
end
