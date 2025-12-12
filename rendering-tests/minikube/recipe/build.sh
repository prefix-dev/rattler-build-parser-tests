#!/bin/env bash

set -euxo pipefail

make

mkdir -p $PREFIX/bin

mv out/minikube $PREFIX/bin

go-licenses save $SRC_DIR/cmd/minikube --save_path="./license-files/"
