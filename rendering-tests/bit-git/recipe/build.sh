#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

go build -o=${PREFIX}/bin/${PKG_NAME} -ldflags="-s -w -X main.version=v${PKG_VERSION}"
go-licenses save . --save_path=license-files --ignore github.com/tj/go-update

# Manually copy licenses that go-licenses could not download
cp -r ${RECIPE_DIR}/license-files/* ${SRC_DIR}/license-files
