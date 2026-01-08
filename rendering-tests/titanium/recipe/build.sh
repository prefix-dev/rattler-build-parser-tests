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
tee ${PREFIX}/bin/titanium << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/titanium/bin/ti.js "\$@"
EOF
chmod +x ${PREFIX}/bin/titanium

tee ${PREFIX}/bin/ti << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/titanium/bin/ti.js "\$@"
EOF
chmod +x ${PREFIX}/bin/ti

tee ${PREFIX}/bin/titanium.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\titanium\bin\ti.js %*
EOF

tee ${PREFIX}/bin/ti.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\titanium\bin\ti.js %*
EOF
