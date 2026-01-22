:: https://github.com/rust-lang/cargo/issues/10583#issuecomment-1129997984
set CARGO_NET_GIT_FETCH_WITH_CLI=true
set IS_IN_RERUN_WORKSPACE=no

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml 
if errorlevel 1 exit 1

:: The CI environment variable means something specific to Rerun. Unset it.
set "CI="

mkdir build_cxx
cd build_cxx

cmake %CMAKE_ARGS% -GNinja .. ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DBUILD_SHARED_LIBS:BOOL=ON ^
      -DRERUN_ARROW_LINK_SHARED:BOOL=ON ^
      -DRERUN_DOWNLOAD_AND_BUILD_ARROW:BOOL=OFF ^
      -DRERUN_INSTALL_RERUN_C:BOOL=OFF ^
      -DCMAKE_FIND_PACKAGE_TARGETS_GLOBAL:BOOL=ON 
if errorlevel 1 exit 1

cmake --build . --config Release
if errorlevel 1 exit 1

cmake --build . --config Release --target install
if errorlevel 1 exit 1

.\rerun_cpp\tests\rerun_sdk_tests
if errorlevel 1 exit 1
