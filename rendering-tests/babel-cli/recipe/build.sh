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
tee ${PREFIX}/bin/babel << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/@babel/cli/bin/babel.js "\$@"
EOF
chmod +x ${PREFIX}/bin/babel

mkdir -p ${PREFIX}/bin
tee ${PREFIX}/bin/babel-external-helpers << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/@babel/cli/bin/babel-external-helpers.js "\$@"
EOF
chmod +x ${PREFIX}/bin/babel-external-helpers

tee ${PREFIX}/bin/babel.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\@babel\cli\bin\babel.js %*
EOF

tee ${PREFIX}/bin/babel-external-helpers.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\@babel\cli\bin\babel-external-helpers.js %*
EOF
