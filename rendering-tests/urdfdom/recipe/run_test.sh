#!/bin/bash -e

# Test linking against the urdfdom library
cd test

# Compile example that links urdfdom
cmake -GNinja -DCMAKE_BUILD_TYPE=Release .

cmake --build . --config Release

# Run example
./urdfdom_main
