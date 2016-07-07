FROM centos:7

MAINTAINER Brian Duffy brian.duffy@ammeon.com

# install ansible and provision the centos container

RUN yum install -y wget
RUN wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-7.noarch.rpm
RUN rpm -i epel-release-7-7.noarch.rpm && yum update  -y
RUN yum install -y net-tools iproute.x86_64 iproute-devel.x86_64
RUN yum install -y vim sudo git gcc openssl-devel python-devel python-pip
RUN pip install --upgrade pip setuptools
RUN pip install ansible

# Fix sudoers file 
RUN sed -i "s/requiretty/\!requiretty/g" /etc/sudoers

# copy necessary files to the image

RUN mkdir -p /opt/setup

COPY plays/devstack.yml /opt/setup

RUN ansible-playbook -v /opt/setup/devstack.yml

EXPOSE 80 443 8000 8080

ENTRYPOINT tail -f /dev/null
