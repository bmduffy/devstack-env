# Take a look the official docker registry for Centos
#
# https://hub.docker.com/_/centos/
# 
# This docker file will build an image for Centos
# that has systemd enabled and a few other things

FROM centos:7
MAINTAINER "Brian Duffy" <brian.duffy@ammeon.com>

ENV container docker

# want docs for packages

RUN sed -i "s/tsflags=nodocs/#tsflags=nodocs/g" /etc/yum.conf

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

# install software

RUN yum install -y wget
RUN wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-7.noarch.rpm
RUN rpm -i epel-release-7-7.noarch.rpm && yum update  -y
RUN yum install -y net-tools iproute.x86_64 iproute-devel.x86_64
RUN yum install -y vim sudo git gcc openssl-devel python-devel python-pip
RUN pip install --upgrade pip setuptools
RUN pip install ansible

# Fix sudoers file 

RUN sed -i "s/requiretty/\!requiretty/g" /etc/sudoers

VOLUME [ "/sys/fs/cgroup", "/tmp", "/run", "/lib/modules" ]

CMD ["/usr/sbin/init"]
