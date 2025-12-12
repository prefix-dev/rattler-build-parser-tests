#!/bin/bash

set -exuo pipefail

./configure --prefix=$PREFIX --with-libgcrypt-prefix=$PREFIX || (cat config.log; exit 1)
make -j$CPU_COUNT
make install
