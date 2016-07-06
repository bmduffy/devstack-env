FROM centos:7

MAINTAINER Brian Duffy bmduffy@gmail.com

# install ansible and provision the centos container

RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-7.noarch.rpm
RUN yum update -y
RUN yum install -y gcc openssl-devel python-devel python-pip
RUN pip install --upgrade pip
RUN pip install --upgrade setuptools
RUN pip install ansible

# copy necessary files to the image

RUN mkdir -p /opt/setup
WORKDIR /opt/
COPY plays/devstack.yml  /opt/setup
COPY local.conf          /opt/setup

RUN ansible-playbook -v /opt/setup/devstack.yml

ENTRYPOINT["/bin/bash"]

EXPOSE 80 443 8000 8080
