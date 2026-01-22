#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# Create package archive and install globally
npm pack --ignore-scripts
npm install -ddd \
    --no-bin-links \
    --global \
    --build-from-source \
    ${SRC_DIR}/${PKG_NAME}-${PKG_VERSION}.tgz

mkdir -p ${PREFIX}/bin
tee ${PREFIX}/bin/create-qwik << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/create-qwik/create-qwik.cjs "\$@"
EOF
chmod +x ${PREFIX}/bin/create-qwik

tee ${PREFIX}/bin/create-qwik.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\create-qwik\create-qwik.cjs %*
EOF
