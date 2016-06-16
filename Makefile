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

all:
	echo "this is a tests ${VDE_WORKSPACE}"

install:
	echo "this will execute a script to install everything you need"
	echo "it will also create the env file"

environment:
	echo "this will run with vagrant up"
	ansible-playbook plays/pre-provision.yml
	ansible-playbook plays/post-provision.yml

stack:
	echo "ssh -t devstack-box bash /opt/devstack/stack.sh"

unstack:
	echo "ssh -t devstack-box bash /opt/devstack/unstack.sh"

clean:
	echo "clean up mess"