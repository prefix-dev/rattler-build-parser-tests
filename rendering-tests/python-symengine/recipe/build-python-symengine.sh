#!/usr/bin/env bash

set -eux

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" == "1" ]]; then
    sed -i.bak '1s@.*@#!/usr/bin/env python@' "${BUILD_PREFIX}/bin/cython"
    sed -i.bak '1s@.*@#!/usr/bin/env python@' "${PREFIX}/bin/cython"
    rm "${PREFIX}/bin/cython.bak"
fi

PYTHON_ARGS="-D IGNORE_THIS=1"
for ARG in ${CMAKE_ARGS:+${CMAKE_ARGS}}; do
  if [[ "${ARG}" == "-DCMAKE_"* ]] && [[ "${ARG}" != *";"* ]]; then
    cmake_arg=$(echo "${ARG}" | cut -d= -f1)
    cmake_arg=$(echo "${cmake_arg}" | cut -dD -f2-)
    cmake_val=$(echo "${ARG}" | cut -d= -f2-)
    PYTHON_ARGS="${PYTHON_ARGS};${cmake_arg}=${cmake_val}"
  fi
done

"${PYTHON}" setup.py build_ext "--symengine-dir=${PREFIX}" ${PYTHON_ARGS:+${PYTHON_ARGS}} bdist_wheel
"${PYTHON}" -m pip install dist/symengine*.whl --no-deps --no-build-isolation --disable-pip-version-check
