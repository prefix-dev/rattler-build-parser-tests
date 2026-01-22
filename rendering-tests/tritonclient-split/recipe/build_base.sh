#!/bin/bash

$PYTHON -m pip install tritonclient-*.whl --no-deps -vv

# Extract license file.
unzip tritonclient-*.whl
