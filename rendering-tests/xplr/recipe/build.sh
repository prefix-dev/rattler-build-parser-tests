#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=fat
export LUA_LIB=${PREFIX}/lib
export LUA_LIB_NAME=luajit
export LUA_LINK=dylib

# Symlink hardcoded compiler name for linux-aarch64
# This file will be ignored by other Unix platforms
ln -sf ${CC} ${BUILD_PREFIX}/bin/aarch64-linux-gnu-gcc

# build statically linked binary with Rust
cargo install --no-default-features --bins --no-track --locked --root ${PREFIX} --path .

# check licenses
cargo-bundle-licenses \
    --format yaml \
    --output THIRDPARTY.yml
