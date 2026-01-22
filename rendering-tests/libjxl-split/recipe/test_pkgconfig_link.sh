#!/usr/bin/env bash
set -euo pipefail

# Set library path for runtime on macOS (DYLD_LIBRARY_PATH) and Linux (LD_LIBRARY_PATH)
export DYLD_LIBRARY_PATH="${PREFIX}/lib${DYLD_LIBRARY_PATH:+:$DYLD_LIBRARY_PATH}"
export LD_LIBRARY_PATH="${PREFIX}/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

# Test libjxl compile and link
echo "=== Testing compile/link for libjxl ==="
cat > conftest.c <<'EOF'
#include <jxl/decode.h>
int main(void) { (void)JxlDecoderVersion(); return 0; }
EOF

JXL_CFLAGS=$(pkg-config --cflags libjxl)
JXL_LIBS=$(pkg-config --libs libjxl)
echo "CFLAGS: ${JXL_CFLAGS}"
echo "LIBS: ${JXL_LIBS}"

# Use CC if provided, otherwise fall back to cc
"${CC:-cc}" conftest.c ${JXL_CFLAGS} ${JXL_LIBS} -o conftest
./conftest
echo "=== libjxl compile/link test passed ==="

# Test libjxl_threads compile and link
echo "=== Testing compile/link for libjxl_threads ==="
cat > conftest_threads.c <<'EOF'
#include <jxl/thread_parallel_runner.h>
int main(void) { (void)JxlThreadParallelRunner; return 0; }
EOF

JXL_THREADS_CFLAGS=$(pkg-config --cflags libjxl_threads)
JXL_THREADS_LIBS=$(pkg-config --libs libjxl_threads)
echo "CFLAGS: ${JXL_THREADS_CFLAGS}"
echo "LIBS: ${JXL_THREADS_LIBS}"

"${CC:-cc}" conftest_threads.c ${JXL_THREADS_CFLAGS} ${JXL_THREADS_LIBS} -o conftest_threads
./conftest_threads
echo "=== libjxl_threads compile/link test passed ==="
