function(game_prevent_in_source_builds)
    file(REAL_PATH "${CMAKE_SOURCE_DIR}" srcdir)
    file(REAL_PATH "${CMAKE_BINARY_DIR}" bindir)

    if("${srcdir}" STREQUAL "${bindir}")
        message(FATAL_ERROR "In-source builds are disabled")
    endif()
endfunction()

game_prevent_in_source_builds()