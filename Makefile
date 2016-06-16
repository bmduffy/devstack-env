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

export VD_ENV_DEVSTACK_MOUNT = devstack-box:/opt/devstack 
export VD_ENV_STACK_MOUNT    = devstack-box:/opt/stack

export VD_ENV_SSH_CONFIG      = ${HOME}/.ssh/config
export VD_ENV_SSH_KNOWN_HOSTS = ${HOME}/.ssh/known_hosts
export VD_ENV_DEFAULT_RSA_KEY = ${HOME}/.ssh/id_rsa.pub


# Goals we want our makefile to manage

install:
	echo "this will execute a script to install everything you need"

env:
	vagrant up

stack:
	echo "ssh -t ${VD_ENV_HOSTNAME} bash /opt/devstack/stack.sh"

unstack:
	echo "ssh -t ${VD_ENV_HOSTNAME} /opt/devstack/unstack.sh"

reconfig:
	echo "scp "

clean:
	vagrant destroy
	rm plays/*.retry