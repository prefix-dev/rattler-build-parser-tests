#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# Run pnpm so that pnpm-licenses can create report
mv package.json package.json.bak
jq 'del(.scripts.prepare)' package.json.bak > package.json

# Create package archive and install globally
npm pack --ignore-scripts
npm install -ddd \
    --no-bin-links \
    --global \
    --build-from-source \
    ${SRC_DIR}/${PKG_NAME}-${PKG_VERSION}.tgz

# Create license report for dependencies
pnpm install
pnpm-licenses generate-disclaimer --prod --output-file=third-party-licenses.txt

mkdir -p ${PREFIX}/bin
tee ${PREFIX}/bin/purescript-language-server << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/purescript-language-server/server.js "\$@"
EOF
chmod +x ${PREFIX}/bin/purescript-language-server

tee ${PREFIX}/bin/purescript-language-server.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDAPREFIX%\lib\node_modules\purescript-language-server\server.js %*
EOF
