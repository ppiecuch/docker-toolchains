#!/bin/bash

set -e

# https://wiki.odroid.com/odroid_go_advance/build_kernel
# https://forum.odroid.com/viewtopic.php?f=194&t=37203&sid=168548c64f5624b82893c49e2ed46843&start=50#top
#
# Other toolchains:
# https://github.com/respeaker/toolchains/raw/master/gcc-linaro-6.3.1-2017.05-x86_64_arm-linux-gnueabihf.tar.xz

version=2020-10-01
toolchain=https://releases.linaro.org/components/toolchain/binaries/6.3-2017.05/aarch64-linux-gnu/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu.tar.xz
root=ubuntu-18.04-4.4-es.tar.gz

docker build --build-arg version=$version --build-arg toolchain=$toolchain --build-arg root=$root -t odroid_dev:$version .

echo "***"
echo "*** Image odroid_dev:$version ready."

# docker run --rm -t -v $PWD:/app odroid_dev
# docker run --rm -ti -v $PWD:/app odroid_dev bash
