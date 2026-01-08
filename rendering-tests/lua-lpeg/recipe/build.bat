SET LUA_INCLUDE_DIR=%PREFIX%\Library\include\luajit-2.1

cmake -S . -B build ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DLUA_INCLUDE_DIR=%LUA_INCLUDE_DIR% ^
    %CMAKE_ARGS% || exit 1
cmake --build build --config Release || exit 1
cmake --install build || exit 1
