#!/bin/bash

set -ex

mkdir -p _build
pushd _build

# only link libraries we actually use
export GSL_LIBS="-L${PREFIX}/lib -lgsl"
export GSTLAL_LIBS="-L${PREFIX}/lib -lgstlal -lgstlaltags -lgstlaltypes"
export LAL_LIBS="-L${PREFIX}/lib -llal -llalsupport"

# ignore deprecation warning from distutils, it breaks ac_python_devel.m4
export PYTHONWARNINGS="${PYTHONWARNINGS},ignore:The distutils package:DeprecationWarning"

# configure
${SRC_DIR}/configure \
  --disable-static \
  --enable-shared \
  --prefix=${PREFIX} \
;

# build
make -j ${CPU_COUNT} V=1 VERBOSE=1

# install
make -j ${CPU_COUNT} V=1 VERBOSE=1 install
