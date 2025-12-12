#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# Create package archive and install globally
npm pack --ignore-scripts
npm install -ddd \
    --no-bin-links \
    --global \
    --build-from-source \
    ${SRC_DIR}/typespec-compiler-${PKG_VERSION}.tgz

# Create license report for dependencies
pnpm install
pnpm-licenses generate-disclaimer --prod --output-file=third-party-licenses.txt

mkdir -p ${PREFIX}/bin
tee ${PREFIX}/bin/tsp << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/@typespec/compiler/cmd/tsp.js "\$@"
EOF
chmod +x ${PREFIX}/bin/tsp

tee ${PREFIX}/bin/tsp-server << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/@typespec/compiler/cmd/tsp-server.js "\$@"
EOF
chmod +x ${PREFIX}/bin/tsp-server

tee ${PREFIX}/bin/tsp.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\@typespec\compiler\cmd\tsp.js %*
EOF

tee ${PREFIX}/bin/tsp-server.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\@typespec\compiler\cmd\tsp-server.js %*
EOF
