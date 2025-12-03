#!/bin/bash

set -exuo pipefail

pushd src/debugpy/_vendored/pydevd/pydevd_attach_to_process
pushd linux_and_mac

if [[ "${target_platform}" == osx-* ]]; then
    SHARED_LIBRARY="attach${SHLIB_EXT}"
    EXTRA_FLAGS="-dynamiclib -lc -nostartfiles"
else
    if [[ "${target_platform}" == "linux-64" ]]; then
        SHARED_LIBRARY="attach_linux_amd64${SHLIB_EXT}"
    elif [[ "${target_platform}" == "linux-aarch64" ]]; then
        SHARED_LIBRARY="attach_linux_arm64${SHLIB_EXT}"
    fi
    EXTRA_FLAGS="-shared -nostartfiles"
fi

if [[ "${target_platform}" != "linux-ppc64le" ]]; then
    ${CXX} ${CXXFLAGS} ${LDFLAGS} ${EXTRA_FLAGS} -o ${SHARED_LIBRARY} attach.cpp
    mv ${SHARED_LIBRARY} ../
fi

popd
popd
${PYTHON} -m pip install . -vv
