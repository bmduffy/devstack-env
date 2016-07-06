# 
# Recipies must be tabbed!!!
#
# target: prerequisites
#	recipe
#	…
#	…

# We need these environment variables
export WORKSPACE = $(shell pwd)

IMAGE     = devstack-image
CONTAINER = devstack-container 

# Goals we want our makefile to manage

all: clone build run

clone:
	ansible-playbook -v ./plays/host-setup.yml

run:
	docker run -d -p "127.0.0.1:8080:8080" --name ${CONTAINER} ${IMAGE}

shell:
	docker exec -it ${CONTAINER} /bin/bash

build:
	docker build --no-cache -t ${IMAGE} .

reload:
	docker build -t ${IMAGE} .

stack:
	cp local.conf ./devstack
	docker exec -it ${CONTAINER} /usr/bin/su stack -c "cd /opt/devstack; ./stack.sh"

unstack:
	docker exec -it ${CONTAINER} /usr/bin/su stack -c "cd /opt/devstack; ./unstack.sh"

clean: 
	docker stop   ${CONTAINER}

	ansible-playbook -v ./plays/clean-up.yml

	docker rm  -f ${CONTAINER} $(docker rm $(docker ps -q --filter status=exited)
	docker rmi -f ${IMAGE} $(docker images -q --filter "dangling=true")