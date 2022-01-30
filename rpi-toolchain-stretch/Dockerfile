FROM debian:stretch

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y apt-utils \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure apt-utils \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        automake \
        cmake \
        curl \
        fakeroot \
        g++ \
        git \
        make \
        pkg-config \
        runit \
        scons \
        sudo \
        xz-utils \
        rsync

# Here is where we hardcode the toolchain decision.
ENV HOST=arm-linux-gnueabihf \
    TOOLCHAIN=gcc-linaro-arm-linux-gnueabihf-raspbian-x64 \
    RPXC_ROOT=/rpxc

ENV ARCH=arm \
    CROSS_COMPILE=$RPXC_ROOT/bin/$HOST- \
    PATH=$RPXC_ROOT/bin:$PATH \
    QEMU_PATH=/usr/bin/qemu-arm-static \
    QEMU_EXECVE=1 \
    SYSROOT=$RPXC_ROOT/sysroot

WORKDIR $RPXC_ROOT
RUN curl -L https://github.com/raspberrypi/tools/tarball/master \
    | tar --wildcards --strip-components 3 -xzf - "*/arm-bcm2708/$TOOLCHAIN/"

WORKDIR $SYSROOT

RUN curl -Ls https://github.com/schachr/docker-raspbian-stretch/raw/master/raspbian.image.tar.xz \
    | tar -xJf - \
    && curl -Ls https://github.com/resin-io-projects/armv7hf-debian-qemu/raw/master/bin/qemu-arm-static > $SYSROOT/$QEMU_PATH \
    && chmod +x $SYSROOT/$QEMU_PATH \
    && mkdir -p $SYSROOT/build \
    && rsync -arDH /dev/ $SYSROOT/dev && ls $SYSROOT/dev \
    && echo "deb http://archive.raspbian.org/raspbian stretch firmware" >> $SYSROOT/etc/apt/sources.list \
    && chroot $SYSROOT $QEMU_PATH /bin/sh -c '\
        apt-get update \
        && DEBIAN_FRONTEND=noninteractive apt-get install -y apt-utils \
        && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure apt-utils \
        && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y \
        && DEBIAN_FRONTEND=noninteractive apt-get install -y symlinks libc6-dev libpng-dev libz-dev libgles2-mesa-dev \
        && symlinks -cors /'

# Install BCM firmware
RUN curl -L https://github.com/raspberrypi/firmware/tarball/master \
  | tar --strip-components 1 --directory $SYSROOT --wildcards -xzf - "*/opt/vc"

COPY image/ /

WORKDIR /build
ENTRYPOINT [ "/rpxc/entrypoint.sh" ]
