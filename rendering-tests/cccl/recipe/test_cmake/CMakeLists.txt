cmake_minimum_required(VERSION 3.17.0 FATAL_ERROR)

project(cmake_test_cccl LANGUAGES CUDA)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)

find_package(CUDAToolkit REQUIRED)
find_package(CCCL REQUIRED)

message(STATUS "CCCL info:")
message(STATUS "    config: ${CCCL_CONFIG}")
message(STATUS "    version: ${CCCL_VERSION}")
