#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

go build -o=${PREFIX}/bin/jsonnet -ldflags="-s -w" ./cmd/jsonnet
go build -o=${PREFIX}/bin/jsonnetfmt -ldflags="-s -w" ./cmd/jsonnetfmt
go build -o=${PREFIX}/bin/jsonnet-lint -ldflags="-s -w" ./cmd/jsonnet-lint
go build -o=${PREFIX}/bin/jsonnet-deps -ldflags="-s -w" ./cmd/jsonnet-deps
go-licenses save . --save_path=license-files
