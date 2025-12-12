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
pnpm install
pnpm-licenses generate-disclaimer --prod --output-file=third-party-licenses.txt

mkdir -p ${PREFIX}/bin
tee ${PREFIX}/bin/lint-staged << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/lint-staged/bin/lint-staged.js "\$@"
EOF
chmod +x ${PREFIX}/bin/lint-staged

tee ${PREFIX}/bin/lint-staged.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\lint-staged\bin\lint-staged.js %*
EOF
