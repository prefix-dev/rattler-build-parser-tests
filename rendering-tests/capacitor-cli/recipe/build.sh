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
tee ${PREFIX}/bin/capacitor << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/@capacitor/cli/bin/capacitor "\$@"
EOF
chmod +x ${PREFIX}/bin/capacitor

tee ${PREFIX}/bin/cap << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/@capacitor/cli/bin/capacitor "\$@"
EOF
chmod +x ${PREFIX}/bin/cap

tee ${PREFIX}/bin/capacitor.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\@capacitor\cli\bin\capacitor %*
EOF

tee ${PREFIX}/bin/cap.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\@capacitor\cli\bin\capacitor %*
EOF
