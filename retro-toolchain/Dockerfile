FROM debian:bullseye-slim

MAINTAINER Pawel Piecuch <piecuch.pawel@gmail.com>

LABEL description="Retro Device development toolchain"

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG en_US.UTF-8
ENV BASEPATH $PATH

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  	apt-utils locales sudo zip unzip bzip2 less curl wget xz-utils  gdebi-core \
  	fakeroot pkg-config patch autoconf automake autopoint libtool m4 make cmake \
  	git git-restore-mtime gnupg ca-certificates doxygen texinfo \
  	libarchive-tools libarchive-dev libelf-dev \
  	libcurl4 libcurl4-openssl-dev libncurses5-dev libreadline-dev \
  	libssl-dev libusb-dev libgmp3-dev libmpfr-dev libmpc-dev libgpgme-dev \
  	python3-pip python3-venv openssl bison flex gcc g++ \
  && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && dpkg-reconfigure --frontend=noninteractive locales \
  && update-locale LANG=en_US.UTF-8 \
  && echo "dash dash/sh boolean false" | debconf-set-selections \
  && dpkg-reconfigure --frontend=noninteractive dash \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && if [ ! -e /etc/mtab ]; then ln -s /proc/self/mounts /etc/mtab; fi \
  && groupadd -r user && useradd -m -g user user \
  && for f in pspdev vitasdk devkitpro; do mkdir /opt/$f && chown user:user /opt/$f; done

RUN python3 -c "import sys; print(sys.version)" \
 && python3 --version

USER user
WORKDIR /home/user
RUN ls -ld /opt/* && cd $HOME && pwd

# PSPDEV SDK
# ----------
ENV PSPDEV /opt/pspdev
ENV PATH $PSPDEV/bin:$BASEPATH
RUN echo "LOCAL_PACKAGE_BUILD is $LOCAL_PACKAGE_BUILD" && git clone https://github.com/pspdev/pspdev src && cd src && ./build-all.sh

USER root
RUN pwd && ls -ld *

# PSVITA SDK
# ----------
ENV VITASDK /opt/vitasdk
ENV PATH $VITASDK/bin:$BASEPATH

RUN rm -r $VITASDK \
	&& git clone --depth=1 https://github.com/vitasdk/vdpm \
    && cd vdpm \
    && ./bootstrap-vitasdk.sh \
    && ./install-all.sh \
    && echo "Using gcc/toolchain version $(arm-vita-eabi-gcc --version)"

# 3DS/DEVKIT SDK
# --------------
ENV DEVKITPRO /opt/devkitpro
ENV DEVKITARM $DEVKITPRO/devkitARM
ENV PATH $DEVKITPRO/tools/bin:$BASEPATH
ENV CTRULIB $DEVKITPRO/libctru

# RUN wget https://github.com/devkitPro/pacman/releases/latest/download/devkitpro-pacman.amd64.deb && \
#     gdebi -n devkitpro-pacman.amd64.deb && \
#     rm devkitpro-pacman.amd64.deb && \
#     dkp-pacman -Scc --noconfirm

RUN wget https://apt.devkitpro.org/install-devkitpro-pacman && \
    chmod +x ./install-devkitpro-pacman && \
    ./install-devkitpro-pacman

RUN dkp-pacman -Syyu --noconfirm 3ds-dev nds-dev gp32-dev gba-dev gp2x-dev && \
    dkp-pacman -S --needed --noconfirm 3ds-portlibs nds-portlibs armv4t-portlibs && \
    dkp-pacman -Scc --noconfirm


# Build final image
# -----------------
FROM alpine:latest

ENV LANG en_US.UTF-8

ENV PSPDEV /opt/pspdev
COPY --from=0 ${PSPDEV} ${PSPDEV}

ENV DEVKITPRO /opt/devkitpro
ENV DEVKITARM $DEVKITPRO/devkitARM
ENV CTRULIB $DEVKITPRO/libctru
COPY --from=0 ${DEVKITPRO} ${DEVKITPRO}

ENV VITASDK /opt/vitasdk
COPY --from=0 ${VITASDK} ${VITASDK}

RUN apk add --no-cache scons gmp mpc1 mpfr4 make bash pkgconf

RUN python -c "import sys; print(sys.version)" \
 && python --version \
 && scons --version

VOLUME ["/app"]
WORKDIR /app/

CMD ["uname", "-a"]
