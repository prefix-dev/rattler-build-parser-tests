#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# Create package archive and install globally
npm pack --ignore-scripts
npm install -ddd \
    --no-bin-links \
    --global \
    --build-from-source \
    ${SRC_DIR}/astrojs-language-server-${PKG_VERSION}.tgz

# Patch package.json to remove devDependencies key so that
# pnpm-licenses can be run to create license report
mv package.json package.json.bak
jq 'del(.devDependencies)' package.json.bak > package.json

# Create license report for dependencies
pnpm install
pnpm-licenses generate-disclaimer --prod --output-file=${SRC_DIR}/third-party-licenses.txt

mkdir -p ${PREFIX}/bin
tee ${PREFIX}/bin/astro-ls << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/@astrojs/language-server/bin/nodeServer.js "\$@"
EOF
chmod +x ${PREFIX}/bin/astro-ls

tee ${PREFIX}/bin/astro-ls.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\@astrojs\language-server\bin\nodeServer.js %*
EOF

rm -rf ${PREFIX}/lib/node_modules/@emmetio
