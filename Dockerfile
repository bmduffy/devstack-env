FROM local/c7systemd

MAINTAINER Brian Duffy brian.duffy@ammeon.com

ENV TERM xterm
ENV GIT_DISCOVERY_ACROSS_FILESYSTEM 1

WORKDIR /opt/

# copy necessary files to the image

RUN mkdir -p /tmp/setup

COPY ./plays/devstack.yml /tmp/setup/
COPY ./scripts/stack_env.sh  /etc/profile.d/

RUN ansible-playbook -v /tmp/setup/devstack.yml

EXPOSE 80 443 8000 8080

VOLUME [ "/opt" ]

CMD ["/usr/sbin/init"]
