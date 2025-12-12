set -ex

if [[ ${target_platform} != ${build_platform} ]]; then
  # It seems that both headers are found, so just remove these
  rm -rf      "${BUILD_PREFIX}"/lib/python3.*/site-packages/torch/include
  rm -rf "${BUILD_PREFIX}"/venv/lib/python3.*/site-packages/torch/include/torch/csrc/api/include/
fi
PIP_NO_BUILD_ISOLATION=false python -m pip install . -vv --no-build-isolation
