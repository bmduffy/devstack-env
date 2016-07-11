FROM c7systemd

MAINTAINER Brian Duffy brian.duffy@ammeon.com

WORKDIR /opt/

# copy necessary files to the image

RUN mkdir -p /tmp/setup

COPY ./plays/devstack.yml /tmp/setup
COPY ./scripts/env.sh     /tmp/setup

RUN ansible-playbook -v /tmp/setup/devstack.yml

EXPOSE 80 443 8000 8080

VOLUME [ "/opt" ]

ENTRYPOINT tail -f /dev/null
