#!/bin/bash

# Exit on error
set -e

#sudo aa-disable /usr/sbin/libvirtd

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_GREEN=$ESC_SEQ"32;01m"
echo -e "$COL_GREEN run 'bash /start.sh' to start the vagrant cluster $COL_RESET"
docker run --rm \
           -it \
           --privileged \
           --cap-add=ALL \
           --device /dev/kvm:/dev/kvm:rw \
           -v "boxes:/root/.vagrant.d/boxes:rw" \
           -v "$SCRIPTDIR/sites:/workdir:rw" \
           -v "$SCRIPTDIR/vagrant/ansible-hosts:/etc/ansible/hosts:rw" \
           --name $USER-ansible-vagrant-staging \
           $USER/vagrant-staging \
           /bin/bash

