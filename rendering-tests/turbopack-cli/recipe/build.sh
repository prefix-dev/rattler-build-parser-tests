#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CARGO_PROFILE_RELEASE_STRIP=symbols
if [[ ${target_platform} =~ .*linux.* ]]; then
    export CARGO_PROFILE_RELEASE_LTO=thin
else
    export CARGO_PROFILE_RELEASE_LTO=fat
fi
export RUSTC_BOOTSTRAP=1
export OPENSSL_DIR=${PREFIX}
export OPENSSL_NO_VENDOR=1

cargo-bundle-licenses \
    --format yaml \
    --output THIRDPARTY.yml

# build statically linked binary with Rust
cargo install --bins --no-track --locked --root ${PREFIX} --path turbopack/crates/turbopack-cli
