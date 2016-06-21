# 
# Recipies must be tabbed!!!
#
# target: prerequisites
#	recipe
#	…
#	…

# We need these environment variables

export VD_ENV_WORKSPACE = $(shell pwd)
export VD_ENV_GUEST_IP  = 172.18.161.6
export VD_ENV_HOSTNAME  = devstack-box

export VD_ENV_DEVSTACK_MOUNT = /opt/devstack 
export VD_ENV_STACK_MOUNT    = /opt/stack

export VD_ENV_SSH_CONFIG      = ${HOME}/.ssh/config
export VD_ENV_SSH_KNOWN_HOSTS = ${HOME}/.ssh/known_hosts
export VD_ENV_DEFAULT_RSA_KEY = ${HOME}/.ssh/id_rsa.pub

# Goals we want our makefile to manage

all:
	ansible-playbook -v ./plays/pre-provision.yml
	vagrant up
	ansible-playbook -v ./plays/post-provision.yml

retry:
	ansible-playbook -v ./plays/pre-provision.yml 
	vagrant reload
	vagrant provision
	ansible-playbook -v ./plays/post-provision.yml

provision:
	ansible-playbook -v ./plays/pre-provision.yml 
	vagrant provision
	ansible-playbook -v ./plays/post-provision.yml

clean:
	vagrant destroy
	ansible-playbook -v ./plays/clean-up.yml