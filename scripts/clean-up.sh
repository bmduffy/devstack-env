#!/bin/bash

source "$(pwd)/.env"

echo "Running clean up ..."

if grep -q ${VAGRANT_DEVSTACK_HOSTNAME} ${SSH_CONFIG}; then
    echo "Remove configuration from '${SSH_CONFIG}' ..."
    echo "Host entry '${VAGRANT_DEVSTACK_HOSTNAME}' is present ..."
    
    line=$(grep -n ${VAGRANT_DEVSTACK_HOSTNAME} ${SSH_CONFIG} | awk '{split($0,a,":"); print a[1]}')
    last=$(($line + 3))
    sed -i.bak -e "${line},${last}d" ${SSH_CONFIG}
    
    echo "Deleted host entry from ssh config ..."
    
    line=$(grep -n ${VAGRANT_DEVSTACK_HOSTNAME} ${SSH_KNOWN_HOSTS} | awk '{split($0,a,":"); print a[1]}')
    sed -i.bak -e "${line}d" ${SSH_KNOWN_CONFIG}

    line=$(grep -n ${VAGRANT_DEVSTACK_HOST_IP} ${SSH_KNOWN_HOSTS} | awk '{split($0,a,":"); print a[1]}')
    sed -i.bak -e "${line}d" ${SSH_KNOWN_CONFIG}
    
    echo "Deleted host from known hosts ..."
else 
    echo "No entry for '${VAGRANT_DEVSTACK_HOSTNAME}' found ... "
fi

if mount | grep -q ${VAGRANT_DEVSTACK_MOUNT}; then
    echo "Unmounting ${VAGRANT_DEVSTACK_MOUNT} ..."
    fusermount -u ./devstack
fi
