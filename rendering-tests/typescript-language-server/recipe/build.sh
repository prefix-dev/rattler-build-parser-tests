#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# Patch package.json to skip unnecesary prepare step
mv package.json package.json.bak
jq 'del(.scripts.prepare)' package.json.bak > package.json

npm pack --ignore-scripts
npm install -ddd \
    --no-bin-links \
    --global \
    --build-from-source \
    ${SRC_DIR}/${PKG_NAME}-${PKG_VERSION}.tgz

mkdir -p ${PREFIX}/bin
tee ${PREFIX}/bin/typescript-language-server << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/typescript-language-server/lib/cli.mjs "\$@"
EOF
chmod +x ${PREFIX}/bin/typescript-language-server

tee ${PREFIX}/bin/typescript-language-server.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\typescript-language-server\lib\cli.mjs %*
EOF
