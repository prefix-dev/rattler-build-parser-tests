#!/bin/bash

cmake ^
    %CMAKE_ARGS% ^
    -S lang/c++ ^
    -B build ^
    -G Ninja ^
    -DAVRO_BUILD_TESTS=OFF ^
    -DBOOST_ROOT:PATH="%PREFIX%" ^
    -DSNAPPY_ROOT_DIR:PATH="%PREFIX%" ^
    -DCMAKE_BUILD_TYPE:STRING=Release ^
    -DBUILD_SHARED_LIBS=ON ^
    -DCMAKE_CXX_STANDARD=17 ^
    -DCMAKE_CXX_STANDARD_REQUIRED=ON ^
    -DCMAKE_CXX_EXTENSIONS=OFF ^
    -DCMAKE_VERBOSE_MAKEFILE=ON
if errorlevel 1 exit 1

cmake --build build --config Release
if errorlevel 1 exit 1

cmake --build build --config Release --target install
if errorlevel 1 exit 1
