#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

unset STRIP
make AMALGAMATED=1 CFLAGS="${CFLAGS} -D_BSD_SOURCE"
make install PREFIX=${PREFIX} CFLAGS="${CFLAGS} -D_BSD_SOURCE"
