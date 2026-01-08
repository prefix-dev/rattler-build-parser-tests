#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

npm pack --ignore-scripts
npm install -ddd \
    --no-bin-links \
    --global \
    --build-from-source \
    ${SRC_DIR}/napi-rs-cli-${PKG_VERSION}.tgz

mkdir -p ${PREFIX}/bin
tee ${PREFIX}/bin/napi << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/lib/node_modules/@napi-rs/cli/dist/cli.js "\$@"
EOF
chmod +x ${PREFIX}/bin/napi
tee ${PREFIX}/bin/napi-raw << EOF
#!/bin/sh
call \${CONDA_PREFIX}/lib/node_modules/@napi-rs/cli/cli.mjs "\$@"
EOF
chmod +x ${PREFIX}/bin/napi-raw

# Create batch wrapper
tee ${PREFIX}/bin/napi.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\@napi-rs\cli\dist\cli.js %*
EOF
tee ${PREFIX}/bin/napi-raw.cmd << EOF
call %CONDA_PREFIX%\bin\node %CONDA_PREFIX%\lib\node_modules\@napi-rs\cli\cli.js %*
EOF
