#!/bin/bash

source "$(pwd)/.env"

echo "Running post provisioning ..."

mkdir -p ./devstack

if rpm -qa | grep -q sshfs; then
    echo "sshfs already installed ..."
else
    echo "Installing sshfs ..."
    sudo yum install -y sshfs
fi

if grep -q ${VAGRANT_DEVSTACK_HOSTNAME} ${SSH_CONFIG}; then
    echo "ssh configured with vagrant user ..." 
else
    
    echo "Configuring ssh with vagrant user ..."
    echo "${VAGRNAT_DEVSTACK_HOST_ENTRY}" >> ${SSH_CONFIG}
    
    ssh-copy-id -i ${DEFAULT_RSA_KEY} ${VAGRANT_DEVSTACK_HOSTNAME}
    ssh ${VAGRANT_DEVSTACK_HOSTNAME}

    echo "Established ssh connection ..."

    sshfs ${VAGRANT_DEVSTACK_MOUNT} devstack

    echo "Mounted ${VAGRANT_DEVSTACK_MOUNT} ..."
fi