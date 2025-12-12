#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=fat

# check licenses
cargo-bundle-licenses \
    --format yaml \
    --output THIRDPARTY.yml

# build statically linked binary with Rust
cargo install --bins --no-track --locked --root ${PREFIX} --path pueue

if [[ ${build_platform} == ${target_platform} ]]; then
    mkdir -p ${PREFIX}/share/fish/vendor_completions.d
    mkdir -p ${PREFIX}/share/zsh/site-functions
    pueue completions fish .
    pueue completions zsh .
    install -m 644 pueue.fish ${PREFIX}/share/fish/vendor_completions.d/pueue.fish
    install -m 644 _pueue ${PREFIX}/share/zsh/site-functions/_pueue
fi
