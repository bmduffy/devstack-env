#!/bin/bash

echo "running post provisioning..."

sudo yum install -y sshfs
mkdir -p devstack

SSH_CFG="${HOME}/.ssh/config"
ENTRY=$(cat ssh.cfg)

if grep -q ENTRY ${SSH_CFG}; then
    echo "ssh configured with vagrant user ..." 
else
    echo "configuring ssh with vagrant user ..."
    echo "${ENTRY}" >> ${SSH_CFG}
fi

sshfs ${VAGRANT_DEVSTACK_HOST_IP}:/opt/devstack devstack