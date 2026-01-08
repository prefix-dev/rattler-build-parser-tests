cmake_minimum_required(VERSION 3.13)
project (lpeg LANGUAGES C)

find_package(Lua REQUIRED)
if(NOT LUA_FOUND)
    message(FATAL_ERROR "Lua library not found. Please ensure Lua is installed and accessible.")
endif()

file(GLOB LPEG_SOURCES ${CMAKE_SOURCE_DIR}/*.c)

add_library(lpeg_shared SHARED ${LPEG_SOURCES})
set_target_properties(lpeg_shared PROPERTIES OUTPUT_NAME "lpeg")
target_include_directories(lpeg_shared PRIVATE ${LUA_INCLUDE_DIR})
target_link_libraries(lpeg_shared PRIVATE ${LUA_LIBRARY})

add_library(lpeg_static STATIC ${LPEG_SOURCES})
set_target_properties(lpeg_static PROPERTIES OUTPUT_NAME "lpeg")
target_include_directories(lpeg_static PRIVATE ${LUA_INCLUDE_DIR})
target_link_libraries(lpeg_static PRIVATE ${LUA_LIBRARY})

install(
    TARGETS lpeg_shared
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin
)

install(
    TARGETS lpeg_static
    ARCHIVE DESTINATION lib
)

install(FILES re.lua test.lua
    DESTINATION share/lua/5.1
)
