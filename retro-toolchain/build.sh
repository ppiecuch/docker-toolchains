#!/bin/bash

set -e

# eg.: ./build --progress=plain

version="latest"
docker build $* --platform=linux/amd64 -t retro_dev_2023:$version .
