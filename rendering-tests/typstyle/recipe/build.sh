#!/usr/bin/env bash

set -euxo pipefail

export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=fat

pushd crates/typstyle

cargo install --no-track --locked --root "$PREFIX" --path .
cargo-bundle-licenses \
    --format yaml \
    --output THIRDPARTY_LICENSES.yaml
