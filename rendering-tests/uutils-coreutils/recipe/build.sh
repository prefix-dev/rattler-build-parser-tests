#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml

if [[ "$(uname)" == "Linux" ]]; then
    export LIBCLANG_PATH=$BUILD_PREFIX/lib
fi

export -n CARGO_BUILD_TARGET # https://github.com/uutils/coreutils/issues/9206
make PROFILE=release MULTICALL=y PREFIX="${PREFIX}" install
