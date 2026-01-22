#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# Create package archive and install globally
npm pack --ignore-scripts
npm install -ddd \
    --no-bin-links \
    --global \
    --build-from-source \
    ${SRC_DIR}/${PKG_NAME}-${PKG_VERSION}.tgz

# Patch package.json to remove devDependencies so that
# pnpm-licenses can be run to generate license report
mv package.json package.json.bak
jq 'del(.devDependencies)' package.json.bak > package.json

# Create license report for dependencies
pnpm install
pnpm-licenses generate-disclaimer --prod --output-file=third-party-licenses.txt

mkdir -p ${PREFIX}/bin
tee ${PREFIX}/bin/blitz << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/blitz/bin/blitz "\$@"
EOF
chmod +x ${PREFIX}/bin/blitz

tee ${PREFIX}/bin/blitz.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\blitz\bin\blitz %*
EOF

# Delete vendored esbuild so package is noarch
rm -rf ${PREFIX}/lib/node_modules/blitz/node_modules/esbuild
rm -rf ${PREFIX}/lib/node_modules/blitz/node_modules/esbuild-linux-64
