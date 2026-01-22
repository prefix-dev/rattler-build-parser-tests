#!/bin/env bash

export DT_PYSDK_CSDK_PATH="${PREFIX}/lib/libonesdk_shared.so"
$PYTHON -m pip install . -vv
