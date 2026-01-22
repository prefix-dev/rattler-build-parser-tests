copy %RECIPE_DIR%\CMakeLists.txt %SRC_DIR%
cmake -S . -G Ninja -B build ^
    -DUNIBILIUM_INCLUDE_DIRS=%LIBRARY_PREFIX%\include ^
    -DUNIBILIUM_LIBRARIES=%LIBRARY_PREFIX%\lib\unibilium.lib ^
    -DBUILD_SHARED_LIBS=ON ^
    -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=ON ^
    %CMAKE_ARGS% || goto :error
cmake --build build || goto :error
cmake --install build || goto :error
copy build\termkey.dll %LIBRARY_PREFIX%\bin

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit 1
