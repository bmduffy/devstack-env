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
    
    host=$(grep -n ${VAGRANT_DEVSTACK_HOSTNAME} ${SSH_KNOWN_HOSTS} | awk '{split($0,a,":"); print a[1]}')
    
    if [ -n "${host}" ]; then
        sed -i.bak -e "${host}d" ${SSH_KNOWN_HOSTS}
    else
        echo "'${VAGRANT_DEVSTACK_HOSTNAME}' not a known host ..."
    fi

    ipaddr=$(grep -n ${VAGRANT_DEVSTACK_HOST_IP} ${SSH_KNOWN_HOSTS} | awk '{split($0,a,":"); print a[1]}')
    
    if [ -n "${ipaddr}" ]; then
        sed -i.bak -e "${ipaddr}d" ${SSH_KNOWN_HOSTS}
    else
        echo "'${VAGRANT_DEVSTACK_HOST_IP}' not a known ip ..."
    fi

    sshpass -p "pass" ssh-copy-id -i ${DEFAULT_RSA_KEY} ${VAGRANT_DEVSTACK_HOSTNAME}

    sshfs ${VAGRANT_DEVSTACK_MOUNT} devstack

    echo "Mounted ${VAGRANT_DEVSTACK_MOUNT} ..."
fi