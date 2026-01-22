#!/usr/bin/env bash
set -eux

go build \
    -ldflags "-X main.revision=${PKG_VERSION}" \
    -v \
    -o "${PREFIX}/bin/jf" \
    || exit 2

go-licenses save . \
    --ignore "github.com/cyberphone/json-canonicalization" \
    --ignore "github.com/in-toto/attestation" \
    --ignore "github.com/in-toto/in-toto-golang" \
    --ignore "github.com/xi2/xz" \
    --save_path ./library_licenses \
    || exit 3
