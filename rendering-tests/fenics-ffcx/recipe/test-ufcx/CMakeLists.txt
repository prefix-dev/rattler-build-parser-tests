cmake_minimum_required(VERSION 3.21...4.1.0)
set(CMAKE_VERBOSE_MAKEFILE ON)
project(test-ufcx)
find_package(ufcx REQUIRED CONFIG)
add_executable(test-ufcx test-ufcx.cpp)
target_link_libraries(test-ufcx PUBLIC ufcx::ufcx)

install(TARGETS test-ufcx)
