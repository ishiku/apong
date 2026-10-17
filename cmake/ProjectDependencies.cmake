include(CPM)

function(game_setup_dependencies)

    if(GAME_ENABLE_TESTING AND NOT TARGET GTest::gtest_main)
        cpmaddpackage(
            NAME
                googletest
            VERSION
                1.18.0
            GITHUB_REPOSITORY
                "google/googletest"
            SYSTEM
                YES
            EXCLUDE_FROM_ALL
                YES
            OPTIONS
                "INSTALL_GTEST OFF"
                "gtest_force_shared_crt OFF")
    endif()

endfunction()

game_setup_dependencies()