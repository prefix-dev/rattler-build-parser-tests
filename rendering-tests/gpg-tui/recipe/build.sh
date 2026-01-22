#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=fat
export PKG_CONFIG_ALLOW_CROSS=1

# check licenses
cargo-bundle-licenses \
    --format yaml \
    --output THIRDPARTY.yml

# build statically linked binary with Rust
cargo install --bins --no-track --locked --root ${PREFIX} --path .

if [[ ${build_platform} == ${target_platform} ]]; then
    export OUT_DIR=${SRC_DIR}
    gpg-tui-completions
    mkdir -p ${PREFIX}/etc/bash_completion.d
    mkdir -p ${PREFIX}/share/fish/vendor_completions.d
    mkdir -p ${PREFIX}/share/zsh/site-functions
    install -m 644 ${PKG_NAME}.bash ${PREFIX}/etc/bash_completion.d/${PKG_NAME}
    install -m 644 ${PKG_NAME}.fish ${PREFIX}/share/fish/vendor_completions.d/${PKG_NAME}.fish
    install -m 644 _${PKG_NAME} ${PREFIX}/share/zsh/site-functions/_${PKG_NAME}
fi
