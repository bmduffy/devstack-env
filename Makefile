
# Get system info

export WORKSPACE  = $(shell pwd)
#export CGROUP_VOL = "/sys/fs/cgroup:/sys/fs/cgroup:ro"
#export RUN_VOL    = "/run:/run:rw"

# May not need this, not sure yet
# export LIB_VOL    = "/lib/modules:/lib/modules:rw"

export DEVSTACK_BASE_DIR  = c7systemd
export DEVSTACK_BASE_IMG  = local/${DEVSTACK_BASE_DIR}
export DEVSTACK_IMG       = local/c7devstack
export DEVSTACK_CONTAINER = devstackenv_master_1
#export DEVSTACK_VOL       = ${WORKSPACE}/src:/opt
#export DEVSTACK_PORT      = 8080:8080

all: env clone build deploy

clone:
	ansible-playbook -v ./plays/setup-host.yml

build:
	ansible-playbook -v ./plays/build.yml

deploy:
	ansible-playbook -v ./plays/deploy.yml

env:
	ansible-playbook -v ./plays/env.yml

reload:
	ansible-playbook -v ./plays/reload.yml
	ansible-playbook -v ./plays/deploy.yml

stack:
	cp local.conf ./src/devstack
	docker exec -it ${DEVSTACK_CONTAINER} /bin/bash /opt/devstack/stack.sh

unstack:
	docker exec -it ${DEVSTACK_CONTAINER} /bin/bash /opt/devstack/unstack.sh

shell:
	docker exec -it ${DEVSTACK_CONTAINER} /bin/bash

clean-repos:
	ansible-playbook -v ./plays/clean-host.yml

clean-docker: 
	ansible-playbook -v ./plays/clean-docker.yml

clean: clean-docker clean-repos
