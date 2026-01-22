#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=fat
export OPENSSL_DIR=${PREFIX}
export OPENSSL_NO_VENDOR=1
export PKG_CONFIG_ALLOW_CROSS=1

# check licenses
cargo-bundle-licenses \
    --format yaml \
    --output THIRDPARTY.yml

# build statically linked binary with Rust
export RUSTONIG_SYSTEM_LIBONIG=1
cargo install --bins --no-track --features native-tls --locked --root ${PREFIX} --path .
