#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# Create package archive and install globally
npm pack --ignore-scripts
npm install -ddd \
    --no-bin-links \
    --global \
    --build-from-source \
    ${SRC_DIR}/${PKG_NAME}-core-${PKG_VERSION}.tgz

# Create license report for dependencies
pnpm install
pnpm-licenses generate-disclaimer --prod --output-file=${SRC_DIR}/third-party-licenses.txt

mkdir -p ${PREFIX}/bin
tee ${PREFIX}/bin/docusaurus << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/@docusaurus/core/bin/docusaurus.mjs "\$@"
EOF
chmod +x ${PREFIX}/bin/docusaurus

tee ${PREFIX}/bin/docusaurus.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\@docusaurus\core\bin\docusaurus.mjs %*
EOF
