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
tee ${PREFIX}/bin/refine << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/@refinedev/cli/dist/cli.cjs "\$@"
EOF
chmod +x ${PREFIX}/bin/refine

tee ${PREFIX}/bin/refine.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\@refinedev\cli\dist\cli.cjs %*
EOF
