cmake_minimum_required(VERSION 3.22.1)

project("core")

message("CMAKE_SOURCE_DIR ${CMAKE_SOURCE_DIR}")

message("CMAKE_BUILD_TYPE ${CMAKE_BUILD_TYPE}")

if (NOT "${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
    add_compile_options(-O3 -flto -g0 -fno-exceptions -fno-rtti)
    add_link_options(-flto -Wl,--gc-sections,--strip-all)
endif ()

set(LIB_CLASH_PATH "${CMAKE_SOURCE_DIR}/../jniLibs/${ANDROID_ABI}/libclash.so")

include("${CMAKE_CURRENT_LIST_DIR}/verify_core.cmake")
verify_clash_core("${LIB_CLASH_PATH}")

add_compile_definitions(LIBCLASH)
include_directories("${CMAKE_SOURCE_DIR}/includes/${ANDROID_ABI}")
add_library(clash SHARED IMPORTED)
set_target_properties(clash PROPERTIES IMPORTED_LOCATION "${LIB_CLASH_PATH}")
add_library(${CMAKE_PROJECT_NAME} SHARED jni_helper.cpp core.cpp)
target_link_libraries(${CMAKE_PROJECT_NAME} clash)
# An incompatible core must fail the build, not dlopen() on the user's phone.
target_link_options(${CMAKE_PROJECT_NAME} PRIVATE "-Wl,--no-undefined")
