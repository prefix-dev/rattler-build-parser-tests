#!/usr/bin/env bash

set -euo pipefail

export OPENSSL_DIR=$PREFIX
export CARGO_PROFILE_RELEASE_STRIP=symbols

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml
cargo install --no-track --locked --root "$PREFIX" --path .
