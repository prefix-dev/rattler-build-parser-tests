set OPENSSL_ROOT_DIR=%LIBRARY_PREFIX%

mkdir build
cd build

cmake -GNinja ^
         -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
         -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
         -DCMAKE_BUILD_TYPE=Release ^
	 -DCMAKE_POLICY_VERSION_MINIMUM=3.5 ^
         -DBUILD_SHARED_LIBS=True ..
if errorlevel 1 exit 1

cmake --build . --config Release --target all
if errorlevel 1 exit 1

cmake --build . --config Release --target install
if errorlevel 1 exit 1
