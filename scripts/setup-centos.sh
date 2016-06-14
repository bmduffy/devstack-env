#!bin/bash

echo "Install VirtualBox on Centos 7..."

# http://www.if-not-true-then-false.com/2010/install-virtualbox-with-yum-on-fedora-centos-red-hat-rhel/

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

## CentOS 7 and RHEL 7 ##
rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-6.noarch.rpm
 
# 5. Install VirrtalBox latest version 5.0 

yum install VirtualBox-5.0
/usr/lib/virtualbox/vboxdrv.sh setup

usermod -a -G vboxusers Brian ## CHANGE: insert your username here

echo "Install Vagrant ..."

echo "Install Vagrant Plugins ..."