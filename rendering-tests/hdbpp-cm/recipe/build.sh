cmake ${CMAKE_ARGS} \
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
      -DCMAKE_BUILD_TYPE=Release \
      -S . -B build

cmake --build build -j $CPU_COUNT
cmake --build build --target install
