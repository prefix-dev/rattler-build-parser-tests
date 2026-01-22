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
tee ${PREFIX}/bin/knip << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/knip/bin/knip.js "\$@"
EOF
chmod +x ${PREFIX}/bin/knip

tee ${PREFIX}/bin/knip-bun << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/knip/bin/knip-bun.js "\$@"
EOF
chmod +x ${PREFIX}/bin/knip-bun

tee ${PREFIX}/bin/knip.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\knip\bin\knip.js %*
EOF

tee ${PREFIX}/bin/knip-bun.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\knip\bin\knip-bun.js %*
EOF
