#!/bin/bash

set -exuo pipefail

mkdir -p $PREFIX/lib
mkdir -p $PREFIX/bin
cp $SRC_DIR/$PKG_NAME-$PKG_VERSION.jar $PREFIX/lib/bfg.jar

cat <<'EOF' >${PREFIX}/bin/bfg
#!/bin/bash

PREFIX_DIR=$(dirname ${BASH_SOURCE})
# Make PREDIX_DIR absolute
if [[ $(uname) == 'Linux' ]]; then
  PREFIX_DIR=$(readlink -f ${PREFIX_DIR})
else
  pushd ${PREFIX_DIR} > /dev/null
  PREFIX_DIR=$(pwd -P)
  popd > /dev/null
fi
# Go one level up
PREFIX_DIR=$(dirname ${PREFIX_DIR})

java -jar ${PREFIX_DIR}/lib/bfg.jar "$@"
EOF
chmod +x ${PREFIX}/bin/bfg
