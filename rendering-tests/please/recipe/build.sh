#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

go build -o=${PREFIX}/bin/plz -ldflags="-s -w" ./src/please.go
ln -sf ./src/please.go
go-licenses save . --save_path=license-files
