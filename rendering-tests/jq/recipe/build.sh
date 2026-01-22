#!/bin/bash

set -ex

chmod +x configure

./configure --prefix=$PREFIX --with-oniguruma=$PREFIX

make -j${CPU_COUNT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
make check
fi

make install
