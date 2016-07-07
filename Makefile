
export WORKSPACE = $(shell pwd)
export DEVSTKIMG = devstack-image
export CONTAINER = devstack-container

VOL1 = "${WORKSPACE}/src:/opt/stack"
VOL2 = "${WORKSPACE}/devstack:/opt/devstack"
PORT = "127.0.0.1:8080:8080"

all: clone build run

clone:
	ansible-playbook -v ./plays/setup-host.yml

run:
	docker run -d -p ${PORT} -v ${VOL1} -v ${VOL2} --name ${CONTAINER} ${DEVSTKIMG}

shell:
	docker exec -it ${CONTAINER} /bin/bash

build:
	docker build --no-cache -t ${DEVSTKIMG} .

reload:
	docker build -t ${DEVSTKIMG} .

stack:
	cp local.conf ./devstack
	docker exec -i ${CONTAINER} /usr/bin/su stack -c "cd /opt/devstack; ./stack.sh"

unstack:
	docker exec -i ${CONTAINER} /usr/bin/su stack -c "cd /opt/devstack; ./unstack.sh"

clean-all: clean-docker clean-repos

clean-repos:
	ansible-playbook -v ./plays/clean-host.yml

clean-docker: 
	docker stop   ${CONTAINER}
	docker rm  -f ${CONTAINER} $(docker rm $(docker ps -q --filter status=exited)
	docker rmi -f ${DEVSTKIMG} 
	docker rmi -f $(docker images -q --filter "dangling=true")
