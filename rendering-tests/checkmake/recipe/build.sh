#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

go build -o=${PREFIX}/bin/${PKG_NAME} -ldflags="-s -w -X main.version=${PKG_VERSION}" ./cmd/checkmake
go-licenses save ./cmd/checkmake --save_path=license-files
