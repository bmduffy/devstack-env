# Deploy DevStack Environment with Vagrant

## Overview

If you want to contribute to the OpenStack open source project,
deploying DevStack can take time. I've tried to automate this process
for deploying Devstack into a VM with Vagrant with little success.

Now I've been trying to achieve something similar with Docker instead.
How does it work?

1. Create a Docker Image on top of Centos 7 with all required software 
   baked in there and with the stack user set up for you.

2. Run a Container from that Image, this will be your DevStack Environment.

3. Clone the devstack repo, mount it as a volume in the container, mount a 
   second volume where the OpenStack source repos will be cloned to.

4. Stack your OpenStack

## Prerequisites

You will need GNU Make and Ansible installed on your machine. Everything other 
dependency in 

## Use Make to manage your Stack

```
    make           # default 'make all' builds the VM and sets up the host
```