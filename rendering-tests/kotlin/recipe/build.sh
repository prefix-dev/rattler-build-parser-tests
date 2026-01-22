#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# Build with maven
mkdir -p ${PREFIX}/libexec/kotlin
mkdir -p ${PREFIX}/bin

./gradlew clean dist

cp -r ${SRC_DIR}/dist/kotlinc/bin ${PREFIX}/libexec/kotlin
cp -r ${SRC_DIR}/dist/kotlinc/lib ${PREFIX}/libexec/kotlin

create_wrapper() {
    exe_name=$1

tee ${PREFIX}/bin/${exe_name} << EOF
#!/bin/sh
exec \${CONDA_PREFIX}/libexec/kotlin/bin/${exe_name} "\$@"
EOF
chmod +x ${PREFIX}/bin/${exe_name}

tee ${PREFIX}/bin/${exe_name}.cmd << EOF
call %CONDA_PREFIX%\libexec\kotlin\bin\\${exe_name}.bat %*
EOF
}

export -f create_wrapper

ls ${PREFIX}/libexec/kotlin/bin | grep -v "bat" | xargs -I % bash -c "create_wrapper %"
