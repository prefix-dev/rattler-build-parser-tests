cd IlmBase
mkdir build
cd build

cmake -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
      -DCMAKE_FIND_ROOT_PATH="%LIBRARY_PREFIX%" ^
      -DBUILD_SHARED_LIBS=ON ^
      -DILMBASE_LIB_SUFFIX="" ^
      -DCMAKE_BUILD_TYPE=Release ^
      -G "Ninja" ..

ninja install