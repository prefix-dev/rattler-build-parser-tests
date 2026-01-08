cmake_minimum_required(VERSION 3.17.0 FATAL_ERROR)

project(cmake_test_nvtx LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)

find_package(nvtx3 REQUIRED)

message(STATUS "NVTX info:")
message(STATUS "    config: ${nvtx3_CONFIG}")
message(STATUS "    version: ${nvtx3_VERSION}")
