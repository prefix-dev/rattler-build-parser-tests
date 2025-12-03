#!/bin/bash

export PYCURL_CURL_CONFIG=$PREFIX/bin/curl-config

$PYTHON -m pip install . --no-deps -vv

rm -rf $PREFIX/share
