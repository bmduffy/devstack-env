#!/bin/bash

echo "Running clean up ..."

DEVSTACK_BOX_MOUNT="devstack-box:/opt/devstack" 

SSH_CONFIG="${HOME}/.ssh/config"
SSH_KNOWN_HOSTS="${HOME}/.ssh/known_hosts"
HOST="devstack-box"

echo "Remove configuration from '${SSH_CONFIG}' ..."

if grep -q ${HOST} ${SSH_CONFIG}; then
    echo "Host entry '${HOST}' is present ..."
    line=$(grep -n ${HOST} ${SSH_CONFIG} | awk '{split($0,a,":"); print a[1]}')
    last=$(($line + 3))
    sed -i.bak -e "${line},${last}d" ${SSH_CONFIG}
    echo "Deleted host entry from ssh config ..."
else 
    echo "No entry for '${HOST}' found ... "
fi

if mount | grep -q ${DEVSTACK_BOX_MOUNT}; then
    echo "Unmounting ${DEVSTACK_BOX_MOUNT} ..."
    fusermount -u ./devstack
fi
