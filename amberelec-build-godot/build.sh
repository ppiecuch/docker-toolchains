#!/bin/bash

set -e

version=2022-10-20
toolchain=1lwb-EHXE2WG5UpydcJsakwS5EBma5Klp

# toolchain:
# ----------
# AmberELEC-GENERIC.aarch64.zip
#  - https://drive.google.com/file/d/1lwb-EHXE2WG5UpydcJsakwS5EBma5Klp

docker build $* --build-arg version=$version --build-arg toolchain=$toolchain --build-arg token_file=$token_file -t amberelec-build-godot:$version .

echo "***"
echo "*** Image amberelec-build-godot:$version is ready."
