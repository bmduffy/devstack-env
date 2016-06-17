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

env:
	ansible-playbook -v ./plays/pre-provision.yml
	vagrant up
	ansible-playbook -v ./plays/post-provision.yml

retry:
	ansible-playbook -v ./plays/pre-provision.yml 
	vagrant provision
	ansible-playbook -vvv ./plays/post-provision.yml

stack:
	ssh -t ${VD_ENV_HOSTNAME} bash /opt/devstack/stack.sh

unstack:
	ssh -t ${VD_ENV_HOSTNAME} /opt/devstack/unstack.sh

reconfig:
	scp local.config ${VD_ENV_DEVSTACK_MOUNT}
	unstack
	stack

clean:
	vagrant destroy
	ansible-playbook -v ./plays/clean-up.yml
	rm plays/*.retry