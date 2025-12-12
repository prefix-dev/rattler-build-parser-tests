#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=fat
export RUST_BACKTRACE=1
export OPENSSL_DIR=$PREFIX

# build
cargo install --locked \
    --bins \
    --no-track \
    --root "$PREFIX" \
    --path sqlx-cli

cargo-bundle-licenses \
    --format yaml \
    --output "${SRC_DIR}/THIRDPARTY.yml"
