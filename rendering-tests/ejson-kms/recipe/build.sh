#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

go build -o=${PREFIX}/bin/ejson-kms -ldflags="-s -w"
go-licenses save . --save_path=license-files --ignore github.com/jmespath/go-jmespath

# Manually copy licenses that go-licenses could not download
cp -r ${RECIPE_DIR}/license-files/* ${SRC_DIR}/license-files
