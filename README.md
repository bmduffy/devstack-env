# Deploy DevStack Environment with Vagrant

## Overview

If you want to contribute to the OpenStack open source project,
deploying DevStack can take time. I've tried to automate this process
for deploying Devstack into a VM. 

I've only done this for a Centos 7 host box, so the everything is  
tailored this environment.

The project environment is managed with Vagrant. 
Provisioning of the host and VM are managed with Ansible.
These components are tied together with make. 

## Prerequisites

* Ruby
* Make
* Ansible
* VirtualBox
* Vagrant

## Usage

```
    make           # default 'make all' builds the VM and sets up the host
    make retry     # reloads and reprovisions the VM
    make provision # reprovisions the VM
    make clean     # destroys the VM and cleans up the host
```

When the VM is up you can ssh to it and run DevStack scripts;

```
  ssh devstack-box   # this is automatically put in your host config
  cd /opt/devstack
  git status 
  git checkout stable/kilo  # or another stable branch of devstack
  ./stack.sh
  ./unstack.sh
```

### Notes

* DevStack source code is pulled from [here](https://git.openstack.org/openstack-dev/devstack) and stored in /opt/devstack when the VM is provisioned. This folder is mounted on the host in the devstack folder where the makefile is located.
* OpenStack source code is pulled by 'make stack' and stored in /opt/stack on the VM. This folder is mounted on the host in the src folder where the makefile is located.

## Installation Details

**Install VirtualBox:** You can choose any VM software you like. 
I pefer VirtualBox, I have had more experience with it, and it 
seems to play well with Centos 7. The following steps worked for 
me when installing VirtualBox. 

For more information go
[here](http://www.if-not-true-then-false.com/2010/install-virtualbox-with-yum-on-fedora-centos-red-hat-rhel/).

```
# 1. switch to root user
su - 

# 2. Install RHEL Repo Files
cd /etc/yum.repos.d/
wget http://download.virtualbox.org/virtualbox/rpm/rhel/virtualbox.repo

# 3. Update latest packages and check kernel verison
yum update

RPM_KERNEL="$(rpm -qa kernel |sort -V |tail -n 1)"
INSTALLED="kernel-$(uname -r)"

# if you have had to reboot run this test again
# and this condition will be met.
if [[ RPM -ne INSTALLED ]]; then
    reboot
fi

# 4. Install following dependency packages
rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-6.noarch.rpm
 
# 5. Install VirrtalBox latest version 5.0 
yum install VirtualBox-5.0
/usr/lib/virtualbox/vboxdrv.sh setup

usermod -a -G vboxusers Brian ## CHANGE: insert your username here
```

**Install Vagrant:** You will also need to install Vagrant, which will use whatever virtualization software you tell it to. For more information
about why using Vagrant might be a good idea go [here](https://www.vagrantup.com/docs/why-vagrant/).

Get the latest Vagrant RPM [here](https://www.vagrantup.com/downloads.html).

```
# 1. Install Vagrant 
sudo yum install **vagrant_1.8.1_x86_64.rpm**

# 2. Check it's installed 
whereis vagrant

# Try run Vagrant, if it doesn't start, log out and log in again vagrant

# 3. Instal Vagrant plugins to make this project work
vagrant plugin install vagrant-vbguest
```

**Install Ansible:** This Vagrantfile is using Ansible for provisioning of the VM and the host machine.

```
  sudo yum install -y ansible
```