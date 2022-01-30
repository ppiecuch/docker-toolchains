#!/bin/bash

set -e

version="latest"
docker build -t retro_dev:$version .
