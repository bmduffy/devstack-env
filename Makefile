
# Get system info

export WORKSPACE  = $(shell pwd)
export CGROUP_VOL = "/sys/fs/cgroup:/sys/fs/cgroup:ro,Z"

# May not need these, not sure yet
#export RUN_VOL    = "/run:/run:rw,Z"
#export LIB_VOL    = "/lib/modules:/lib/modules:rw,Z"

export DEVSTACK_BASE_DIR  = c7systemd
export DEVSTACK_BASE_IMG  = local/${DEVSTACK_BASE_DIR}
export DEVSTACK_IMG       = local/c7devstack
export DEVSTACK_CONTAINER = devstack-container
export DEVSTACK_VOL       = ${WORKSPACE}/src:/opt
export DEVSTACK_PORT      = 8080:8080


all: env clone build deploy

clone:
	ansible-playbook -v ./plays/setup-host.yml

build:

	docker build -f ${WORKSPACE}/${DEVSTACK_BASE_DIR}/Dockerfile \
				 --no-cache --rm -t ${DEVSTACK_BASE_IMG} ${DEVSTACK_BASE_DIR} 
	
	docker build -f ${WORKSPACE}/Dockerfile \
    			 --no-cache --rm -t ${DEVSTACK_IMG} .

deploy:
	
	docker run -d --privileged --net=host \
               -p ${DEVSTACK_PORT} \
               -v ${CGROUP_VOL} \
               -v ${DEVSTACK_VOL} \
               --name ${DEVSTACK_CONTAINER} ${DEVSTACK_IMG}

env:
	ansible-playbook -v ./plays/env.yml

reload:

	ansible-playbook -v ./plays/reload.yml

	docker build -f ${WORKSPACE}/${DEVSTACK_BASE_DIR}/Dockerfile \
				 --rm -t ${DEVSTACK_BASE_IMG} ${DEVSTACK_BASE_DIR}

	docker build -f ${WORKSPACE}/Dockerfile \
    			 --rm -t ${DEVSTACK_IMG} .

	docker run -d --privileged --net=host \
               -p ${DEVSTACK_PORT} \
               -v ${CGROUP_VOL} \
               -v ${DEVSTACK_VOL} \
               --name ${DEVSTACK_CONTAINER} ${DEVSTACK_IMG}

stack:
	cp local.conf ./src/devstack
	docker exec -u stack -it ${DEVSTACK_CONTAINER} /bin/bash /opt/devstack/stack.sh

unstack:
	docker exec -u stack -it ${DEVSTACK_CONTAINER} /bin/bash /opt/devstack/unstack.sh

shell:
	docker exec -u stack -it ${DEVSTACK_CONTAINER} /bin/bash

clean-repos:
	ansible-playbook -v ./plays/clean-host.yml

clean-docker: 
	ansible-playbook -v ./plays/clean-docker.yml

clean: clean-docker clean-repos
