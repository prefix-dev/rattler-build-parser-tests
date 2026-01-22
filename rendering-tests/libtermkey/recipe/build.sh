#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

make LIBTOOL=${PREFIX}/bin/libtool PREFIX=${PREFIX}
make install LIBTOOL=${PREFIX}/bin/libtool PREFIX=${PREFIX}

rm -f ${PREFIX}/lib/libtermkey.a
