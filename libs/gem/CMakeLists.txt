add_library(game_gem src/gem.cpp)
add_library(game::gem ALIAS game_gem)

game_project_settings(game_gem)

target_include_directories(game_gem
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
)

if(GAME_ENABLE_TESTING)
    add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/tests)
endif()