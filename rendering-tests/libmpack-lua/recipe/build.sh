#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

luarocks --tree ${PREFIX} make --lua-dir ${BUILD_PREFIX} --lua-version 5.1 --deps-mode=none --no-manifest CC=${CC} LD=${CC}
