#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

go build -o=${PREFIX}/bin/${PKG_NAME} -ldflags="-s -w"
go-licenses save . --save_path=license-files \
    --ignore github.com/hashicorp/vault \
    --ignore github.com/aliyun/aliyun-oss-go-sdk \
    --ignore github.com/couchbase/goprotostellar  \
    --ignore github.com/hashicorp/vic/pkg \
    --ignore github.com/apache/thrift/lib
cp -r ${RECIPE_DIR}/license-files/* ${SRC_DIR}/license-files
