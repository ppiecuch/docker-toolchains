FROM debian:buster-slim

MAINTAINER Pawel Piecuch <piecuch.pawel@gmail.com>

LABEL description="Retro Device development toolchain"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y --no-install-recommends apt-utils locales sudo zip unzip bzip2 less bsdtar curl wget xz-utils scons pkg-config nano make cmake git git-restore-mtime gnupg ca-certificates  pkg-config doxygen gdebi-core \
  && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && dpkg-reconfigure --frontend=noninteractive locales \
  && update-locale LANG=en_US.UTF-8 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && if [ ! -e /etc/mtab ]; then sudo ln -s /proc/self/mounts /etc/mtab; fi

RUN python -c "import sys; print(sys.version)" \
 && python --version \
 && scons --version

# PSVITA SDK
# ----------
ENV VITASDK=/opt/vitasdk
ENV PATH="${VITASDK}:${PATH}"

RUN git clone --depth=1 https://github.com/vitasdk/vdpm \
    && cd vdpm \
    && ./bootstrap-vitasdk.sh \
    && ./install-all.sh \
    && echo "Using gcc/toolchain version $(arm-vita-eabi-gcc --version)"

# 3DS/DEVKIT SDK
# --------------
ENV LANG en_US.UTF-8

ENV DEVKITPRO=/opt/devkitpro
ENV DEVKITARM=${DEVKITPRO}/devkitARM
ENV PATH=${DEVKITPRO}/tools/bin:${PATH}
ENV CTRULIB=${DEVKITPRO}/libctru

RUN wget https://github.com/devkitPro/pacman/releases/latest/download/devkitpro-pacman.amd64.deb && \
    gdebi -n devkitpro-pacman.amd64.deb && \
    rm devkitpro-pacman.amd64.deb && \
    dkp-pacman -Scc --noconfirm

RUN dkp-pacman -Syyu --noconfirm 3ds-dev nds-dev gp32-dev gba-dev gp2x-dev && \
    dkp-pacman -S --needed --noconfirm 3ds-portlibs nds-portlibs armv4t-portlibs && \
    dkp-pacman -Scc --noconfirm

VOLUME ["/app"]
WORKDIR /app/

CMD ["uname", "-a"]
