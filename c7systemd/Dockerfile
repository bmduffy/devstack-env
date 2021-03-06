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

# Check for new RPMS  
# http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-X.noarch.rpm 

COPY ./rpms/epel-release-7.8.noarch.rpm /tmp/

RUN rpm -i /tmp/epel-release-7-8.noarch.rpm && \
    yum update -y && \
    yum install -y net-tools iproute.x86_64 iproute-devel.x86_64 vim sudo git gcc openssl-devel python-devel python-pip && \
    pip install --upgrade pip setuptools && \
    pip install ansible

# Fix sudoers file 

RUN sed -i "s/requiretty/\!requiretty/g" /etc/sudoers

VOLUME [ "/sys/fs/cgroup" ] # "/tmp", "/run", "/lib/modules" ]

CMD ["/usr/sbin/init"]
