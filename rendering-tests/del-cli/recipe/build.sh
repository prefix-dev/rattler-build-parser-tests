#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# Create package archive and install globally
npm pack --ignore-scripts
npm install -ddd \
    --no-bin-links \
    --global \
    --build-from-source \
    ${SRC_DIR}/${PKG_NAME}-${PKG_VERSION}.tgz

mkdir -p ${PREFIX}/bin
tee ${PREFIX}/bin/del-cli << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/del-cli/cli.js "\$@"
EOF
chmod +x ${PREFIX}/bin/del-cli

tee ${PREFIX}/bin/del << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/del-cli/cli.js "\$@"
EOF
chmod +x ${PREFIX}/bin/del

tee ${PREFIX}/bin/del-cli.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\del-cli\cli.js %*
EOF

tee ${PREFIX}/bin/del.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\del-cli\cli.js %*
EOF
