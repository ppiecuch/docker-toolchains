#!/bin/bash

set -e

export RPXC_IMAGE="rpi_toolchain"

docker build -t ${RPXC_IMAGE} .
mkdir -p ./bin
docker run --rm ${RPXC_IMAGE} > ./bin/rpxc
chmod +x ./bin/rpxc
./bin/rpxc -- scons --version
./bin/rpxc -- bash -c 'ls -l /rpxc/sysroot/opt/vc'
echo "Using gcc/toolchain version $(./bin/rpxc -- arm-linux-gnueabihf-gcc --version)"
