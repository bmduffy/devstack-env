FROM centos:7

MAINTAINER Brian Duffy bmduffy@gmail.com

# install ansible and provision the centos container

RUN yum install -y wget
RUN wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-7.noarch.rpm
RUN rpm -i epel-release-7-7.noarch.rpm && yum update  -y
RUN yum install -y vim git net-tools sudo gcc openssl-devel python-devel python-pip
RUN pip install --upgrade pip setuptools
RUN pip install ansible

# Fix sudoers file 
RUN sed -i "s/requiretty/\!requiretty/g" /etc/sudoers

# copy necessary files to the image

RUN mkdir -p /opt/setup

COPY plays/devstack.yml /opt/setup

RUN ansible-playbook -v /opt/setup/devstack.yml

ADD ./src      /opt/stack 
ADD ./devstack /opt/devstack

EXPOSE 80 443 8000 8080

ENTRYPOINT tail -f /dev/null
