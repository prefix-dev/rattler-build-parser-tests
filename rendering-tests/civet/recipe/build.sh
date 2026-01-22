#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# Create package archive and install globally
npm pack --ignore-scripts
npm install -ddd \
    --no-bin-links \
    --global \
    --build-from-source \
    ${SRC_DIR}/danielx-${PKG_NAME}-${PKG_VERSION}.tgz

# Create license report for dependencies
mv package.json package.json.bak
jq 'del(.packageManager)' package.json.bak > package.json
pnpm install
pnpm-licenses generate-disclaimer --prod --output-file=third-party-licenses.txt

mkdir -p ${PREFIX}/bin
tee ${PREFIX}/bin/civet << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/@danielx/civet/dist/civet "\$@"
EOF
chmod +x ${PREFIX}/bin/civet

tee ${PREFIX}/bin/civet.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\@danielx\civet\dist\civet %*
EOF
