#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

go build -o=${PREFIX}/bin/${PKG_NAME} -ldflags="-s -w" cli/main.go
go-licenses save ./cli --save_path=license-files --ignore github.com/inconshreveable/go-update

# Manually copy licenses that go-licenses could not download
cp -r ${RECIPE_DIR}/license-files/* ${SRC_DIR}/license-files
