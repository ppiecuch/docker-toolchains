#!/bin/bash

: ${RPXC_IMAGE:=sdthirlwall/raspberry-pi-cross-compiler}

docker build --force-rm -t $RPXC_IMAGE .  | tee build.log
