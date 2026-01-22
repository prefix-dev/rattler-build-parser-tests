#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

go build -o=${PREFIX}/bin/${PKG_NAME} \
    -ldflags="-s -w -X github.com/homeport/dyff/internal/cmd.version=${PKG_VERSION}" ./cmd/dyff
go-licenses save ./cmd/dyff --save_path=license-files
