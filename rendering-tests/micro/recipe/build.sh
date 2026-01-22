#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

make
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR:-}" != "" ]]; then
make test
fi

go-licenses save "${SRC_DIR}/cmd/micro" --save_path=license-files
mkdir -p ${PREFIX}/bin
install -m 755 micro ${PREFIX}/bin
