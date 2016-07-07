
export WORKSPACE = $(shell pwd)
export BASEIMAGE = c7systemd
export DEVSTKIMG = devstack-image
export CONTAINER = devstack-container

VOL0 = "/sys/fs/cgroup:/sys/fs/cgroup:ro"
VOL1 = "${WORKSPACE}/src:/opt/stack"
VOL2 = "${WORKSPACE}/devstack:/opt/devstack"

PORT = "127.0.0.1:8080:8080"

STACK   = "export TERM=xterm; cd /opt/devstack; ./stack.sh"
UNSTACK = "export TERM=xterm; cd /opt/devstack; ./unstack.sh"

all: clone build run

clone:
	sudo ansible-playbook -v ./plays/setup-host.yml

run:
	docker run -d --user stack -p ${PORT} -v ${VOL0} -v ${VOL1} -v ${VOL2} --name ${CONTAINER} ${DEVSTKIMG}

shell:
	docker exec -it ${CONTAINER} /bin/bash

build:
	
	cd ${WORKSPACE}/${BASEIMAGE}
	docker build --no-cache --rm -t ${BASEIMAGE} .

	cd ${WORKSPACE}
	docker build --no-cache --rm -t ${DEVSTKIMG} .

reload:
	docker stop ${CONTAINER}
	docker rm  -f ${CONTAINER}
	docker build -t ${DEVSTKIMG} .
	docker run -d --user stack -p ${PORT} -v ${VOL0} -v ${VOL1} -v ${VOL2} --name ${CONTAINER} ${DEVSTKIMG}

stack:
	cp local.conf ./devstack
	docker exec -i ${CONTAINER} /usr/bin/su stack -c ${STACK}

unstack:
	docker exec -i ${CONTAINER} /usr/bin/su stack -c ${UNSTACK}

clean-all: clean-docker clean-repos

clean-repos:
	ansible-playbook -v ./plays/clean-host.yml

clean-docker: 
	docker stop ${CONTAINER}
	docker rm -f ${CONTAINER} $(docker rm $(docker ps -q --filter status=exited)
	docker rmi -f ${DEVSTKIMG} 
	docker rmi -f ${BASEIMAGE}
	docker rmi -f $(docker images -q --filter "dangling=true")
