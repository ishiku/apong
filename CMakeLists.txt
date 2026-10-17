cmake_minimum_required(VERSION 3.28)
set(СMAKE_CXX_SCAN_FOR_MODULES OFF)

project(apong 
    VERSION 0.1.0
    LANGUAGES CXX)

include(cmake/ProjectBootstrap.cmake)

if(GAME_ENABLE_TESTING)
    enable_testing()
endif()

add_subdirectory(app/client)
add_subdirectory(libs/gem)

