#!/usr/bin/env bash

tar xvf EvtGen-*.tar.gz
cd EvtGen/

mkdir build && cd build

cmake \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
    -DEVTGEN_HEPMC3=ON \
    -DEVTGEN_PYTHIA=ON \
    -DEVTGEN_PHOTOS=ON \
    -DEVTGEN_TAUOLA=ON \
    ../R0*/

cmake --build . --target install "-j${CPU_COUNT}"

# Put the license into a more predictable location
cp ../R0*/COPYING $SRC_DIR/COPYING

# Add the post activate/deactivate scripts
mkdir -p "${PREFIX}/etc/conda/activate.d"
cp "${RECIPE_DIR}/activate.sh" "${PREFIX}/etc/conda/activate.d/activate-evtgen.sh"
cp "${RECIPE_DIR}/activate.csh" "${PREFIX}/etc/conda/activate.d/activate-evtgen.csh"
cp "${RECIPE_DIR}/activate.fish" "${PREFIX}/etc/conda/activate.d/activate-evtgen.fish"

mkdir -p "${PREFIX}/etc/conda/deactivate.d"
cp "${RECIPE_DIR}/deactivate.sh" "${PREFIX}/etc/conda/deactivate.d/deactivate-evtgen.sh"
cp "${RECIPE_DIR}/deactivate.csh" "${PREFIX}/etc/conda/deactivate.d/deactivate-evtgen.csh"
cp "${RECIPE_DIR}/deactivate.fish" "${PREFIX}/etc/conda/deactivate.d/deactivate-evtgen.fish"
