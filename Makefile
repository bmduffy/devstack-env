
# Get system info

export USER_ID   = $(id -u $USER)
export WORKSPACE = $(shell pwd)


export DEVSTACK_BASE_IMG  = c7systemd
export DEVSTACK_IMG       = c7devstack
export DEVSTACK_CONTAINER = devstack-container
export DEVSTACK_VOL       = "${WORKSPACE}/src:/opt"
export DEVSTACK_PORT      = "127.0.0.1:8080:8080"

export CGROUP_VOL   = "/sys/fs/cgroup:/sys/fs/cgroup:ro"
export DEVSTACK_VOL = "${WORKSPACE}/src:/opt"
export DEVSTACK_PORT = "127.0.0.1:8080:8080"

STACK   = "export TERM=xterm; cd /opt/devstack; ./stack.sh"
UNSTACK = "export TERM=xterm; cd /opt/devstack; ./unstack.sh"


all: clone build deploy

clone:
	ansible-playbook -v ./plays/setup-host.yml

build:
	ansible-playbook -v ./plays/build.yml

deploy:
	ansible-playbook -v ./plays/deploy.yml

reload:
	ansible-playbook -v ./plays/reload.yml
	ansible-playbook -v ./plays/deploy.yml

stack:
	cp local.conf ./devstack
	docker exec -i ${DEVSTACK_CONTAINER} /usr/bin/su stack -c ${STACK}

unstack:
	docker exec -i ${DEVSTACK_CONTAINER} /usr/bin/su stack -c ${UNSTACK}

shell:
	docker exec -it ${DEVSTACK_CONTAINER} /bin/bash

clean-repos:
	ansible-playbook -v ./plays/clean-host.yml

clean-docker: 
	ansible-playbook -v ./plays/clean-docker.yml

clean: clean-docker clean-repos