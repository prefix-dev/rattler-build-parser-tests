#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# Create package archive and install globally
npm pack --ignore-scripts
npm install -ddd \
    --no-bin-links \
    --global \
    --build-from-source \
    ${SRC_DIR}/${PKG_NAME}-${PKG_VERSION}.tgz

# Create license report for dependencies
mv package.json package.json.bak
jq 'del(.packageManager)' package.json.bak > package.json
pnpm install
pnpm-licenses generate-disclaimer --prod --output-file=third-party-licenses.txt

mkdir -p ${PREFIX}/bin
tee ${PREFIX}/bin/semantic-release << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/semantic-release/bin/semantic-release.js "\$@"
EOF
chmod +x ${PREFIX}/bin/semantic-release

tee ${PREFIX}/bin/semantic-release.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\semantic-release\bin\semantic-release.js %*
EOF
