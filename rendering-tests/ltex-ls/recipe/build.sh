#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# Build archive with jar and other files
${PYTHON} -u tools/createCompletionLists.py
mvn -B -e clean compile package -DskipTests=True

# Extract newly built archive
tar xzf target/ltex-ls-plus-${PKG_VERSION}.tar.gz -C .

mkdir -p ${PREFIX}/bin
mkdir -p ${PREFIX}/libexec/ltex-ls
cp -r ltex-ls-plus-${PKG_VERSION}/* ${PREFIX}/libexec/ltex-ls

# Create bash and batch wrappers for ltex-ls and ltex-cli
tee ${PREFIX}/bin/ltex-cli << EOF
exec \${CONDA_PREFIX}/libexec/ltex-ls/bin/ltex-cli-plus "\$@"
EOF
chmod +x ${PREFIX}/bin/ltex-cli

tee ${PREFIX}/bin/ltex-ls << EOF
exec \${CONDA_PREFIX}/libexec/ltex-ls/bin/ltex-ls-plus "\$@"
EOF
chmod +x ${PREFIX}/bin/ltex-ls

tee ${PREFIX}/bin/ltex-cli.cmd << EOF
call %CONDA_PREFIX%\libexec\ltex-ls\bin\ltex-cli-plus.bat %*
EOF

tee ${PREFIX}/bin/ltex-ls.cmd << EOF
call %CONDA_PREFIX%\libexec\ltex-ls\bin\ltex-ls-plus.bat %*
EOF

tee ${PREFIX}/bin/ltex-cli-plus << EOF
exec \${CONDA_PREFIX}/libexec/ltex-ls/bin/ltex-cli-plus "\$@"
EOF
chmod +x ${PREFIX}/bin/ltex-cli-plus

tee ${PREFIX}/bin/ltex-ls-plus << EOF
exec \${CONDA_PREFIX}/libexec/ltex-ls/bin/ltex-ls-plus "\$@"
EOF
chmod +x ${PREFIX}/bin/ltex-ls-plus

tee ${PREFIX}/bin/ltex-cli-plus.cmd << EOF
call %CONDA_PREFIX%\libexec\ltex-ls\bin\ltex-cli-plus.bat %*
EOF

tee ${PREFIX}/bin/ltex-ls-plus.cmd << EOF
call %CONDA_PREFIX%\libexec\ltex-ls\bin\ltex-ls-plus.bat %*
EOF

# Download licenses for dependencies
mvn license:download-licenses -Dgoal=download-licenses
