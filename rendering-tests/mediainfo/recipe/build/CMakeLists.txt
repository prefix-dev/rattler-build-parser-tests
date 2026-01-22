cmake_minimum_required(VERSION 3.8)
project(MediaInfo_CLI VERSION 1.0.0 LANGUAGES CXX)

# Set C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Include directories
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src/Source)

# Source files
set(CLI_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/src/Source/CLI/CLI_Main.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/src/Source/CLI/CommandLine_Parser.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/src/Source/CLI/Help.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/src/Source/Common/Core.cpp
)

# Find required packages
find_package(ZLIB REQUIRED)
find_package(Threads REQUIRED)
find_package(zenlib REQUIRED)
find_package(mediainfolib REQUIRED)

# Main executable
add_executable(mediainfo_cli ${CLI_SOURCES})

set_target_properties(mediainfo_cli PROPERTIES OUTPUT_NAME mediainfo)

target_compile_definitions(mediainfo_cli PRIVATE UNICODE)
target_compile_definitions(mediainfo_cli PRIVATE MEDIAINFO_DLL_RUNTIME)

# Link libraries
target_link_libraries(mediainfo_cli
    PRIVATE
    mediainfo
    ZLIB::ZLIB
    Threads::Threads
)

install(TARGETS mediainfo_cli DESTINATION bin)
