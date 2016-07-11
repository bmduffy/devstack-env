FROM c7systemd

MAINTAINER Brian Duffy brian.duffy@ammeon.com

# copy necessary files to the image

RUN mkdir -p /opt/setup

COPY ./plays/devstack.yml /opt/setup

RUN ansible-playbook -v /opt/setup/devstack.yml

EXPOSE 80 443 8000 8080

VOLUME [ "/opt" ]

CMD ["/usr/sbin/init"]
