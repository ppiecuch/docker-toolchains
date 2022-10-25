FROM amd64/ubuntu:20.04

MAINTAINER Pawel Piecuch <piecuch.pawel@gmail.com>

ARG version
ARG toolchain

LABEL version=$version
LABEL description="AmberELEC development toolchain for Godot"

USER root
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y apt-utils \
  && dpkg-reconfigure apt-utils \
  && apt-get install -y \
    ca-certificates \
    bzip2 unzip \
    wget curl \
    automake \
    cmake \
    curl \
    fakeroot \
    git \
    make \
    runit \
    scons \
    sudo \
    xz-utils \
    dos2unix \
    micro \
    rsync \
  && apt-get autoclean \
  && rm -rf /var/lib/apt/lists/*

# Here is where we hardcode the toolchain decision.
ENV HOST=aarch64-libreelec-linux-gnueabi
ENV QEMU=/usr/bin/qemu-aarch64-static
ENV ELECROOT=/work/build.AmberELEC-GENERIC.aarch64/toolchain
ENV SYSROOT=$ELECROOT/$HOST/sysroot
ENV PATH=$ELECROOT/bin:$PATH
ENV PKG_CONFIG_BIN=$ELECROOT/bin/aarch64-libreelec-linux-gnueabi-pkg-config

RUN mkdir -p /work/ /root/.config/gdrive/

COPY gdrive_linux_amd64 /work/gdrive
COPY USERNAME_v2.json /root/.config/gdrive/

RUN cd /work \
  # download toolchain
  && ./gdrive about \
  && ./gdrive info "$toolchain" \
  && mkdir toolchain-download \
  && ./gdrive download --path toolchain-download "$toolchain" \
  && unzip -q toolchain-download/*.zip && rm -rf toolchain-download \
  # download qemu
  && curl -Ls https://github.com/balena-io/qemu/releases/download/v5.2.0%2Bbalena4/qemu-5.2.0.balena4-aarch64.tar.gz | tar --strip-components 1 -C $SYSROOT/usr/bin/ -xzf - \
  && chmod +x $SYSROOT/$QEMU \
  && rsync -arDH /dev/ $SYSROOT/dev && ls $SYSROOT/dev \
  # build pkg-config
  && echo "#!/bin/bash" > $PKG_CONFIG_BIN \
  && echo "PKG_CONFIG_DIR= PKG_CONFIG_PATH= PKG_CONFIG_LIBDIR=$SYSROOT/usr/lib/pkgconfig $ELECROOT/bin/pkg-config \"\$@\"" >> $PKG_CONFIG_BIN \
  && chmod +x $PKG_CONFIG_BIN


VOLUME ["/app"]
WORKDIR /app/

CMD ["uname", "-a"]
