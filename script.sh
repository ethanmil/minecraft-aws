#!/bin/bash

# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

# install ansible
apt-get update
apt-get -y install ansible

# run ansible playbook to download minecraft
ansible-playbook /tmp/minecraft.yml