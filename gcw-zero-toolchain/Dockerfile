FROM amd64/ubuntu:bionic

MAINTAINER Pawel Piecuch <piecuch.pawel@gmail.com>

ARG version
ARG toolchain

LABEL version=$version
LABEL description="GCW Zero development toolchain"

RUN mkdir -p /opt

RUN apt-get update \
  && apt-get install -y bzip2 xz-utils less curl scons libx11-dev nano make ca-certificates \
  && apt-get autoclean \
  && rm -rf /var/lib/apt/lists/* \
  && echo "*** Fetching toolchain $version ..." \
  && cd /opt \
  && curl -sL $toolchain | tar xJ

ENV CROSS=/opt/gcw0-toolchain/usr/bin
ENV PATH=${CROSS}:$PATH

VOLUME ["/app"]
WORKDIR /app/

CMD ["uname", "-a"]
