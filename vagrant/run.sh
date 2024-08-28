#!/bin/bash

docker rm -f vagrant
docker rmi -f vagrant

# Exit on error
set -e

#sudo aa-disable /usr/sbin/libvirtd

docker build -t vagrant .
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_GREEN=$ESC_SEQ"32;01m"
echo -e "$COL_GREEN run 'bash start.sh' to start the vagrant cluster $COL_RESET"
docker run --rm -it --privileged --cap-add=ALL --device /dev/kvm:/dev/kvm:rw -v boxes:/root/.vagrant.d/boxes:rw --name vagrant vagrant /bin/bash

