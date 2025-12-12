#!/usr/bin/env bash
set -eux -o pipefail

GOPATH="$( pwd )"
export GOPATH
export GOROOT="${BUILD_PREFIX}/go"

cd "src/github.com/ipfs/kubo"

go build \
    -o "${PREFIX}/bin/ipfs" \
    ./cmd/ipfs \
    || exit 2

go-licenses save ./cmd/ipfs \
    --save_path "${SRC_DIR}/library_licenses" \
    --ignore=bazil.org/fuse \
    || exit 3
