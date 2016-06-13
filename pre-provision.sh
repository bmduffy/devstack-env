#!/bin/bash

echo "running pre provisioning..."

export VAGRANT_DEVSTACK_HOST_IP="172.18.161.6"

echo "${VAGRANT_DEVSTACK_HOST_IP}  devstack" >> /etc/hosts