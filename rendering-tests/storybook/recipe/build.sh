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
tee ${PREFIX}/bin/storybook << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/storybook/dist/bin/dispatcher.js "\$@"
EOF
chmod +x ${PREFIX}/bin/storybook

tee ${PREFIX}/bin/storybook.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\storybook\dist\bin\dispatcher.js %*
EOF

# Delete vendored esbuild so package is noarch
rm -rf ${PREFIX}/lib/node_modules/blitz/node_modules/esbuild
rm -rf ${PREFIX}/lib/node_modules/blitz/node_modules/esbuild-linux-64
