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
    
    echo "Deleted host from known hosts ..."
else 
    echo "No entry for '${VAGRANT_DEVSTACK_HOSTNAME}' found ... "
fi

if mount | grep -q ${VAGRANT_DEVSTACK_MOUNT}; then
    echo "Unmounting ${VAGRANT_DEVSTACK_MOUNT} ..."
    fusermount -u ./devstack
fi
