set(GAME_GEM_TESTS_SOURCES
    gem_test.cpp)

add_executable(game_gem_tests ${GAME_GEM_TESTS_SOURCES})

target_link_libraries(game_gem_tests 
    PRIVATE
        game::gem
        GTest::gtest_main
)

game_project_settings(game_gem_tests)

include(GoogleTest)
gtest_discover_tests(game_gem_tests)