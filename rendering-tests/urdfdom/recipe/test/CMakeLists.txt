cmake_minimum_required(VERSION 3.12)

project(urdfdom_main)

find_package(urdfdom REQUIRED)

add_executable(urdfdom_main urdfdom_main.cpp)

target_link_libraries(urdfdom_main PRIVATE ${urdfdom_TARGETS})
