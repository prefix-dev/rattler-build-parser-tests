#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export RUST_BACKTRACE=1
export OPENSSL_DIR="${PREFIX}"
export CARGO_PROFILE_RELEASE_STRIP=symbols

# build statically linked binary with Rust
cargo install \
    --locked \
    --root "${PREFIX}" \
    --path crates/taplo-cli \
    --no-track \
    --features lsp,rustls-tls

cargo-bundle-licenses \
    --format yaml \
    --output "${SRC_DIR}/THIRDPARTY.yml"
