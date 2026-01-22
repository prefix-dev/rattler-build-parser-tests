#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# Create package archive and install globally
npm pack --ignore-scripts
npm install -ddd \
    --no-bin-links \
    --global \
    --build-from-source \
    ${SRC_DIR}/${PKG_NAME}-${PKG_VERSION}.tgz

# Patch package.json to remove packageManager key so that
# pnpm-licenses can be run to create license report
mv package.json package.json.bak
jq 'del(.packageManager)' package.json.bak > package.json

# Create license report for dependencies
pnpm install
pnpm-licenses generate-disclaimer --prod --output-file=third-party-licenses.txt

mkdir -p ${PREFIX}/bin
tee ${PREFIX}/bin/cmake-js << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/cmake-js/bin/cmake-js "\$@"
EOF
chmod +x ${PREFIX}/bin/cmake-js

tee ${PREFIX}/bin/cmake-js.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\cmake-js\bin\cmake-js %*
EOF
