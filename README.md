## Deploy DevStack into a VM with Vagrant

The goal of this project is to deploy DevStack into a VM, in an automated and easily repeatable way, so that you can get 
developing OpenStack as quickly as possible. I only cater for a Centos 7 host box, so the prerequisites are tailored 
this environment.

### Prerequisites

You can choose any VM software you like. I pefer VirtualBox, I have had more experience with it, and it seems to play 
well with Centos 7. The following steps worked for me when installing VirtualBox. 

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

You will also need to install Vagrant, which will use whatever virtualization software you tell it to. For more information
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
vagrant plugin install vagrant-triggers
vagrant plugin install vagrant-env
```

### How to Use

Once you've installed all the prerequisites, you should just need to run;

```
    vagrant up
```

This will;
    
1. Deploy a VM into VirtualBox
  * minimal install requirements for DevStack is 4GB memory + 2 CPUs
  * hostonly adapter on **172.18.161.6**
2. Provision the VM using Ansible
  * create **stack** user with the correct groups and permissions
  * clone DevStack to **/opt/devstack**
  * copy **local.conf**, your DevStack configuration to **/opt/devstack**
3. Set up ssh on your host machine
  * add **devstack-box** entry to **~/.ssh/config**
  * copy a default rsa key to the VM
  * mount **devstack-box:/opt/devstack** to **./devstack** on your host

You can ssh to the VM via the NAT adapter;

```
    vagrant ssh 
```

Or the hostonly adapter;

```
    ssh devstack-box
```

Check that **./devstack** is mounted. You should see the contents of the devstack folder
here. You can edit files on the VM directly here when you are working on OpenStack code.

To destroy the DevStack environment, you should just need to run;

```
    vagrant destroy
```
