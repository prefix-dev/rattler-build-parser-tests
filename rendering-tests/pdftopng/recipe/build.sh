#!/bin/bash

export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"

sed -i 's/c++17/c++20/g' setup.py

cp numberofcharacters.h src/pdftopng/

$PYTHON setup.py build

$PYTHON -m pip install . -vv

