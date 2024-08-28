#!/bin/bash

# Exit on error
set -e

docker run --rm \
           -it \
           --privileged \
           --cap-add=ALL \
           -v "$PWD/ansible/sites:/workdir:rw" \
           --name ansible-production\
           ansible-production \
           /bin/bash

