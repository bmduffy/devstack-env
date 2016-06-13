#!/bin/bash

echo "provisioning..."

IP_RANGE="172.18.161.*"

HOST_IP="172.18.161.6"

vagrant provision

# post provisioning

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

sshfs ${HOST_IP}:/opt/devstack devstack