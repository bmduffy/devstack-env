# Getting Started With Devstack

You can choose any VM software you like. I pefer VirtualBox, I have had 
more experience with it, and it seems to play well with Centos 7.

Whichever VM software you choose, it should be able to do nested
virtualization. This is because you will be running virutal machines, 
that is Nova nodes, inside virtual machines, that is your sandboxed 
environment that Devstack will be set up in.   

You will need to install the following get Devstack working on a VM. Use 
yum to install the relevant software, it just makes your life easier.

## Option 1: Install VirtualBox

- Install VirtualBox >= 5.0
- The best instructions I have found that actually work are [here](http://www.if-not-true-then-false.com/2010/install-virtualbox-with-yum-on-fedora-centos-red-hat-rhel/)
- These instructions cover Fedora and RHEL linux (Centos) for a variety of versions

## Option 2: Install KVM

- I haven't done this ...

## Install Vagrant

- Get RPM [here](https://www.vagrantup.com/downloads.html)
- sudo yum install **vagrant_1.8.1_x86_64.rpm** or latest
- check it's installed **whereis vagrant** and run **vagrant**
- If it doesn't start, log out and log in again
- vagrant plugin install vagrant-vbguest
- vagrant plugin install vagrant-triggers
- vagrant plugin install vagrant-env
- [Why use Vagrant?](https://www.vagrantup.com/docs/why-vagrant/)

## Create Development Environment

To set up the environment, clone this repo, and then clone DevStack
into it. 

- git clone http://bduffy@gerrit.ammeon.com/a/devstack-env
- cd devstack-env
- git clone https://git.openstack.org/openstack-dev/devstack

You're ready to set up the a VM where you can deploy devstack.

- vagrant up

Things to note;

1. The Vagrantfile and the Ansible playbook will take care of 
setting up the environment for you. 

2. The DevStack repo in your workspace is synced with /opt/devstack on 
the VM. Changes to files here will appear in the VM. 

3. The **stack** user is aleardy created by the playbook.

## Deploy DevStack

Now you have a VM that's primed to deploy devstack. 

Continue on from the DevStack Quick Start 
[docs](http://docs.openstack.org/developer/devstack/) step 4.

Make sure you have a minimal configuration in the devstack folder. 
One is provided in this repo.

- cp local.conf devstack/
- vagrant ssh
- su - stack  (password; passw0rd)
- ls devstack

You should see that local.conf has synced with /opt/devstack. 

- ./stack.sh
