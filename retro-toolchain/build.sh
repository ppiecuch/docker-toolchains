#!/bin/bash

set -e

# eg.: ./build --progress=plain

version="latest"
docker build $* -t retro_dev:$version .
