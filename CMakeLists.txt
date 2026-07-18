cmake_minimum_required(VERSION 3.15)
project(apong VERSION 0.1.0 LANGUAGES CXX)

if(DEFINED ENV{VCPKG_ROOT})
    set(CMAKE_TOOLCHAIN_FILE "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake"
        CACHE FILEPATH "Vcpkg toolchain file")
endif()

set(VCPKG_TARGET_TRIPLET "x64-linux" CACHE STRING "Target triplet")
set(VCPKG_MANIFEST_MODE ON CACHE BOOL "Enable manifest mode")

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

find_package(SDL3 CONFIG REQUIRED)

add_executable(apong src/main.cpp)
target_link_libraries(apong PUBLIC SDL3::SDL3)
