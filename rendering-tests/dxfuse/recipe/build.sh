#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

go build -buildmode=pie -trimpath -modcacherw -o=${PREFIX}/bin/${PKG_NAME} -ldflags="-s -w" ./cli
go-licenses save ./cli --save_path=license-files --ignore github.com/jacobsa/fuse

# Manually copy licenses that go-licenses could not download
cp -r ${RECIPE_DIR}/license-files/* ${SRC_DIR}/license-files
