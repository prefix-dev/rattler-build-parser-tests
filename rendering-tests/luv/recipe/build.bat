cmake -S . -G Ninja -B build %CMAKE_ARGS% ^
    -DWITH_LUA_ENGINE=LuaJIT ^
    -DLUAJIT_LIBRARIES=%LIBRARY_PREFIX%\lib\lua51.lib ^
    -DLUAJIT_INCLUDE_DIR=%LIBRARY_PREFIX%\include\luajit-2.1 ^
    -DWITH_SHARED_LIBUV=ON ^
    -DLIBUV_INCLUDE_DIR=%LIBRARY_PREFIX%\include ^
    -DLIBUV_LIBRARIES=%LIBRARY_PREFIX%\lib\uv.lib ^
    -DLUA_BUILD_TYPE=System ^
    -DLUA_COMPAT53_DIR=%BUILD_PREFIX%\include\lua-compat-5.3 ^
    -DBUILD_MODULE=OFF ^
    -DBUILD_SHARED_LIBS=ON ^
    -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=ON ^
    -DCMAKE_BUILD_TYPE=Release || goto :error
cmake --build build || goto :error
cmake --install build || goto :error

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit 1
