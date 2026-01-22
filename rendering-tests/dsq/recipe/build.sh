#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

go build -o=${PREFIX}/bin/${PKG_NAME} -ldflags="-s -w -X main.Version=${PKG_VERSION}"
go-licenses save . --save_path=license-files --ignore github.com/multiprocessio/datastation/runner \
    --ignore github.com/apache/arrow \
    --ignore github.com/apache/thrift \
    --ignore github.com/jmespath/go-jmespath \
    --ignore github.com/multiprocessio/dsq \
    --ignore github.com/multiprocessio/go-json \
    --ignore github.com/multiprocessio/go-sqlite3-stdlib

# Manually copy licenses that go-licenses could not download
cp -r ${RECIPE_DIR}/license-files/* ${SRC_DIR}/license-files
