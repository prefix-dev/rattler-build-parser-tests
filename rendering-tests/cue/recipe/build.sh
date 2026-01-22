#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

go build -o=${PREFIX}/bin/${PKG_NAME} -ldflags="-s -w" ./cmd/cue
go-licenses save ./cmd/cue --save_path=license-files
