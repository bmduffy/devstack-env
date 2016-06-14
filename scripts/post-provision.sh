#!/bin/bash

echo "running post provisioning ..."

SSH_CONFIG="${HOME}/.ssh/config"
RSA_KEY="${HOME}/.ssh/id_rsa.pub"
DEVSTACK_BOX_MOUNT="devstack-box:/opt/devstack"
DEVSTACK_HOST="devstack-box"
HOST_ENTRY=$(cat ssh.cfg)

mkdir -p ./devstack

if rpm -qa | grep -q sshfs; then
    echo "sshfs already installed ..."
else
    echo "installing sshfs ..."
    sudo yum install -y sshfs
fi

if grep -q ${DEVSTACK_HOST} ${SSH_CONFIG}; then
    echo "ssh configured with vagrant user ..." 
else
    echo "configuring ssh with vagrant user ..."
    echo "${HOST_ENTRY}" >> ${SSH_CONFIG}
    ssh-copy-id -i ${RSA_KEY} ${DEVSTACK_HOST}
    sshpass "pass" ssh ${DEVSTACK_HOST}
fi

sshfs ${DEVSTACK_BOX_MOUNT} devstack