#!/bin/bash

set -e

version=2022-10-20
arch=$(uname -p)
if [ $arch == "i386" ] || [ $arch == "x86_64" ]; then
    toolchain=1lwb-EHXE2WG5UpydcJsakwS5EBma5Klp
elif [ $arch == "arm" ] || [ $arch == "aarch64" ]; then
    toolchain=14u9k24KfCyzmn53kgbx7fExTEBHOUeaq
else
    echo "*** Not supportd: $arch"
    exit 1
fi

# toolchain:
# ----------
# AmberELEC-GENERIC.aarch64.zip
#  - https://drive.google.com/file/d/1lwb-EHXE2WG5UpydcJsakwS5EBma5Klp
# AmberELEC-GENERIC.aarch64-host.arm64.zip
#  - https://drive.google.com/file/d/14u9k24KfCyzmn53kgbx7fExTEBHOUeaq

docker build $* --build-arg version=$version --build-arg toolchain=$toolchain --build-arg token_file=$token_file -t amberelec-build-godot:$version .

echo "***"
echo "*** Image amberelec-build-godot:$version is ready."
