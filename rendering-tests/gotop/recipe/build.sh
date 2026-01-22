#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CGO_CFLAGS="-Wno-undef-prefix"
go build -o=${PREFIX}/bin/${PKG_NAME} -ldflags="-s -w" ./cmd/gotop
go-licenses save ./cmd/gotop --save_path=license-files --ignore github.com/xxxserxxx/gotop
