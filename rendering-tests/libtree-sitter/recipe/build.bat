copy %RECIPE_DIR%\CMakeLists.txt %SRC_DIR%
cmake -S . -G Ninja -B build ^
    -DBUILD_SHARED_LIBS=ON ^
    -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=ON ^
    %CMAKE_ARGS% || goto :error
cmake --build build || goto :error
cmake --install build || goto :error
move %LIBRARY_PREFIX%\lib\tree-sitter.dll %LIBRARY_PREFIX%\bin

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit 1
