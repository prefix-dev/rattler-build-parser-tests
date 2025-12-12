#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=fat
export LIBCLANG_PATH="${BUILD_PREFIX}/lib"

# Add CFLAG here because it cannot be added any other way.
sed -i 's/.define("_DEFAULT_SOURCE", None)/.define("_DEFAULT_SOURCE", None).define("_BSD_SOURCE", None)/' lib/binding_rust/build.rs

# check licenses
cargo-bundle-licenses \
    --format yaml \
    --output THIRDPARTY.yml

# build statically linked binary with Rust
cargo install --bins --no-track --locked --root ${PREFIX} --path crates/cli
