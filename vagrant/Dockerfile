FROM ubuntu:16.04

ENV VAGRANTVERSION 1.9.1

ENV DEBIAN_FRONTEND noninteractive

ENV ANSIBLE_HOST_KEY_CHECKING=False

# add ansible repo
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt-add-repository ppa:ansible/ansible

# update after adding repository
RUN apt-get update

# install ansible and tools
RUN apt-get install -y python
RUN apt-get install -y vim
RUN apt-get install -y openssl
RUN apt-get install -y libssl-dev
RUN apt-get install -y libffi-dev
RUN apt-get install -y python-pip python-dev build-essential
RUN apt-get install -y inetutils-ping
RUN apt-get install -y ansible

# install vagrant/libvirt and tools
RUN apt-get update
RUN apt-get install -y wget
RUN apt-get install -y qemu
RUN apt-get install -y qemu-kvm
RUN apt-get install -y libvirt-bin
RUN apt-get install -y ebtables
RUN apt-get install -y dnsmasq
RUN apt-get install -y libxslt-dev
RUN apt-get install -y libxml2-dev
RUN apt-get install -y libvirt-dev
RUN apt-get install -y zlib1g-dev
RUN apt-get install -y ruby-dev
RUN apt-get install -y ssh
RUN apt-get install -y openssh-client
RUN apt-get install -y git
RUN apt-get install -y make
RUN apt-get install -y unzip

RUN cat /dev/zero | ssh-keygen -q -N ""

RUN wget https://releases.hashicorp.com/vagrant/${VAGRANTVERSION}/vagrant_${VAGRANTVERSION}_x86_64.deb
RUN dpkg -i vagrant_${VAGRANTVERSION}_x86_64.deb

RUN vagrant plugin install --plugin-version 0.0.35 vagrant-libvirt

# Install packager
ADD https://releases.hashicorp.com/packer/0.12.1/packer_0.12.1_linux_amd64.zip /tmp/
RUN unzip /tmp/packer_0.12.1_linux_amd64.zip -d /usr/local/bin

# Templates for Vagrant configuration files
RUN mkdir -p /git && \
    cd /git && \
    git clone https://github.com/chef/bento

COPY start-libvirt /usr/local/bin
RUN chmod 755 /usr/local/bin/start-libvirt
COPY start.sh /
COPY Vagrantfile /
