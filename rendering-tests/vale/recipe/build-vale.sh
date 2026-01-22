#!/usr/bin/env bash
set -eux -o pipefail

GOPATH="$( pwd )"
export GOPATH
cd src/github.com/errata-ai/vale

go build \
    -ldflags "-s -w -X main.version=${PKG_VERSION}" \
    -o "${PREFIX}/bin/vale" \
    "./cmd/vale" \
    || exit 2

go-licenses save ./cmd/vale --save_path "${SRC_DIR}/license-files" \
    --ignore=github.com/jdkato/go-tree-sitter-julia/julia \
    --ignore=github.com/xi2/xz \
    || exit 3
