#!/bin/bash

# Start libvirt
start-libvirt

if [ -d "/root/.vagrant.d/boxes/trusty64" ]
then
	echo "image already exists"
else
	# Prepare images and Vagrant configuration files
	cd /git/bento/
	packer build -only qemu -var "headless=true" ubuntu-14.04-amd64.json
	vagrant box add builds/ubuntu-14.04.libvirt.box --name "trusty64"
fi

# Start stuff
cd /
vagrant up --provider=libvirt

# generate ssh config file
vagrant ssh-config > ~/.ssh/config

# prepare the hosts file
HOSTNAMELIST=($(grep "Host " ~/.ssh/config | cut -d' ' -f2))
IPLIST=($(grep "HostName" ~/.ssh/config | cut -d' ' -f4))

if [ -f "/etc/hosts.backup" ]
then
	# reset the hosts file
	cp "/etc/hosts.backup" "/etc/hosts"
else
	# backup the hosts file
	cp "/etc/hosts" "/etc/hosts.backup"
fi

for ((i=0;i<${#IPLIST[@]};++i));
do
	echo "${HOSTNAMELIST[i]}"
	echo "${IPLIST[i]} ${HOSTNAMELIST[i]}" >> /etc/hosts
done
