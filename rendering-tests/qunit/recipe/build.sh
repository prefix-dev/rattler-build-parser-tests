#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# Create package archive and install globally
npm pack --ignore-scripts
npm install -ddd \
    --no-bin-links \
    --global \
    --build-from-source \
    ${SRC_DIR}/${PKG_NAME}-${PKG_VERSION}.tgz

# Patch package.json to remove devDependencies key so that
# pnpm-licenses can be run to create license report
mv package.json package.json.bak
jq 'del(.devDependencies)' package.json.bak > package.json

# Create license report for dependencies
pnpm install --ignore-scripts
pnpm-licenses generate-disclaimer --prod --output-file=third-party-licenses.txt

mkdir -p ${PREFIX}/bin
tee ${PREFIX}/bin/qunit << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/qunit/bin/qunit.js "\$@"
EOF
chmod +x ${PREFIX}/bin/qunit

tee ${PREFIX}/bin/qunit.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\qunit\bin\qunit.js %*
EOF
