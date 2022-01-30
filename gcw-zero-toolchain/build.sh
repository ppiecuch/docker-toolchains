#!/bin/bash

set -e

# Original GCW0 toolchain:
# http://www.gcw-zero.com/files/opendingux-gcw0-toolchain.2014-08-20.tar.bz2

version=2021-03-10
toolchain=http://od.abstraction.se/opendingux/toolchain/opendingux-gcw0-toolchain.$version.tar.xz

docker build --build-arg version=$version --build-arg toolchain=$toolchain -t gcw_zero_dev:$version .

# docker run --rm -t -v $PWD:/app gcw_zero_dev
